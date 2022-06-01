//  Skaik_mo
//
//  HomeBusinessViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 25/03/2022.
//

import UIKit
import EmptyDataSet_Swift

class HomeBusinessViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!

    @IBOutlet weak var authImage: UIImageView!

    private let refreshControl = UIRefreshControl.init()

    private var auth: AuthModel?
    private var bookings: [BookingModel] = []
    private var parkings: [ParkingModel] = []
    private var users: [AuthModel] = []
    private var isEmptyData = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
        setImage()
        fetchData(isShowIndicator: true)
    }

    @IBAction func profileAction(_ sender: Any) {
        let vc: ProfileViewController = ProfileViewController._instantiateVC(storyboard: self._accountStoryboard)
        vc._push()
    }

    @IBAction func notificationAction(_ sender: Any) {
        let vc: TableViewController = TableViewController._instantiateVC(storyboard: self._userStoryboard)
        vc.typeView = .Notifications
        vc._push()
    }
}

// MARK: - ViewDidLoad
extension HomeBusinessViewController {

    private func setUpViewDidLoad() {
        self.title = "Home"
        setUpTable()
    }

}

// MARK: - ViewWillAppear
extension HomeBusinessViewController {

    private func setUpViewWillAppear() {
        AppDelegate.shared?.rootNavigationController?.setWhiteNavigation()
        auth = AuthManager.shared.getLocalAuth()
    }

    private func fetchData(isShowIndicator: Bool, handlerDidFinishRequest: (() -> Void)? = nil) {
        BookingManager.shared.getBookingByBusinessID(businessID: self.auth?.id) { bookings, parkings, users, _ in
            handlerDidFinishRequest?()
            self.parkings = parkings
            self.bookings = bookings
            self.users = users
            self.homeTableView.reloadData()
            self.isEmptyData = self.bookings.isEmpty
            self.homeTableView.reloadEmptyDataSet()
        }
    }

    private func setImage() {
        self.authImage.fetchImageWithActivityIndicator(auth?.urlImage, ic_placeholderPerson)
    }

}

extension HomeBusinessViewController {
    private func setUpRefreshControl() {
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.homeTableView.refreshControl = refreshControl
    }

    @objc private func pullToRefresh() {
        self.parkings.removeAll()
        self.bookings.removeAll()
        self.users.removeAll()
        self.homeTableView.reloadData()
        self.fetchData(isShowIndicator: false) {
            self.refreshControl.endRefreshing()
        }
    }
}

extension HomeBusinessViewController: UITableViewDelegate, UITableViewDataSource {

    private func setUpTable() {
        self.homeTableView._registerCell = HomeTableViewCell.self
        self.setUpEmptyDataView()
        self.setUpRefreshControl()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = self.homeTableView._dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        cell.booking = self.bookings[indexPath.row]
        cell.parking = BookingManager.shared.getParking(booking: self.bookings[indexPath.row], parkings: self.parkings)
        cell.user = BookingManager.shared.getUser(booking: self.bookings[indexPath.row], users: self.users)
        cell.configerCell()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: BookingDetailsViewController = BookingDetailsViewController._instantiateVC(storyboard: self._userStoryboard)
        vc.booking = bookings[indexPath.row]
        vc.parking = BookingManager.shared.getParking(booking: self.bookings[indexPath.row], parkings: self.parkings)
        vc._push()
    }

}


extension HomeBusinessViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    private func setUpEmptyDataView() {
        homeTableView.emptyDataSetSource = self
        homeTableView.emptyDataSetDelegate = self
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return self.isEmptyData
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return ic_emptyData._toImage
    }

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString.init(string: noData, attributes: [NSAttributedString.Key.font: fontMontserratRegular17 ?? UIFont.systemFont(ofSize: 17, weight: .bold)])
    }

}

