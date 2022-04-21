//  Skaik_mo
//
//  HomeBusinessViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 25/03/2022.
//

import UIKit

class HomeBusinessViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!

    @IBOutlet weak var authImage: UIImageView!

    var auth: AuthModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared?.rootNavigationController?.setWhiteNavigation()
        setImage()
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

    }

    func setImage() {
        AuthManager.shared.setImage(authImage: self.authImage, urlImage: auth?.urlImage)
    }

}

extension HomeBusinessViewController: UITableViewDelegate, UITableViewDataSource {
    private func setUpTable() {
        self.homeTableView._registerCell = HomeTableViewCell.self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = self.homeTableView._dequeueReusableCell(for: indexPath)
        cell.configerCell()
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: BookingDetailsViewController = BookingDetailsViewController._instantiateVC(storyboard: self._userStoryboard)
        vc.typeAuth = .Business
        vc._push()
    }


}
