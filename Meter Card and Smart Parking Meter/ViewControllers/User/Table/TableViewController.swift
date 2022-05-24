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

    private let refreshControl = UIRefreshControl.init()

    private var object: [Any] = []
    private var parkings: [ParkingModel] = []
    private var isEmptyData = false

    private var auth: AuthModel?

    private var emptyTitle: String = "No Data Was Received"
    private var emptyDescription: String = ""

    enum TypeView {
        case Messages
        case Favorites
        case Bookings
        case Notifications
    }

    var typeView: TypeView = .Bookings

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
        fetchData(isShowIndicator: true)
    }

}

// MARK: - ViewDidLoad
extension TableViewController {

    private func setUpViewDidLoad() {
        self.auth = AuthManager.shared.getLocalAuth()
        setUpTable()
    }

}
// MARK: - ViewWillAppear
extension TableViewController {

    private func setUpViewWillAppear() {
        AppDelegate.shared?.rootNavigationController?.setWhiteNavigation()
        self._setTitleBackBarButton()
    }

    private func fetchData(isShowIndicator: Bool, handlerDidFinishRequest: (() -> Void)? = nil) {
        switch self.typeView {
        case .Messages:
            self.setUpMessages()
            self.fetchDataMessages(isShowIndicator: isShowIndicator, handlerDidFinishRequest: handlerDidFinishRequest)
            break
        case .Favorites:
            self.setUpFavorites()
            self.fetchDataFavorites(isShowIndicator: isShowIndicator, handlerDidFinishRequest: handlerDidFinishRequest)
            break
        case .Bookings:
            self.setUpMyBookings()
            self.fetchDataMyBookings(isShowIndicator: isShowIndicator, handlerDidFinishRequest: handlerDidFinishRequest)
            break
        case .Notifications:
            self.setUpNotifications()
            self.setupDataNotifications()
            break
        }
    }
}

extension TableViewController {
    private func setUpRefreshControl() {
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }

    @objc private func pullToRefresh() {
        self.parkings.removeAll()
        self.object.removeAll()
        self.tableView.reloadData()
        self.fetchData(isShowIndicator: false) {
            self.refreshControl.endRefreshing()
        }
    }
}

extension TableViewController {

    private func setUpMessages() {
        self.title = "Messages"
        self.view.backgroundColor = .white
    }

    private func fetchDataMessages(isShowIndicator: Bool, handlerDidFinishRequest: (() -> Void)? = nil) {
        MessageManager.shared.getAllMessagesToAuth(isShowIndicator: isShowIndicator,senderID: self.auth?.id) { message, errorMessage in
            handlerDidFinishRequest?()
            debugPrint("message: \(message.count)")
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
            }
            self.object = message
            self.tableView.reloadData()
            self.isEmptyData = self.object.isEmpty
            self.emptyTitle = "No Messages Yet!"
            self.emptyDescription = "Please contact with your friends to see messages"
            self.tableView.reloadEmptyDataSet()
        }
    }

    private func setUpFavorites() {
        self.title = "Favorites"
        self.view.backgroundColor = .white
    }

    private func fetchDataFavorites(isShowIndicator: Bool, handlerDidFinishRequest: (() -> Void)? = nil) {
        ParkingManager.shared.getFavouritedParkings(isShowIndicator: isShowIndicator) { parkings, message in
            handlerDidFinishRequest?()
            if let _message = message {
                self._showErrorAlert(message: _message)
            }
            self.parkings = parkings
            self.tableView.reloadData()
            self.isEmptyData = self.parkings.isEmpty
            self.tableView.reloadEmptyDataSet()
        }
    }

    private func setUpMyBookings() {
        self.title = "My Bookings"
        self.view.backgroundColor = "F9F9FC"._hexColor
    }

    private func fetchDataMyBookings(isShowIndicator: Bool, handlerDidFinishRequest: (() -> Void)? = nil) {
        BookingManager.shared.getBookingByUserID(userID: self.auth?.id, isShowIndicator: isShowIndicator) { bookings, parkings, _, message in
            handlerDidFinishRequest?()
            if let _message = message {
                self._showErrorAlert(message: _message)
            }
            self.parkings = parkings
            self.object = bookings
            self.tableView.reloadData()
            self.isEmptyData = self.object.isEmpty
            self.tableView.reloadEmptyDataSet()
        }
    }

    private func setUpNotifications() {
        self.title = "Notifications"
        self.view.backgroundColor = .white
    }

    private func setupDataNotifications() {
        self.emptyTitle = "No Notifications!"
        self.emptyDescription = "Please do more activates to \nsee notifications"
        self.tableView.reloadEmptyDataSet()
    }

}

extension TableViewController {
    private func getSenderID(message: MessageModel?) -> String? {
        let senderID = message?.senderID
        if senderID == self.auth?.id {
            return message?.receiverID
        }
        return senderID
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    private func setUpTable() {
        self.tableView._registerCell = MessageTableViewCell.self
        self.tableView._registerCell = FavoriteTableViewCell.self
        self.tableView._registerCell = BookingTableViewCell.self
        self.tableView._registerCell = NotificationTableViewCell.self

        self.setUpRefreshControl()
        self.setUpEmptyDataView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.typeView == .Favorites ? parkings.count : object.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.typeView {
        case .Messages:
            let cell: MessageTableViewCell = self.tableView._dequeueReusableCell(for: indexPath)
            cell.selectionStyle = .none
            cell.message = self.object[indexPath.row] as? MessageModel
            cell.configerCell()
            return cell
        case .Favorites:
            let cell: FavoriteTableViewCell = self.tableView._dequeueReusableCell(for: indexPath)
            cell.selectionStyle = .none
            cell.parking = self.parkings[indexPath.row]
            cell.configerCell()
            return cell
        case .Bookings:
            let cell: BookingTableViewCell = self.tableView._dequeueReusableCell(for: indexPath)
            cell.selectionStyle = .none
            cell.booking = self.object[indexPath.row] as? BookingModel
            cell.parking = BookingManager.shared.getParking(booking: self.object[indexPath.row] as? BookingModel, parkings: self.parkings)
            cell.configerCell()
            return cell
        case .Notifications:
            let cell: NotificationTableViewCell = self.tableView._dequeueReusableCell(for: indexPath)
            cell.selectionStyle = .none
            cell.configerCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.typeView {
        case .Messages:
            let vc: MessageViewController = MessageViewController._instantiateVC(storyboard: self._accountStoryboard)
            let senderID = getSenderID(message: self.object[indexPath.row] as? MessageModel)
            AuthManager.shared.getAuth(id: senderID) { auth, message in
                vc.sender = auth
                vc._push()
            }

        case .Favorites:
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell
            let vc: BookingDetailsViewController = BookingDetailsViewController._instantiateVC(storyboard: self._userStoryboard)
            vc.parking = cell?.parking
            vc._push()

        case .Bookings:
            let cell = tableView.cellForRow(at: indexPath) as? BookingTableViewCell
            let vc: BookingDetailsViewController = BookingDetailsViewController._instantiateVC(storyboard: self._userStoryboard)
            vc.parking = cell?.parking
            vc.booking = self.object[indexPath.row] as? BookingModel
            vc._push()

        case .Notifications:
            break
        }
    }
}

extension TableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    private func setUpEmptyDataView() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
//        return self.typeView == .Favorites ? self.parkings.isEmpty : self.object.isEmpty
        return self.isEmptyData
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return "ic_emptyData"._toImage
    }

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString.init(string: self.emptyTitle, attributes: [NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .bold)])
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        NSAttributedString.init(string: self.emptyDescription, attributes: [NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)])
    }

}
