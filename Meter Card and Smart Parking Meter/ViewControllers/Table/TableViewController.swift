//  Skaik_mo
//
//  TableViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 22/03/2022.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var object = [1, 2, 3]

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
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._setTitleBackBarButton()
    }

}

extension TableViewController {

    func setupView() {
        if self.typeView == .Messages {
            self.title = "Messages"
            self.view.backgroundColor = .white
        }
        if self.typeView == .Favorites {
            self.title = "Favorites"
            self.view.backgroundColor = .white
        }
        if self.typeView == .Bookings {
            self.title = "My Bookings"
            self.view.backgroundColor = "F9F9FC"._hexColor
        }
        setUpTable()
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    private func setUpTable() {
        self.tableView._registerCell = MessageTableViewCell.self
        self.tableView._registerCell = FavoriteTableViewCell.self
        self.tableView._registerCell = BookingTableViewCell.self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return object.count
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
            cell.configerCell()
            return cell
        }
        let cell: BookingTableViewCell = self.tableView._dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        cell.configerCell()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.typeView == .Bookings {
            let cell = tableView.cellForRow(at: indexPath) as? BookingTableViewCell
            let vc: BookingDetailsViewController = BookingDetailsViewController.instantiateVC(storyboard: self._userStoryboard)
            vc.parking = cell?.parking
            vc._push()
        }
    }
}
