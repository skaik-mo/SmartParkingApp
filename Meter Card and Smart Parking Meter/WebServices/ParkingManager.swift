//
//  ParkingManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 13/04/2022.
//

import Foundation
import FirebaseFirestore
import SDWebImage

class ParkingManager {
    static let shared = ParkingManager()

    private let db = Firestore.firestore()
    private var parkingsFireStoreReference: CollectionReference?

    typealias ResultParkingsHandler = ((_ parkings: [ParkingModel], _ message: String?) -> Void)?

    var parkings: [ParkingModel] = []
    
    private init() {
        self.parkingsFireStoreReference = db.collection("parkings")
    }

    func setParking(isShowIndicator: Bool = true, parking: ParkingModel, dataParking: Data? = nil, dataParkLicense: Data? = nil, failure: FailureHandler) {
        guard let _parkingsFireStoreReference = self.parkingsFireStoreReference, let _id = parking.id else { return }
        Helper.showIndicator(isShowIndicator)
        let pathParkingImage = "Parking/\(_id)/ParkingImage.jpeg"
        let pathParkLicense = "Parking/\(_id)/ParkLicense.jpeg"
        var data: [String: Data] = [:]
        if let _dataParking = dataParking {
            data[pathParkingImage] = _dataParking
        }
        if let _dataParkLicense = dataParkLicense {
            data[pathParkLicense] = _dataParkLicense
        }
        FirebaseStorageManager.shared.uploadFile(data: data) { urls in
            for url in urls {
                if pathParkingImage == url.key {
                    parking.parkingImageURL = url.value.absoluteString
                } else if pathParkLicense == url.key {
                    parking.parkLicenseimageURL = url.value.absoluteString
                }
            }
            _parkingsFireStoreReference.document(_id).setData(parking.getDictionary()) { error in
                Helper.dismissIndicator(isShowIndicator)
                if let _error = error {
                    failure?(_error.localizedDescription)
                    return
                }
                // Added Parking
                failure?(nil)
            }
        }
    }

    func getParkings(isShowIndicator: Bool = true, filter: FilterModel? = nil, result: ResultParkingsHandler) {
        guard let _parkingsFireStoreReference = self.parkingsFireStoreReference else { result?([], "Server Error"); return }
        Helper.showIndicator(isShowIndicator)
        _parkingsFireStoreReference.getDocuments { snapshot, error in
            Helper.dismissIndicator(isShowIndicator)
            if let _error = error {
                result?([], _error.localizedDescription)
                return
            }
            var parkingsFilters: [ParkingModel] = []

            for parking in snapshot?.documents ?? [] {
                if let _parking = ParkingModel.init(id: parking.documentID, dictionary: parking.data()) {
                    if let _filter = filter {
                        if _filter.compareDistance(latitude: _parking.latitude, longitude: _parking.longitude) || _filter.compareDate(fromDate: _parking.fromDate, toDate: _parking.toDate) || _filter.compareTime(fromTime: _parking.fromTime, toTime: _parking.toTime) {
                            parkingsFilters.append(_parking)
                        }
                    }
                    self.parkings.append(_parking)
                }
            }

            if !parkingsFilters.isEmpty {
                self.parkings = parkingsFilters
            }
            result?(self.parkings, nil)
        }
    }

    func getParkingsByIdAuth(isShowIndicator: Bool = true, uid: String?, result: ResultParkingsHandler) {
        guard let _uid = uid else { result?([], "Error"); return }
        self.getParkings(isShowIndicator: isShowIndicator) { parkings, message in
            let _parkings = parkings.filter({ $0.uid == _uid })
            result?(_parkings, message)
        }
    }

    func getFavouritedParkings(isShowIndicator: Bool, result: ResultParkingsHandler) {
        guard let _id = AuthManager.shared.getLocalAuth()?.id else { result?([], "Error"); return }
        var parkings: [ParkingModel] = []
        AuthManager.shared.getAuth(id: _id) { getAuth, message in
            if let _getAuth = getAuth, !_getAuth.favouritedParkingsIDs.isEmpty {
                self.getParkings(isShowIndicator: isShowIndicator) { getParkings, message in
                    if !getParkings.isEmpty {
                        _getAuth.favouritedParkingsIDs.forEach { parkingID in
                            getParkings.forEach { parking in
                                if parking.id == parkingID {
                                    parkings.append(parking)
                                }
                            }
                        }
                        result?(parkings, nil)
                        return
                    }
                    result?([], message)
                }
            } else {
                result?([], message)
            }

        }

    }

}
