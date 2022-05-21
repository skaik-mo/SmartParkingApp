//
//  AuthModel.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 02/04/2022.
//

import Foundation
import UIKit

enum TypeAuth: Int {
    case User = 0
    case Business = 1
}

class AuthModel {
    var id: String?
    var name: String?
    var email: String?
    var password: String?
    var plateNumber: String?
    var typeAuth: TypeAuth?
    var urlImage: String?
    var urlLicense: String?
    var isLoginBySocial: Bool = false
    var favouritedParkingsIDs: [String]

    init(id: String? = nil, name: String? = nil, email: String?, password: String? = nil, plateNumber: String? = nil, typeAuth: TypeAuth? = .none, urlImage: String? = nil, urlLicense: String? = nil, isLoginBySocial: Bool? = false, favouritedParkingsIDs: [String] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.plateNumber = plateNumber
        self.typeAuth = typeAuth
        self.urlImage = urlImage
        self.urlLicense = urlLicense
        self.isLoginBySocial = isLoginBySocial ?? false
        self.favouritedParkingsIDs = favouritedParkingsIDs
    }

    convenience init(name: String?, email: String?, password: String?, plateNumber: String?, typeAuth: TypeAuth?) {
        self.init(id: nil, name: name, email: email, password: password, plateNumber: plateNumber, typeAuth: typeAuth, urlImage: nil, urlLicense: nil, isLoginBySocial: false, favouritedParkingsIDs: [])
    }

    convenience init(id: String?, name: String?, email: String?, isLoginBySocial: Bool, urlImage: String?) {
        self.init(id: id, name: name, email: email, password: nil, plateNumber: nil, typeAuth: .none, urlImage: urlImage, urlLicense: nil, isLoginBySocial: isLoginBySocial, favouritedParkingsIDs: [])
    }

    convenience init(email: String?, password: String?) {
        self.init(id: nil, name: nil, email: email, password: password, plateNumber: nil, typeAuth: .none, urlImage: nil, urlLicense: nil, isLoginBySocial: false, favouritedParkingsIDs: [])
    }

    init?(id: String?, password: String? = nil, dictionary: [String: Any?]?) {
        guard let _dictionary = dictionary, let _id = id else { return nil }
        self.id = _id
        self.name = _dictionary["name"] as? String
        self.email = _dictionary["email"] as? String
        self.password = password
        self.plateNumber = _dictionary["plateNumber"] as? String
        self.typeAuth = _dictionary["typeAuth"] as? Int == 0 ? .User : .Business
        self.urlImage = _dictionary["urlImage"] as? String
        self.urlLicense = _dictionary["urlLicense"] as? String
        self.isLoginBySocial = _dictionary["isLoginBySocial"] as? Bool ?? false
        self.favouritedParkingsIDs = _dictionary["favouritedParkingsIDs"] as? [String] ?? []
    }

    func getDictionary() -> [String: Any] {
        let dictionary: [String: Any?] = [
            "name": self.name,
            "email": self.email,
            "password": self.password,
            "plateNumber": self.plateNumber,
            "typeAuth": self.typeAuth?.rawValue,
            "urlImage": self.urlImage,
            "urlLicense": self.urlLicense,
            "favouritedParkingsIDs": self.favouritedParkingsIDs,
            "isLoginBySocial": self.isLoginBySocial,
        ]
        return dictionary as [String: Any]
    }

}
