//
//  BookingManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 04/05/2022.
//

import Foundation
import FirebaseFirestore


class BookingManager {
    static let shared = BookingManager()

    private let db = Firestore.firestore()
    private var bookingsFireStoreReference: CollectionReference?

    typealias ResultBookingHandler = ((_ bookings: [BookingModel], _ message: String?) -> Void)?
    typealias CheckHandler = ((_ status: Bool, _ message: String?) -> Void)?
    typealias ResultMyBookingHandler = ((_ bookings: [BookingModel], _ parkings: [ParkingModel], _ users: [AuthModel], _ message: String?) -> Void)?

    private init() {
        self.bookingsFireStoreReference = db.collection("bookings")
    }

    func deleteBooking(booking: BookingModel?, failure: FailureHandler) {
        guard let _bookingsFireStoreReference = self.bookingsFireStoreReference, let _id = booking?.id else { return }
        _bookingsFireStoreReference.document(_id).delete { error in
            if let _error = error {
                failure?(_error.localizedDescription)
                return
            }
            failure?(nil)
        }


    }

    func getUser(booking: BookingModel?, users: [AuthModel]) -> AuthModel? {
        guard let _booking = booking, let userID = _booking.userID else { return nil }
        return users.first(where: { $0.id == userID })
    }

    func getParking(booking: BookingModel?, parkings: [ParkingModel]) -> ParkingModel? {
        guard let _booking = booking, let parkingID = _booking.parkingID else { return nil }
        return parkings.first(where: { $0.id == parkingID })
    }

    func isBookingTimeExpired(userID: String?, result: ((_ getExpiryTime: Int?) -> Void)?) {
        self.getBookingByUserID(userID: userID, isShowProgress: false) { bookings, parkings, users, message in
            let bookingsAccepted = bookings.filter({ ($0.status == .Accepted) && $0.toDate == Date()._stringData })
            var expiryTime: Int?
            bookingsAccepted.forEach { booking in
                if let from = booking.toTime?._toTime, let to = Date()._stringTime._toTime {
                    let diffInMins = Calendar.current.dateComponents([.minute], from: from, to: to).minute
                    expiryTime = diffInMins
//                    return // Why don't work
                }
            }
            result?(expiryTime)
        }
    }

    private func makeBookingCompleted(bookings: [BookingModel]) {
//        let bookingsAccepted = bookings.filter({ ($0.status == .Accepted) })
        bookings.forEach { booking in
            if let from = booking.toTime?._toTime, let to = Date()._stringTime._toTime, let _toDate = booking.toDate?._toDate, let dateNow = Date()._stringData._toDate, booking.status == .Accepted {
                if _toDate._isSame(date: dateNow) {
                    let diffInMins = Calendar.current.dateComponents([.minute], from: from, to: to).minute
                    if let _diffInMins = diffInMins, _diffInMins >= 0 {
                        // change status to completed
                        booking.status = .Completed
                        BookingManager.shared.setBooking(newBooking: booking, failure: nil)
                        /*
                         "MNrKBAhg7OkadXOogsBx"
                         */
                    }
                } else if _toDate._isBefore(date: dateNow) {
                    booking.status = .Completed
                    BookingManager.shared.setBooking(newBooking: booking, failure: nil)
                    /*
                     "9uv9fdlDDPnCJuwJ0Vk7"
                     "RL3zuDhpezcv0LoFnr3H"
                     */
                }
            }
        }
    }

    func getBookingByUserID(userID: String?, isShowProgress: Bool = true, result: ResultMyBookingHandler) {
        self.getBookings(isShowIndicator: false) { bookings, message in
            self.makeBookingCompleted(bookings: bookings)
            let _bookings = bookings.filter({ $0.userID == userID })
            var _parkings: [ParkingModel] = []
            if _bookings.isEmpty {
                result?([], [], [], message)
                return
            }
            ParkingManager.shared.getParkings(isShowIndicator: isShowProgress) { parkings, message in
                if let _message = message {
                    result?([], [], [], _message)
                    return
                }
                _bookings.forEach { booking in
                    parkings.forEach { parking in
                        if parking.id == booking.parkingID, !_parkings.contains(where: { $0.id == parking.id }) {
                            _parkings.append(parking)
                        }
                    }
                }
                result?(_bookings, _parkings, [], message)
            }
        }
    }

    func getBookingByBusinessID(businessID: String?, result: ResultMyBookingHandler) {
        self.getBookings { bookings, message in
            self.makeBookingCompleted(bookings: bookings)
            var users: [AuthModel] = []
            let _bookings = bookings.filter({ $0.businessID == businessID })
            var _parkings: [ParkingModel] = []
            if _bookings.isEmpty {
                result?([], [], [], message)
                return
            }
            ParkingManager.shared.getParkings(isShowIndicator: false) { parkings, message in
                _bookings.forEach { booking in
                    parkings.forEach { parking in
                        if parking.id == booking.parkingID, !_parkings.contains(where: { $0.id == parking.id }) {
                            _parkings.append(parking)
                        }
                    }
                }
                AuthManager.shared.getAllAuth { getUsers, message in
                    _bookings.forEach { booking in
                        getUsers.forEach { auth in
                            if auth.id == booking.userID, !users.contains(where: { $0.id == booking.userID }) {
                                users.append(auth)
                            }
                        }
                    }
                    result?(_bookings, _parkings, users, message)
                    return
                }
                if _parkings.isEmpty {
                    result?([], [], [], message)
                }
            }
        }
    }

    func addBooking(parking: ParkingModel?, newBooking: BookingModel, failure: FailureHandler) {
        self.checkBooking(parking: parking, newBooking: newBooking) { status, message in
            if status {
                self.setBooking(newBooking: newBooking) { errorMessage in
                    failure?(errorMessage)
                }
            }
            // error
            failure?(message)
        }
    }

    func setBooking(newBooking: BookingModel, failure: FailureHandler) {
        guard let _bookingsFireStoreReference = self.bookingsFireStoreReference, let _id = newBooking.id else { return }
        _bookingsFireStoreReference.document(_id).setData(newBooking.getDictionary()) { error in
            if let _error = error {
                failure?(_error.localizedDescription)
                return
            }
            // Added Booking
            failure?(nil)
            return
        }
    }

    private func getBookings(isShowIndicator: Bool = true, result: ResultBookingHandler) {
        guard let _bookingsFireStoreReference = self.bookingsFireStoreReference else { result?([], "Server Error"); return }
        Helper.showIndicator(isShowIndicator)
        _bookingsFireStoreReference.getDocuments { snapshot, error in
            Helper.dismissIndicator(isShowIndicator)
            if let _error = error {
                result?([], _error.localizedDescription)
                return
            }
            var bookings: [BookingModel] = []

            for booking in snapshot?.documents ?? [] {
                if let _booking = BookingModel.init(id: booking.documentID, dictionary: booking.data()) {
                    bookings.append(_booking)
                }
            }
            result?(bookings, nil)
        }
    }

    private func checkBooking(parking: ParkingModel?, newBooking: BookingModel, result: CheckHandler) {
        guard let _parking = parking else { result?(false, "Error trying to choose another parking"); return }
        let isAvailableDateAndTime = _parking.isAvailableDateAndTime(booking: newBooking)
        if isAvailableDateAndTime.status {
            self.getBookings { bookings, message in
                let parkingBookings = bookings.filter({ $0.parkingID == newBooking.parkingID })
                if parkingBookings.isEmpty {
                    // Add Booking
                    result?(true, nil)
                } else {
                    // Parking bookings on available date
                    let parkingBookingsAvailableDate = parkingBookings.filter({ _parking.isAvailableDateAndTime(booking: $0).status })
                    if parkingBookingsAvailableDate.isEmpty {
                        // Add Booking
                        result?(true, nil)
                    } else {
                        // Filter bookings for a parking spot
                        let spotBookings = parkingBookingsAvailableDate.filter({ $0.spot == newBooking.spot })
                        if spotBookings.isEmpty {
                            // Add Booking
                            result?(true, nil)
                        } else {
                            if _parking.isPerDay ?? false {
                                self.checkBookingWhenPerDay(spotBookings: spotBookings, newBooking: newBooking) { status, message in
                                    result?(status, message)
                                }
                            } else {
                                // is per hour
                                self.checkBookingWhenPerHour(spotBookings: spotBookings, newBooking: newBooking) { status, message in
                                    result?(status, message)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            result?(isAvailableDateAndTime.status, isAvailableDateAndTime.message)
        }
    }

    private func checkDate(booking: BookingModel, newBooking: BookingModel) -> Bool {
        guard let _fromDate = booking.fromDate?._toDate, let _toDate = booking.toDate?._toDate, let _newFromDate = newBooking.fromDate?._toDate, let _newToDate = newBooking.toDate?._toDate else { return false }

        // if Reserved fromDate is after to selected fromDate and Reserved fromDate is after to selected toDate ==> true else false
        if _fromDate._isAfter(date: _newFromDate) && _fromDate._isAfter(date: _newToDate) {
            // Date available
            return true
        }
        // if Reserved toDate is before to selected fromDate and Reserved toDate is before to selected toDate ==> true else false
            else if _toDate._isBefore(date: _newFromDate) && _toDate._isBefore(date: _newToDate) {
            // Date available
            return true
        } else {
            return false
        }
    }

    private func checkBookingWhenPerDay(spotBookings: [BookingModel], newBooking: BookingModel, result: CheckHandler) {
        var isAvailableDate = true
        spotBookings.forEach { booking in
            if !self.checkDate(booking: booking, newBooking: newBooking) {
                // Date not available
                isAvailableDate = false
            }
        }
        if isAvailableDate {
            // add booking if parking per day
            result?(true, nil)
        } else {
            // Date not available
            result?(false, "Date not available")
        }
    }

    private func checkBookingWhenPerHour(spotBookings: [BookingModel], newBooking: BookingModel, result: CheckHandler) {
        let dateBookins = spotBookings.filter({ !(self.checkDate(booking: $0, newBooking: newBooking)) })
        var isAvailableTime = true
        dateBookins.forEach { booking in
            if !self.checkTime(booking: booking, newBooking: newBooking) {
                // Time not available
                isAvailableTime = false
            }
        }
        if isAvailableTime {
            // add booking if parking per Hour
            result?(true, nil)
        } else {
            // Time not available
            result?(false, "Time not available")
        }
    }

    private func checkTime(booking: BookingModel, newBooking: BookingModel) -> Bool {
        guard let _fromTime = booking.fromTime?._toTime, let _toTime = booking.toTime?._toTime, let _newFromTime = newBooking.fromTime?._toTime, let _newToTime = newBooking.toTime?._toTime else { return false }

        // if Reserved fromTime is After to selected fromTime and Reserved fromTime is After or same to selected toTime ==> true else false
        if (_fromTime._isAfter(date: _newFromTime)) && (_fromTime._isSame(date: _newToTime) || _fromTime._isAfter(date: _newToTime)) {
            // Time available
            return true
        }
        // if Reserved toTime is before or same to selected fromTime and Reserved fromTime is before to selected toTime ==> true else false
            else if (_toTime._isSame(date: _newFromTime) || _toTime._isBefore(date: _newFromTime)) && (_toTime._isBefore(date: _newToTime)) {
            // Time available
            return true
        } else {
            // Time not available
            return false
        }
    }

}
