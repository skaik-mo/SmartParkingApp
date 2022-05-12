//
//  ParkingManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 13/04/2022.
//

import Foundation
import FirebaseFirestore
import SVProgressHUD
import GoogleMaps
import SDWebImage

typealias ResultParkingsHandler = ((_ parkings: [ParkingModel], _ message: String?) -> Void)?

class ParkingManager {
    static let shared = ParkingManager()

    private let db = Firestore.firestore()
    private var parkingsFireStoreReference: CollectionReference?

    private init() {
        self.parkingsFireStoreReference = db.collection("parkings")
    }

    func setParking(isShowProgress: Bool = true, parking: ParkingModel, dataParking: Data?, dataParkLicense: Data?, failure: FailureHandler) {
        guard let _parkingsFireStoreReference = self.parkingsFireStoreReference, let _id = parking.id, let _name = parking.name else { return }
        if isShowProgress {
            SVProgressHUD.showSVProgress()
        }
        let pathParkingImage = "Parking/\(_id)/ParkingImage/\(_name).jpg"
        let pathParkLicense = "Parking/\(_id)/ParkLicense/\(_name).jpg"
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
                if isShowProgress {
                    SVProgressHUD.dismiss()
                }
                if let _error = error {
                    failure?(_error.localizedDescription)
                    return
                }
                // Added Parking
                failure?(nil)
            }
        }
    }

    func getParkings(isShowProgress: Bool = true, filter: FilterModel? = nil, result: ResultParkingsHandler) {
        guard let _parkingsFireStoreReference = self.parkingsFireStoreReference else { result?([], "Server Error"); return }
        if isShowProgress {
            SVProgressHUD.showSVProgress()
        }
        _parkingsFireStoreReference.getDocuments { snapshot, error in
            if isShowProgress {
                SVProgressHUD.dismiss()
            }
            if let _error = error {
                result?([], _error.localizedDescription)
                return
            }
            var parkings: [ParkingModel] = []
            var parkingsFilters: [ParkingModel] = []

            for parking in snapshot!.documents {
                if let _parking = ParkingModel.init(id: parking.documentID, dictionary: parking.data()) {
                    if let _filter = filter {
                        if _filter.compareDistance(latitude: _parking.latitude, longitude: _parking.longitude), _filter.compareDate(fromDate: _parking.fromDate, toDate: _parking.toDate), _filter.compareTime(fromTime: _parking.fromTime, toTime: _parking.toTime) {
                            parkingsFilters.append(_parking)
                        }
                    }
                    parkings.append(_parking)
                }
            }

            if !parkingsFilters.isEmpty {
                parkings = parkingsFilters
            }
            result?(parkings, nil)
        }
    }

    func getParkingsByIdAuth(uid: String?, result: ResultParkingsHandler) {
        guard let _uid = uid else { result?([], "Error"); return }
        self.getParkings { parkings, message in
            let _parkings = parkings.filter({ $0.uid == _uid })
            result?(_parkings, message)
        }
    }

    func getFavouritedParkings(id: String?, result: ResultParkingsHandler) {
        guard let _id = id else { result?([], "Error"); return }
        var parkings: [ParkingModel] = []
        AuthManager.shared.getAuth(id: _id) { getAuth, message in
            if let _getAuth = getAuth, !_getAuth.favouritedParkingsIDs.isEmpty {
                self.getParkings { getParkings, message in
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

    func setRating(parking: ParkingModel?, rating: Double, failure: FailureHandler) {
        guard let _parking = parking else { failure?("Error"); return }
        _parking.rating = rating
        self.setParking(isShowProgress: false, parking: _parking, dataParking: nil, dataParkLicense: nil) { errorMessage in
            failure?(errorMessage)
        }
    }
//    func getParkingsByIDs(result: ResultParkingsHandler) {
//        let auth = AuthManager.shared.getLocalAuth()
//        var parkings: [ParkingModel] = []
//        self.getParkings { getParkings, message in
//            if !getParkings.isEmpty, !auth.favouritedParkingsIDs.isEmpty {
//                auth.favouritedParkingsIDs.forEach { id in
//                    getParkings.forEach { parking in
//                        if parking.id == id {
//                            parkings.append(parking)
//                        }
//                    }
//                }
//                result?(parkings, nil)
//                return
//            }
//            result?([], message)
//        }
//    }

    func setImage(parkingImage: UIImageView, urlImage: String? = nil) {
        var image = ""
        if let _urlImage = urlImage {
            image = _urlImage
        }
        let url = URL.init(string: image)
        parkingImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "placeholderParking"), options: .queryMemoryData, completed: nil)

    }

}