//  Skaik_mo
//
//  SpotDetailsViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import UIKit
import JTAppleCalendar
import GoogleMaps

class SpotDetailsViewController: UIViewController {

    @IBOutlet weak var parkingImage: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var favouriteButton: UIButton!

    @IBOutlet weak var parkingOwnerView: ParkingOwner!

    @IBOutlet weak var calenderCollectionView: JTAppleCalendarView!

    @IBOutlet weak var numberOfParking: NumberOfParking!

    @IBOutlet var monthTitle: UILabel!
    @IBOutlet weak var pricePerHourLabel: UILabel!

    @IBOutlet weak var ratingView: Rating!

    @IBOutlet weak var bookNowButton: GreenButton!

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    var parking: ParkingModel?

    private var auth: AuthModel?
    private var selectedDates: [String] = []

    private var typeAuth: TypeAuth = .User {
        didSet {
            switchAuth()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
        setImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
    }

    @IBAction func previousMonthAction(_ sender: Any) {
        guard let _currentSection = self.calenderCollectionView.currentSection(), 0 < _currentSection else { return }
        moveSection(index: -1)
    }

    @IBAction func nextMonthAction(_ sender: Any) {
        guard let _currentSection = self.calenderCollectionView.currentSection(), _currentSection < self.calenderCollectionView.numberOfSections - 1 else { return }
        moveSection(index: 1)
    }

    @IBAction func setFavouriteAction(_ sender: Any) {
        setFavourite()
    }

}

// MARK: - ViewDidLoad
extension SpotDetailsViewController {

    private func setUpViewDidLoad() {
        GoogleMapManager.shared.setParkingLoction(mapView: mapView, parking: parking)

        self.auth = AuthManager.shared.getLocalAuth()

        if let _typeAuth = self.auth?.typeAuth {
            self.typeAuth = _typeAuth
        }

        self.favouriteButton.isSelected = AuthManager.shared.getFavourite(parkingID: parking?.id)

        if let fromTime = self.parking?.fromTime, let toTime = self.parking?.toTime {
            self.timeLabel.text = "Time: \(fromTime) - \(toTime)"
            if let _oldDate = fromTime._toTime, let _newDate = toTime._toTime {
                let diffInMins = Calendar.current.dateComponents([.hour], from: _oldDate, to: _newDate).hour
                self.durationLabel.text = "Duration: \(diffInMins ?? 0) hours per day"
            }
        }

        self.parkingOwnerView.setUpView(parking: self.parking, senderID: self.parking?.uid)

        self.setInfoParking()

        self.numberOfParking.setUpNumberOfParking(typeSpotButton: .border, title: "Available Spot", spots: self.parking?.spots)

        self.ratingView.setUpRating(parking: parking, space: 12)

        self.setCalenderCollectionView()

        self.bookNowButton.setUp(typeButton: .grayButton, corner: 8)
        self.bookNowButton.handleButton = {
            let vc: SubmitBookingViewController = SubmitBookingViewController._instantiateVC(storyboard: self._userStoryboard)
            vc.parking = self.parking
            vc.modalPresentationStyle = .custom
            vc.modalTransitionStyle = .crossDissolve
            vc._presentVC()
        }

        self.checkRating()
    }

    private func setImage() {
        self.parkingImage.fetchImage(parking?.parkingImageURL, "placeholderParking")
    }

}

// MARK: - ViewWillAppear
extension SpotDetailsViewController {

    private func setUpViewWillAppear() {
        self._isHideNavigation = false
        self._setTitleBackBarButton()
    }

}

extension SpotDetailsViewController {
    private func setInfoParking() {
        self.parkingImage.fetchImage(parking?.parkingImageURL, "placeholderParking")
        setInfo(parking: parking)
    }

    private func setInfo(parking: ParkingModel?) {
        var price = ""
        if let _price = parking?.price {
            price = "\(_price)$ Per \(self.parking?.isPerDay ?? false ? "Day" : "Hour")"
        }
        self.pricePerHourLabel.text = price
    }

    private func setFavourite() {
        self.favouriteButton.isSelected.toggle()
        AuthManager.shared.setFavourite(parkingID: parking?.id, isFavourite: self.favouriteButton.isSelected) { errorMessage in
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
            }
        }
    }

    // Check if the user has rated
    private func checkRating() {
        RatingManager.shared.checkRating(userID: self.auth?.id) { isRating in
            if !isRating {
                BookingManager.shared.getBookingByUserID(userID: self.auth?.id, isShowIndicator: false) { bookings, parkings, users, message in
                    if bookings.contains(where: { ($0.parkingID == self.parking?.id && $0.status == .Completed) }) {
                        let vc: RatingViewController = RatingViewController._instantiateVC(storyboard: self._userStoryboard)
                        vc.parking = self.parking
                        vc.modalPresentationStyle = .custom
                        vc.modalTransitionStyle = .crossDissolve
                        vc._presentVC()
                    }
                }
            }

        }
    }

}

extension SpotDetailsViewController {
    private func switchAuth() {
        switch self.typeAuth {
        case .User:
            self.title = "Spot Details"
            self.favouriteButton.isHidden = false
            self.bookNowButton.isHidden = false
            self.parkingOwnerView.isHidden = false
        case .Business:
            self.title = "Parking Details"
            self.favouriteButton.isHidden = true
            self.bookNowButton.isHidden = true
            self.parkingOwnerView.isHidden = true
        }
    }
}

extension SpotDetailsViewController {
    private func setCalenderCollectionView() {
        self.calenderCollectionView._registerCell = DateCell.self
        calenderCollectionView.scrollDirection = .horizontal
        calenderCollectionView.scrollingMode = .stopAtEachCalendarFrame
        calenderCollectionView.showsHorizontalScrollIndicator = false

        // Is this method correct to use ??!
        DispatchQueue.main.async {
            self.moveSection(index: self.calenderCollectionView.numberOfSections - 1)
        }
    }

    private func setTitleCalender(date: Date?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let _date = date, let _stringData = formatter.date(from: _date._stringData) else { return }

        let currentCalendar = Calendar.current
        let monthFormatter = DateFormatter()
        let year = currentCalendar.component(.year, from: _stringData)
        let month = currentCalendar.component(.month, from: _date)
        let monthName = monthFormatter.monthSymbols[month - 1]
        self.monthTitle.text = "\(monthName) \(year)"
    }

    private func moveSection(index: Int) {
        let visibleItems: NSArray = self.calenderCollectionView.indexPathsForVisibleItems as NSArray
        let currentItem = visibleItems.object(at: 0) as? IndexPath
        if let _currentSection = currentItem?.section {
            let nextSection: IndexPath = IndexPath(item: 0, section: _currentSection + index)
            self.calenderCollectionView.scrollToItem(at: nextSection, at: .right, animated: true)
        }
    }

}

extension SpotDetailsViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {

        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCell._id, for: indexPath) as! DateCell
        cell.index = indexPath.row
        cell.cellState = cellState
        cell.selectedDates = selectedDates
        cell.configerCell()
        self.calendarDidScroll(calenderCollectionView)

        return cell
    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        if let start = self.parking?.fromDate, let end = self.parking?.toDate, let startDate = start._toDate, let endDate = end._toDate {
            self.selectedDates = self.dates(from: start, to: end)
            return ConfigurationParameters(startDate: startDate, endDate: endDate)
        }

        var startDate = Date()
        if let _startDate = formatter.date(from: "2022 01 01") {
            startDate = _startDate
        }
        return ConfigurationParameters(startDate: startDate, endDate: Date())
    }

    func calendarDidScroll(_ calendar: JTAppleCalendarView) {
        setTitleCalender(date: calendar.visibleDates().monthDates.last?.date)
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }

}
