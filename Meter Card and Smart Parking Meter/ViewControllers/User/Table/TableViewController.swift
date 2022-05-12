//  Skaik_mo
//
//  TableViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 22/03/2022.
//

import UIKit
import EmptyDataSet_Swift

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var object: [Any] = []// [1, 2, 3]
    var parkings: [ParkingModel] = []

    var auth: AuthModel?
    var isShowEmptyData: Bool = false

    enum TypeView {
        case Messages
        case Favorites
        case Bookings
    }

    var typeView: TypeView = .Bookings

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._setTitleBackBarButton()
        setupData()
    }

}

extension TableViewController {

    func setupView() {
        if self.typeView == .Messages {
            self.title = "Messages"
            self.view.backgroundColor = .white
        }
        if self.typeView == .Favorites {
            self.setUpFavorites()
        }
        if self.typeView == .Bookings {
            self.setUpMyBookings()
        }
        setUpTable()
    }

    func localized() {

    }

    func setupData() {
        if self.typeView == .Messages {
            
        }
        if self.typeView == .Favorites {
            self.setupDataFavorites()
        }
        if self.typeView == .Bookings {
            self.setupDataMyBookings()
        }
    }

    func fetchData() {

    }

}

extension TableViewController {
    func setUpFavorites() {
        self.title = "Favorites"
        self.view.backgroundColor = .white
    }
    
    func setupDataFavorites() {
        ParkingManager.shared.getFavouritedParkings(id: self.auth?.id) { parkings, message in
            self.isShowEmptyData = parkings.isEmpty
            self.tableView.reloadEmptyDataSet()
            if !parkings.isEmpty {
                self.parkings = parkings
                self.tableView.reloadData()
            }
            if let _message = message {
                self._showErrorAlert(message: _message)
            }
        }
    }

    func setUpMyBookings() {
        self.title = "My Bookings"
        self.view.backgroundColor = "F9F9FC"._hexColor
    }
    
    func setupDataMyBookings() {
        BookingManager.shared.getBookingByUserID(userID: self.auth?.id) { bookings, parkings, _, message in
            self.parkings = parkings
            self.object = bookings
            self.tableView.reloadData()
            
            self.isShowEmptyData = bookings.isEmpty
            self.tableView.reloadEmptyDataSet()
            
            if let _message = message {
                self._showErrorAlert(message: _message)
            }
        }
    }


}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    private func setUpTable() {
        self.tableView._registerCell = MessageTableViewCell.self
        self.tableView._registerCell = FavoriteTableViewCell.self
        self.tableView._registerCell = BookingTableViewCell.self
        
        setUpEmptyDataView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.typeView == .Favorites {
            return parkings.count
        } else {
            return object.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.typeView == .Messages {
            let cell: MessageTableViewCell = self.tableView._dequeueReusableCell(for: indexPath)
            cell.selectionStyle = .none
            cell.configerCell()
            return cell
        }
        if self.typeView == .Favorites {
            let cell: FavoriteTableViewCell = self.tableView._dequeueReusableCell(for: indexPath)
            cell.selectionStyle = .none
            cell.parking = self.parkings[indexPath.row]
            cell.configerCell()
            return cell
        }
        let cell: BookingTableViewCell = self.tableView._dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        cell.booking = self.object[indexPath.row] as? BookingModel
        cell.parking = BookingManager.shared.getParking(booking: self.object[indexPath.row] as? BookingModel, parkings: self.parkings)
        cell.configerCell()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.typeView {
        case .Messages:
//            let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell
            let vc: MessageViewController = MessageViewController._instantiateVC(storyboard: self._authStoryboard)
            vc._push()

        case .Favorites:
            let cell = tableView.cellForRow(at: indexPath) as? BookingTableViewCell
            let vc: BookingDetailsViewController = BookingDetailsViewController._instantiateVC(storyboard: self._userStoryboard)
            vc.typeAuth = .User
            vc.parking = cell?.parking
            vc._push()

        case .Bookings:
            let cell = tableView.cellForRow(at: indexPath) as? BookingTableViewCell
            let vc: BookingDetailsViewController = BookingDetailsViewController._instantiateVC(storyboard: self._userStoryboard)
            vc.typeAuth = .User
            vc.parking = cell?.parking
            vc.booking = self.object[indexPath.row] as? BookingModel
            vc._push()
        }
    }
}

extension TableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    private func setUpEmptyDataView() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return self.isShowEmptyData
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return "ic_emptyData"._toImage
    }

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString.init(string: "No Data Was Received", attributes: [NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .bold)])
    }
    
}
