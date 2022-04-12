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

typealias ResultHandler = ((_ auth: AuthModel?, _ message: String?) -> Void)?
typealias FailureHandler = ((_ error: Error?) -> Void)?

class AuthManager {

    static let shared = AuthManager()

    private let db = Firestore.firestore()
    private var usersFireStoreReference: CollectionReference?
    private var storage = Storage.storage (url: "gs://parking-meter-343901.appspot.com")

    private let idKey = "ID"
    private let nameKey = "Name"
    private let emailKey = "Email"
    private let passwordKey = "Password"
    private let typeAuthKey = "TypeAuth"
    private let plateNumberKey = "PlateNumber"
    private let urlImage = "URLImage"

    private let loginManager = LoginManager()


    private init() {
        Auth.auth().useAppLanguage()
        self.usersFireStoreReference = db.collection("users")
    }

    func signUpByEmail(auth: AuthModel, data: Data?, result: ResultHandler) {
        guard let email = auth.email, let password = auth.password else { result?(nil, "The fields is empty."); return }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let _error = error {
                result?(nil, _error.localizedDescription)
                return
            }
            auth.id = authResult?.user.uid

            self.setAuth(auth: auth, data: data) { error in
                if let _error = error {
                    // here should deleted user from Authentication and re-sign up again
                    result?(nil, _error.localizedDescription)
                    return
                }
                result?(auth, "")
            }
        }
    }
    
    func signInByEmail(auth: AuthModel, result: ResultHandler) {
        guard let email = auth.email, let password = auth.password else { result?(nil, "The fields is empty."); return }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let _error = error {
                result?(nil, _error.localizedDescription)
                return
            }
            let id = authResult?.user.uid

            self.getAuth(id: id, password: auth.password) { auth, message in
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

    func updatePassword(oldPassword: String, newPassword: String, failure: FailureHandler) {
        if self.getLocalAuth().password != oldPassword {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "The current password is incorrect"])
            failure?(error)
            return
        }
        self.reauthenticate { error in
            if let _error = error {
                failure?(_error)
                return
            }
            Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                if let _error = error {
                    failure?(_error)
                    return
                }
                failure?(nil)
            }
        }
    }

    func resetPassword(email: String, failure: FailureHandler) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
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
    func setAuth(auth: AuthModel, data: Data?, failure: FailureHandler) {
        guard let _usersFireStoreReference = self.usersFireStoreReference, let id = auth.id else { return }

        self.uploadFile(data: data, auth: auth) { url in
            if let _url = url {
                auth.urlImage = _url.absoluteString
            }
            self.setEmail(email: auth.email) { error in
                if let _error = error {
                    // Email Update Failed
                    failure?(_error)
                    return
                }
                _usersFireStoreReference.document(id).setData(auth.getDictionary()) { error in
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
            let auth = AuthModel.init(id: _id, password: password, dictionary: snapshot?.data())
            result?(auth, "")
        }
    }
    
}

// MARK: - FireStorage
extension AuthManager {
    
    private func uploadFile(data: Data?, auth: AuthModel, handler: @escaping ((_ url: URL?) -> Void)) {
        guard let _data = data, let _id = auth.id, let _name = auth.name else { handler(nil); return }
        let path = "images/\(_id)/\(_name).jpg"
        let riversRef = storage.reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let uploadTask = riversRef.putData(_data, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                SVProgressHUD.dismiss()
                handler(nil)
                return
            }
            riversRef.downloadURL { (url, error) in
                SVProgressHUD.dismiss()
                guard let downloadURL = url else {
                    handler(nil)
                    return
                }
                debugPrint("File is Uplaod")
                handler(downloadURL)
            }
        }
        let _ = uploadTask.observe(.progress, handler: { snapshot in
            let progress = Float(Float(snapshot.progress?.completedUnitCount ?? 0) / Float(snapshot.progress?.totalUnitCount ?? 1))
            debugPrint(progress)
            SVProgressHUD.showProgress(progress)
        })
    }
    
    func setImage(authImage: UIImageView) {
        let urlImage = URL.init(string: AuthManager.shared.getLocalAuth().urlImage ?? "")
        authImage.sd_setImage(with: urlImage, placeholderImage: UIImage.init(named: "ic_placeholderPerson"))
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
        return AuthModel.init(id: id, name: name, email: email, password: password, plateNumber: plateNumber, typeAuth: typeAuth?.getTypeAuth, urlImage: urlImage)
    }
    
}

// MARK: - Sign in by facebook
extension AuthManager {

    func signInByFacebook(vc: UIViewController, result: ResultHandler) {
        loginManager.logIn(permissions: [.publicProfile, .email, .userPhotos], viewController: vc) { loginResult in
            switch loginResult {

            case .success(granted: _, declined: _, token: let token):
                debugPrint("sign in by facebook success")
                self.getImageURL(token: token?.tokenString) { imageURL in
                    self.signInFacebookAccountToFirebase(urlImage: imageURL) { auth, message in
                        result?(auth, message)
                    }
                }
            case .cancelled:
                break
            case .failed(let error):
                result?(nil, error.localizedDescription)
            }
        }
    }

    private func signInFacebookAccountToFirebase(urlImage: String?, result: ResultHandler) {
        guard let token = AccessToken.current?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { auth, error in
            if let _error = error {
                result?(nil, _error.localizedDescription)
                return
            }
            let id = auth?.user.uid
            let authModel = AuthModel.init(id: id, name: auth?.user.displayName, email: auth?.user.email, typeAuth: .User)
            if let _urlImage = urlImage {
                authModel.urlImage = _urlImage
            }
            self.setAuth(auth: authModel, data: nil) { error in
                if let _error = error {
                    result?(nil, _error.localizedDescription)
                    return
                }
                result?(authModel, "")
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
