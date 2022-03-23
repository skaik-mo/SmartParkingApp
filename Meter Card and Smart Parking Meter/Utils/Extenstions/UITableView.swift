//
//  UITableView.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 22/03/2022.
//

import Foundation
import UIKit

extension UITableView {
    
    var _registerCell: UITableViewCell.Type {
        set{
            self.register(UINib.init(nibName: newValue.self._id, bundle: nil), forCellReuseIdentifier: newValue.self._id)
        }
        get{
            return UITableViewCell.self
        }
    }
    
//    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type = T.self) -> T {
//        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
//            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
//        }
//        return cell
//    }

    func _dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type = T.self, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

}
