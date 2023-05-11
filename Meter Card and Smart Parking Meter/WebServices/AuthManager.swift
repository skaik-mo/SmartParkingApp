//
//  AuthManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 02/04/2022.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthManager {
    static let shared = AuthManager()

    private let db = Firestore.firestore()
    private var usersFireStoreReference: CollectionReference?

    private let userKey = "USER"
    private let idKey = "ID"

    typealias Handler = ((_ auth: AuthModel?, _ isNewUser: Bool, _ message: String?) -> Void)?
    typealias ResultHandler = ((_ auth: AuthModel?, _ message: String?) -> Void)?
    typealias ResultAllAuthHandler = ((_ users: [AuthModel], _ message: String?) -> Void)?


    private init() {
        Auth.auth().useAppLanguage()
        self.usersFireStoreReference = db.collection("users")
    }

    func signUpByEmail(auth: AuthModel, data: Data?, result: ResultHandler) {
        guard let email = auth.email, let password = auth.password else { result?(nil, EMPTY_FIELDS_MESSAGE); return }
        Helper.showIndicator(true)
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let _error = error {
                Helper.dismissIndicator(true)
                result?(nil, _error.localizedDescription)
                return
            }
            auth.id = authResult?.user.uid

            self.setAuth(auth: auth, dataDrivingLicense: data, isShowIndicator: false) { errorMessage in
                Helper.dismissIndicator(true)
                if let _errorMessage = errorMessage {
                    // here should deleted user from Authentication and re-sign up again
                    result?(nil, _errorMessage)
                    return
                }
                result?(auth, nil)
            }
        }
    }

    func signInByEmail(auth: AuthModel, result: ResultHandler) {
        guard let email = auth.email, let password = auth.password else { result?(nil, EMPTY_FIELDS_MESSAGE); return }
        Helper.showIndicator(true)
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let _error = error {
                Helper.dismissIndicator(true)
                result?(nil, _error.localizedDescription)
                return
            }
            let id = authResult?.user.uid

            self.getAuth(id: id) { auth, message in
                Helper.dismissIndicator(true)
                if let _auth = auth {
                    // login and go home screen
                    _auth.email = email
                    _auth.password = password
                    self.saveAuth(auth: _auth)
                    result?(_auth, message)
                } else {
                    // Can't login
                    result?(nil, message)
                }
            }
        }
    }

    func logout(failure: FailureHandler) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            clearLocalAuth()
            let loginManager = LoginManager()
            loginManager.logOut()
            AccessToken.current = nil
            Profile.current = nil
            
            failure?(nil)
        } catch let error as NSError {
            failure?(error.localizedDescription)
        }
    }

    private func reauthenticate(failure: FailureHandler) {
        guard let auth = getLocalAuth(), let _email = auth.email, let _password = auth.password else { failure?(EMPTY_FIELDS_MESSAGE); return }
        let credential = EmailAuthProvider.credential(withEmail: _email, password: _password)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { auth, error in
            if let _error = error {
                failure?(_error.localizedDescription)
                return
            }
            failure?(nil)
        })
    }

    func updatePassword(auth: AuthModel, failure: FailureHandler) {
        guard let password = auth.password else { return }
        Helper.showIndicator(true)
        self.reauthenticate { error in
            if let _error = error {
                Helper.dismissIndicator(true)
                failure?(_error)
                return
            }
            Auth.auth().currentUser?.updatePassword(to: password) { error in
                Helper.dismissIndicator(true)
                if let _error = error {
                    failure?(_error.localizedDescription)
                    return
                }
                self.saveAuth(auth: auth)
                failure?(nil)
            }
        }
    }

    func resetPassword(email: String, failure: FailureHandler) {
        Helper.showIndicator(true)
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            Helper.dismissIndicator(true)
            if let _error = error {
                failure?(_error.localizedDescription)
                return
            }
            failure?(nil)
        }
    }

    private func setEmail(email: String?, failure: FailureHandler) {
        guard let _email = email, Auth.auth().currentUser?.email != _email.lowercased() else { failure?(nil); return }
        debugPrint("email \(_email)")
        self.reauthenticate { error in
            if let _error = error {
                failure?(_error)
                return
            }
            Auth.auth().currentUser?.updateEmail(to: _email) { error in
                if let _error = error {
                    failure?(_error.localizedDescription)
                    return
                }
                failure?(nil)
            }
        }
    }

}

// MARK: - Firestore
extension AuthManager {

    // Add Or Update Auth
    func setAuth(auth: AuthModel?, dataDrivingLicense: Data? = nil, dataAuth: Data? = nil, isShowIndicator: Bool = true, failure: FailureHandler) {
        guard let _usersFireStoreReference = self.usersFireStoreReference, let _auth = auth, let _id = _auth.id else { return }

        Helper.showIndicator(isShowIndicator)
        var data: [String: Data?] = [:]
        let authPath = "Auth/\(_id)/AuthImage.jpeg"
        let authDrivingLicense = "Auth/\(_id)/Driver's license.jpeg"
        if let _dataAuth = dataAuth {
            data[authPath] = _dataAuth
        }
        if let _dataDrivingLicense = dataDrivingLicense {
            data[authDrivingLicense] = _dataDrivingLicense
        }

        FirebaseStorageManager.shared.uploadFile(data: data) { urls in
            for url in urls {
                if url.key == authPath {
                    _auth.urlImage = url.value.absoluteString
                } else if url.key == authDrivingLicense {
                    _auth.urlLicense = url.value.absoluteString
                }
            }
            self.setEmail(email: _auth.email) { error in
                if let _error = error {
                    // Email Update Failed
                    Helper.dismissIndicator(isShowIndicator)
                    failure?(_error)
                    return
                }
                _usersFireStoreReference.document(_id).setData(_auth.getDictionary()) { error in
                    Helper.dismissIndicator(isShowIndicator)
                    if let _error = error {
                        failure?(_error.localizedDescription)
                        return
                    }
                    // Added Auth
                    self.saveAuth(auth: _auth)
                    failure?(nil)
                }
            }
        }
    }

    func getAuth(id: String?, result: ResultHandler) {
        guard let _usersFireStoreReference = self.usersFireStoreReference, let _id = id else { return }
        _usersFireStoreReference.document(_id).getDocument { snapshot, error in
            if let _error = error {
                result?(nil, _error.localizedDescription)
                return
            }
            let _auth = AuthModel.init(id: _id, dictionary: snapshot?.data())
            result?(_auth, nil)
        }
    }

    func getAllAuth(result: ResultAllAuthHandler) {
        guard let _usersFireStoreReference = self.usersFireStoreReference else { return }
        _usersFireStoreReference.getDocuments { snapshot, error in
            if let _error = error {
                result?([], _error.localizedDescription)
                return
            }
            var users: [AuthModel] = []

            for auth in snapshot?.documents ?? [] {
                if let _auth = AuthModel.init(id: auth.documentID, dictionary: auth.data()) {
                    users.append(_auth)
                }
            }
            result?(users, nil)
        }
    }

    func setFavourite(parkingID id: String?, isFavourite: Bool?, failure: FailureHandler) {
        guard let auth = self.getLocalAuth(), let _id = id, let _isFavourite = isFavourite else { return }

        if let index = auth.favouritedParkingsIDs.firstIndex(of: _id), !_isFavourite {
            auth.favouritedParkingsIDs.remove(at: index)
        } else {
            auth.favouritedParkingsIDs.append(_id)
        }
        setAuth(auth: auth, isShowIndicator: false) { error in
            if let _error = error {
                failure?(_error)
                return
            }
            failure?(nil)
        }
    }

    func getFavourite(parkingID id: String?) -> Bool {
        guard let auth = self.getLocalAuth(), let _id = id else { return false }
        return auth.favouritedParkingsIDs.contains(_id)

    }
}


// MARK: - User Defualt
extension AuthManager {

    private func saveAuth(auth: AuthModel) {
        let data = try? JSONSerialization.data(withJSONObject: auth.getDictionary(), options: .fragmentsAllowed)
        UserDefaults.standard.setValue(data, forKey: self.userKey)
        UserDefaults.standard.set(auth.id, forKey: self.idKey)
        UserDefaults.standard.synchronize()
    }

    func getLocalAuth() -> AuthModel? {
        let id = UserDefaults.standard.string(forKey: idKey)
        let data = UserDefaults.standard.value(forKey: userKey) as? Data
        if let _data = data {
            let dictionary = try? JSONSerialization.jsonObject(with: _data, options: .fragmentsAllowed) as? [String: Any?]
            return AuthModel.init(id: id, dictionary: dictionary)
        }
        return nil
    }

    private func clearLocalAuth() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}

// MARK: - Sign in by facebook
extension AuthManager {

    func signInByFacebook(vc: UIViewController, result: Handler) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email, .userPhotos], viewController: vc) { loginResult in
            switch loginResult {
            case .success(granted: _, declined: _, token: let token):
                Helper.showIndicator(true)
                debugPrint("sign in by facebook success")
                self.getImageURL(token: token?.tokenString) { imageURL in
                    self.signInFacebookAccountToFirebase(urlImage: imageURL) { auth, isNewUser, message in
                        Helper.dismissIndicator(true)
                        result?(auth, isNewUser, message)
                    }
                }
            case .cancelled:
                result?(nil, false, nil)
                break
            case .failed(let error):
                result?(nil, false, error.localizedDescription)
            }
        }
    }

    private func signInFacebookAccountToFirebase(urlImage: String?, result: Handler) {
        guard let token = AccessToken.current?.tokenString else { result?(nil, false, nil); return }
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { auth, error in
            if let _error = error {
                result?(nil, false, _error.localizedDescription)
                return
            }
            let id = auth?.user.uid
            let authModel = AuthModel.init(id: id, name: auth?.user.displayName, email: auth?.user.email, isLoginBySocial: true, urlImage: urlImage)

            self.getAuth(id: id) { getAuth, message in
                if let _message = message {
                    result?(nil, false, _message)
                } else {
                    if let _getAuth = getAuth {
                        // Already registered
                        //_getAuth.isLoginBySocial = true || no need, already saved as a social
                        _getAuth.urlImage = urlImage
                        self.saveAuth(auth: _getAuth)
                        result?(_getAuth, false, nil)
                    } else {
                        // Unregistered
                        self.saveAuth(auth: authModel)
                        result?(authModel, true, nil)
                    }
                }
            }
        }
    }

    // Get image url from facebook account
    private func getImageURL(token: String?, handler: @escaping (_ imageURL: String?) -> Void) {
        guard let _token = token else { handler(nil); return }

        let params = ["fields": "picture.type(large)"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params, tokenString: _token, version: nil, httpMethod: .get)
        graphRequest.start { (connection, result, error) in
            if let result = result as? [String: Any] {
                if let picture = result["picture"] as? [String: Any] {
                    if let data = picture["data"] as? [String: Any] {
                        if let imageURL = data["url"] as? String {
                            handler(imageURL)
                            return
                        }
                    }
                }
            }
            handler(nil)
        }
    }

}
