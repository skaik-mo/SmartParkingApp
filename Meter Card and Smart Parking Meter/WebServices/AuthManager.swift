//
//  AuthManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 02/04/2022.
//

import Foundation
import SVProgressHUD

import FBSDKCoreKit
import FBSDKLoginKit

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

typealias Handler = ((_ auth: AuthModel?, _ isRegister: Bool?, _ message: String?) -> Void)?
typealias ResultHandler = ((_ auth: AuthModel?, _ message: String?) -> Void)?
typealias FailureHandler = ((_ error: Error?) -> Void)?

class AuthManager {

    static let shared = AuthManager()

    private let db = Firestore.firestore()
    private var usersFireStoreReference: CollectionReference?

    private let idKey = "ID"
    private let nameKey = "Name"
    private let emailKey = "Email"
    private let passwordKey = "Password"
    private let typeAuthKey = "TypeAuth"
    private let plateNumberKey = "PlateNumber"
    private let urlImage = "URLImage"
    private let urlLicense = "URLLicense"
    private let isLoginBySocial = "IsLoginBySocial"

    private let loginManager = LoginManager()


    private init() {
        Auth.auth().useAppLanguage()
        self.usersFireStoreReference = db.collection("users")
    }

    func signUpByEmail(auth: AuthModel, data: Data?, result: ResultHandler) {
        guard let email = auth.email, let password = auth.password else { result?(nil, "The fields is empty."); return }
        SVProgressHUD.showSVProgress()
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let _error = error {
                SVProgressHUD.dismiss()
                result?(nil, _error.localizedDescription)
                return
            }
            auth.id = authResult?.user.uid

            self.setAuth(auth: auth, dataDrivingLicense: data) { error in
                if let _error = error {
                    // here should deleted user from Authentication and re-sign up again
                    result?(nil, _error.localizedDescription)
                    return
                }
                result?(auth, nil)
            }
        }
    }

    func signInByEmail(auth: AuthModel, result: ResultHandler) {
        guard let email = auth.email, let password = auth.password else { result?(nil, "The fields is empty."); return }
        SVProgressHUD.showSVProgress()
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let _error = error {
                SVProgressHUD.dismiss()
                result?(nil, _error.localizedDescription)
                return
            }
            let id = authResult?.user.uid

            self.getAuth(id: id, password: auth.password) { auth, message in
                SVProgressHUD.dismiss()
                if let _auth = auth {
                    // login and go home screen
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
            failure?(nil)
        } catch let error as NSError {
            failure?(error)
        }
    }

    private func reauthenticate(failure: FailureHandler) {
        let auth = getLocalAuth()
        guard let _email = auth.email, let _password = auth.password else { /*message error*/ return }
        let credential = EmailAuthProvider.credential(withEmail: _email, password: _password)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { auth, error in
            if let _error = error {
                failure?(_error)
                return
            }
            failure?(nil)
        })
    }

    func updatePassword(auth: AuthModel, failure: FailureHandler) {
        guard let password = auth.password else { return }
        SVProgressHUD.showSVProgress()
        self.reauthenticate { error in
            if let _error = error {
                SVProgressHUD.dismiss()
                failure?(_error)
                return
            }
            Auth.auth().currentUser?.updatePassword(to: password) { error in
                SVProgressHUD.dismiss()
                if let _error = error {
                    failure?(_error)
                    return
                }
                self.saveAuth(auth: auth)
                failure?(nil)
            }
        }
    }

    func resetPassword(email: String, failure: FailureHandler) {
        SVProgressHUD.showSVProgress()
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            SVProgressHUD.dismiss()
            if let _error = error {
                failure?(_error)
                return
            }
            failure?(nil)
        }
    }

    private func setEmail(email: String?, failure: FailureHandler) {
        guard let _email = email, Auth.auth().currentUser?.email != _email else { failure?(nil); return }
        debugPrint("email \(_email)")
        self.reauthenticate { error in
            if let _error = error {
                failure?(_error)
                return
            }
            Auth.auth().currentUser?.updateEmail(to: _email) { error in
                if let _error = error {
                    failure?(_error)
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
    func setAuth(auth: AuthModel, dataDrivingLicense: Data?, dataAuth: Data? = nil, failure: FailureHandler) {
        guard let _usersFireStoreReference = self.usersFireStoreReference, let _id = auth.id, let _name = auth.name else { return }
        
        SVProgressHUD.showSVProgress()
        var data: [String: Data?] = [:]
        let authPath = "Auth/\(_id)/AuthImage/\(_name).jpg"
        let authDrivingLicense = "Auth/\(_id)/DrivingLicense/\(_name) driver's license.jpg"
        if let _dataAuth = dataAuth {
            data[authPath] = _dataAuth
        }
        if let _dataDrivingLicense = dataDrivingLicense {
            data[authDrivingLicense] = _dataDrivingLicense
        }

        FirebaseStorageManager.shared.uploadFile(data: data) { urls in
            for url in urls {
                if url.key == authPath {
                    auth.urlImage = url.value.absoluteString
                } else if url.key == authDrivingLicense {
                    auth.urlLicense = url.value.absoluteString
                }
            }
            self.setEmail(email: auth.email) { error in
                if let _error = error {
                    // Email Update Failed
                    SVProgressHUD.dismiss()
                    failure?(_error)
                    return
                }
                _usersFireStoreReference.document(_id).setData(auth.getDictionary()) { error in
                    SVProgressHUD.dismiss()
                    if let _error = error {
                        failure?(_error)
                        return
                    }
                    // Added Auth
                    self.saveAuth(auth: auth)
                    failure?(nil)
                }
            }
        }
    }

    private func getAuth(id: String?, password: String? = nil, result: ResultHandler) {
        guard let _usersFireStoreReference = self.usersFireStoreReference, let _id = id else { return }
        _usersFireStoreReference.document(_id).getDocument { snapshot, error in
            if let _error = error {
                result?(nil, _error.localizedDescription)
                return
            }
            if let data = snapshot?.data() {
                // exsist Auth
                let _auth = AuthModel.init(id: _id, password: password, dictionary: data)
                result?(_auth, nil)
                return
            }
            result?(nil, "Auth desn't exsist!")

        }
    }

}

// MARK: - SetImage
extension AuthManager {

    func setImage(authImage: UIImageView, urlImage: String? = nil) {
        var image = ""
        if let _urlImage = urlImage {
            image = _urlImage

        }
        debugPrint("setImage \(image)")
//        else if let _urlImage = AuthManager.shared.getLocalAuth().urlImage {
//            image = _urlImage
//
//        }
        let url = URL.init(string: image)
        authImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ic_placeholderPerson"))
    }

}

// MARK: - User Defualt
extension AuthManager {

    private func saveAuth(auth: AuthModel) {
        UserDefaults.standard.set(auth.id, forKey: self.idKey)
        UserDefaults.standard.set(auth.name, forKey: self.nameKey)
        UserDefaults.standard.set(auth.email, forKey: self.emailKey)
        UserDefaults.standard.set(auth.password, forKey: self.passwordKey)
        UserDefaults.standard.set(auth.typeAuth?.rawValue, forKey: self.typeAuthKey)
        UserDefaults.standard.set(auth.plateNumber, forKey: self.plateNumberKey)
        UserDefaults.standard.set(auth.urlImage, forKey: self.urlImage)
        UserDefaults.standard.set(auth.urlLicense, forKey: self.urlLicense)
        UserDefaults.standard.set(auth.isLoginBySocial, forKey: self.isLoginBySocial)
        UserDefaults.standard.synchronize()
    }

    private func clearLocalAuth() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }

    func getLocalAuth() -> AuthModel {
        let id = UserDefaults.standard.string(forKey: self.idKey)
        let name = UserDefaults.standard.string(forKey: self.nameKey)
        let email = UserDefaults.standard.string(forKey: self.emailKey)
        let password = UserDefaults.standard.string(forKey: self.passwordKey)
        let typeAuth = UserDefaults.standard.value(forKey: self.typeAuthKey) as? Int
        let plateNumber = UserDefaults.standard.string(forKey: self.plateNumberKey)
        let urlImage = UserDefaults.standard.string(forKey: self.urlImage)
        let urlLicense = UserDefaults.standard.string(forKey: self.urlLicense)
        var isLoginBySocial = false

        if let _isLoginBySocial = UserDefaults.standard.value(forKey: self.isLoginBySocial) as? Bool {
            isLoginBySocial = _isLoginBySocial
        }

        return AuthModel.init(id: id, name: name, email: email, password: password, plateNumber: plateNumber, typeAuth: typeAuth?.getTypeAuth, urlImage: urlImage, urlLicense: urlLicense, isLoginBySocial: isLoginBySocial)
    }

}

// MARK: - Sign in by facebook
extension AuthManager {

    func signInByFacebook(vc: UIViewController, result: ((_ auth: AuthModel?, _ isRegister: Bool?, _ message: String?) -> Void)?) {
        loginManager.logIn(permissions: [.publicProfile, .email, .userPhotos], viewController: vc) { loginResult in
            switch loginResult {

            case .success(granted: _, declined: _, token: let token):
                debugPrint("sign in by facebook success")
                SVProgressHUD.showSVProgress()
                self.getImageURL(token: token?.tokenString) { imageURL in
                    self.signInFacebookAccountToFirebase(urlImage: imageURL) { auth, isRegister, message in
                        SVProgressHUD.dismiss()
                        result?(auth, isRegister, message)
                    }
                }
            case .cancelled:
                result?(nil, nil, nil)
                break
            case .failed(let error):
                result?(nil, nil, error.localizedDescription)
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
            let authModel = AuthModel.init(id: id, name: auth?.user.displayName, email: auth?.user.email)

            self.getAuth(id: id, password: nil) { getAuth, message in
                if let _message = message {
                    // Unregistered
                    if let _urlImage = urlImage {
                        authModel.urlImage = _urlImage
                    }
                    authModel.isLoginBySocial = true
                    result?(authModel, true, _message)
                } else {
                    // Already registered
                    if let _getAuth = getAuth {
                        _getAuth.isLoginBySocial = true
                        self.saveAuth(auth: _getAuth)
                        result?(_getAuth, false, nil)
                    } else {
                        result?(nil, false, "error sign in by facebook")
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
