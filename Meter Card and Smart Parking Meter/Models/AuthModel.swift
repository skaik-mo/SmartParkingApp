//
//  AuthModel.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 02/04/2022.
//

import Foundation
import UIKit

enum TypeAuht: Int {
    case User = 0
    case Business = 1
}

class AuthModel {
    var id: String?
    var name: String?
    var email: String?
    var password: String?
    var plateNumber: String?
    var typeAuth: TypeAuht?
    var urlImage: String?
    
    
    init(id: String? = nil, name: String? = nil, email: String?, password: String? = nil, plateNumber: String? = nil, typeAuth: TypeAuht? = .none, urlImage: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.plateNumber = plateNumber
        self.typeAuth = typeAuth
        self.urlImage = urlImage
    }

    init?(id: String?, password: String?, dictionary: [String: Any]?) {
        guard let _dictionary = dictionary, let _id = id, let _password = password else { return nil }
        self.id = _id
        self.name = _dictionary["name"] as? String
        self.email = _dictionary["email"] as? String
        self.password = _password
        self.plateNumber = _dictionary["plateNumber"] as? String
        self.typeAuth = _dictionary["typeAuth"] as? Int == 0 ? .User : .Business
        self.urlImage = _dictionary["urlImage"] as? String
    }

    func getDictionary() -> [String: Any] {
        let dictionary: [String: Any?] = [
//            "id": self.id,
            "name": self.name,
            "email": self.email,
            "password": self.password,
            "plateNumber": self.plateNumber,
            "typeAuth": self.typeAuth?.rawValue,
            "urlImage": self.urlImage
        ]
        return dictionary as [String: Any]
    }

}
