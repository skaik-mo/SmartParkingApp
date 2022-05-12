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

    var auth: AuthModel?
    var bookings: [BookingModel] = []
    var parkings: [ParkingModel] = []
    var users: [AuthModel] = []

    var isShowEmptyData: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared?.rootNavigationController?.setWhiteNavigation()
        setImage()
        setupData()
    }

    @IBAction func profileAction(_ sender: Any) {
        let vc: ProfileViewController = ProfileViewController._instantiateVC(storyboard: self._authStoryboard)
        vc.auth = auth
        vc.backAuth = { auth in
            self.auth = auth
            self.setImage()
        }
        vc._push()
    }
}

extension HomeBusinessViewController {

    func setupView() {
        self.title = "Home"

        setUpTable()
    }

    func localized() {

    }

    func setupData() {
        BookingManager.shared.getBookingByBusinessID(businessID: self.auth?.id) { bookings, parkings, users, _ in
            self.isShowEmptyData = parkings.isEmpty
            self.homeTableView.reloadEmptyDataSet()
            
            self.parkings = parkings
            self.bookings = bookings
            self.users = users
            self.homeTableView.reloadData()
        }
    }

    func setImage() {
        AuthManager.shared.setImage(authImage: self.authImage, urlImage: auth?.urlImage)
    }

}

extension HomeBusinessViewController: UITableViewDelegate, UITableViewDataSource {
    private func setUpTable() {
        self.homeTableView._registerCell = HomeTableViewCell.self
        self.setUpEmptyDataView()
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
        vc.typeAuth = .Business
        vc.booking = bookings[indexPath.row]
        vc.auth = BookingManager.shared.getUser(booking: self.bookings[indexPath.row], users: self.users)
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

