//
//  RatingManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 11/05/2022.
//

import Foundation
import FirebaseFirestore


class RatingManager {
    static let shared = RatingManager()

    private let db = Firestore.firestore()
    private var ratingsFireStoreReference: CollectionReference?

    typealias ResultRatingsHandler = ((_ ratings: [RatingModel], _ message: String?) -> Void)?

    private init() {
        self.ratingsFireStoreReference = db.collection("rating")
    }

    func setRating(rating: RatingModel, parking: ParkingModel?, failure: FailureHandler) {
        guard let _ratingsFireStoreReference = self.ratingsFireStoreReference, let userID = rating.userID, let parkingID = rating.parkingID, let parking = parking else { return }
        let id = userID + parkingID
        _ratingsFireStoreReference.document(id).setData(rating.getDictionary()) { error in
            if let _error = error {
                failure?(_error.localizedDescription)
                return
            }
            // Added Rating
            self.getRatings { ratings, message in
                if let _message = message {
                    failure?(_message)
                    return
                }
                let sum = self.sumRating(parkingID: parkingID, ratings: ratings)
                parking.rating = sum
                ParkingManager.shared.setParking(isShowIndicator: false, parking: parking) { errorMessage in
                    if let _errorMessage = errorMessage {
                        failure?(_errorMessage)
                        return
                    }
                    failure?(nil)
                }
            }

        }
    }

    private func sumRating(parkingID: String, ratings: [RatingModel]) -> Double {
        var sum: Double = 0
        var sumRating: Double = 0
        var countUsers: Int = 0

        ratings.forEach { rating in
            if let _rating = rating.rating, rating.parkingID == parkingID {
                sumRating += _rating
                countUsers += 1
            }
        }
        sum = sumRating / countUsers._toDouble
        return sum
    }


    private func getRatings(result: ResultRatingsHandler) {
        guard let _ratingsFireStoreReference = self.ratingsFireStoreReference else { result?([], SERVER_ERROR_MESSAGE); return }

        _ratingsFireStoreReference.getDocuments { snapshot, error in
            if let _error = error {
                result?([], _error.localizedDescription)
                return
            }
            var ratings: [RatingModel] = []

            for rating in snapshot?.documents ?? [] {
                if let _rating = RatingModel.init(dictionary: rating.data()) {
                    ratings.append(_rating)
                }
            }
            result?(ratings, nil)
        }
    }

    func checkRating(userID: String?, result: ((_ isRating: Bool) -> Void)?) {
        self.getRatings { ratings, message in
            let isRating = ratings.contains(where: { $0.userID == userID })
            result?(isRating)
        }
    }

}
