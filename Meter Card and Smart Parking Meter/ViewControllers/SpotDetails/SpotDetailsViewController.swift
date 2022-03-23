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

    @IBOutlet weak var calenderCollectionView: JTAppleCalendarView!

    @IBOutlet weak var numberOfParking: NumberOfParking!

    @IBOutlet var monthTitle: UILabel!
    @IBOutlet weak var pricePerHourLabel: UILabel!

    @IBOutlet weak var ratingView: Rating!

    var parking: Parking?

    var selectedDates: [String] = [
        "2022-03-01",
        "2022-03-02",
        "2022-03-03",
        "2022-03-04",
        "2022-03-05",
        "2022-03-06"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self._isHideNavigation = false
        self._setTitleBackBarButton()
    }

    @IBAction func setRatingAction(_ sender: Any) {
        RatingViewController._presentVC()
    }
    
    @IBAction func previousMonthAction(_ sender: Any) {
//            calenderCollectionView.moveSection(_currentSection, toSection: _currentSection - 1)
        guard let _currentSection = self.calenderCollectionView.currentSection(), 0 < _currentSection else { return }
        moveSection(index: -1)
    }

    @IBAction func nextMonthAction(_ sender: Any) {
        guard let _currentSection = self.calenderCollectionView.currentSection(), _currentSection < self.calenderCollectionView.numberOfSections - 1 else { return }
        moveSection(index: 1)
    }

    @IBAction func bookNowAction(_ sender: Any) {
        SubmitBookingViewController._presentVC { viewController in
            let vc = viewController as? SubmitBookingViewController
            vc?.parking = self.parking
        }
    }

}

extension SpotDetailsViewController {

    func setupView() {
        self.title = "Spot Details"

        GoogleMapManager.initLoction(parkingLocation: parking, mapView: mapView)
        setInfoParking()
        numberOfParking.typeParkingView = .border
        numberOfParking.title.text = "Available Spot"
        self.ratingView.setUpRating(parking: parking, space: 12)
        setCalenderCollectionView()

    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}


extension SpotDetailsViewController {
    func setInfoParking() {
        self.parking?.setParkingImage(parkingImage: self.parkingImage)
        setInfo(parking: parking)
    }

    private func setInfo(parking: Parking?) {
        var price = ""
        if let _pricePerHour = parking?.pricePerHour {
            price = "\(_pricePerHour._toString)$ Per Hour"
        }
        self.pricePerHourLabel.text = price
    }

}

extension SpotDetailsViewController {
    func setCalenderCollectionView() {
        self.calenderCollectionView._registerCell = DateCell.self
        calenderCollectionView.scrollDirection = .horizontal
        calenderCollectionView.scrollingMode = .stopAtEachCalendarFrame
        calenderCollectionView.showsHorizontalScrollIndicator = false

        // Is this method correct to use ??!
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.moveSection(index: self.calenderCollectionView.numberOfSections - 1)
        }
    }

    func setTitleCalender(date: Date?) {
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

    func moveSection(index: Int) {
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
//        self.calendar(calendar, didScrollToDateSegmentWith: calendar.visibleDates())
//        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        self.calendarDidScroll(calenderCollectionView)

        return cell
    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let endDate = Date()

        if let _startDate = formatter.date(from: "2022 01 01") {
            let startDate = _startDate
            return ConfigurationParameters(startDate: startDate, endDate: endDate)
        }
        return ConfigurationParameters(startDate: endDate, endDate: endDate)
    }

    func calendarDidScroll(_ calendar: JTAppleCalendarView) {
        setTitleCalender(date: calendar.visibleDates().monthDates.last?.date)
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }

}
