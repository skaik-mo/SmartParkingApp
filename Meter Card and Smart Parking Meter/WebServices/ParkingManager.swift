//
//  ParkingManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 13/04/2022.
//

import Foundation
import FirebaseFirestore

class ParkingManager {
    static let shared = ParkingManager()

    private let db = Firestore.firestore()
    private var parkingsFireStoreReference: CollectionReference?

    private init() {
        self.parkingsFireStoreReference = db.collection("parkings")
    }

    func setParking(parking: ParkingModel, data: Data?, failure: FailureHandler) {
        guard let _parkingsFireStoreReference = self.parkingsFireStoreReference, let _id = parking.id, let _name = parking.name else { return }

        let data: [String: Data?] = [
            "Parking/ParkingImage/\(_id)/\(_name).jpg": data,
        ]
        FirebaseStorageManager.shared.uploadFile(data: data) { urls in
            if let _url = urls.first {
                parking.imageURL = _url.value.absoluteString
            }
            _parkingsFireStoreReference.document(_id).setData(parking.getDictionary()) { error in
                if let _error = error {
                    failure?(_error)
                    return
                }
                // Added Parking
                failure?(nil)
            }
        }
    }

}
