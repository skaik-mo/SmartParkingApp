//
//  UICollectionView.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import Foundation
import UIKit

extension UICollectionView {
    var _registerCell: UICollectionViewCell.Type {
            set{
                self.register(UINib.init(nibName: newValue.self._id, bundle: nil), forCellWithReuseIdentifier: newValue.self._id)
            }
            get{
                return UICollectionViewCell.self
            }
        }
    
}
