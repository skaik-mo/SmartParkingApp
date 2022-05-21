//  Skaik_mo
//
//  NumberOfParking.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import UIKit

enum TypeSpotButton {
    case border
    case selectedFill
    case unselectedfill
    case grayWithBorder
}

class NumberOfParking: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var numberOfParkingText: UITextField!

    @IBOutlet weak var spotsCollectionView: UICollectionView!

    var selectedSpot: Int?
    private var numberOfSpots: Int = 1

    private var typeSpotButton: TypeSpotButton = .border

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureXib()
    }

    private func configureXib() {
        Bundle.main.loadNibNamed(NumberOfParking._id, owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()

        self.setUpCollectionView()

    }

    @IBAction func addSpotParking(_ sender: Any) {
        self.addSpots()
    }

}

extension NumberOfParking: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func setUpNumberOfParking(typeSpotButton: TypeSpotButton, title: String, spots: Int?, selectedSpot: Int? = nil) {
        self.typeSpotButton = typeSpotButton
        self.title.text = title
        if let _spots = spots {
            self.numberOfSpots = _spots
        }
        if self.typeSpotButton == .unselectedfill, let spot = selectedSpot {
            DispatchQueue.main.async {
                self.spotsCollectionView.delegate?.collectionView?(self.spotsCollectionView, didSelectItemAt: IndexPath.init(item: spot, section: 0))
            }

        }
    }

    private func setUpCollectionView() {
        self.spotsCollectionView._registerCell = SpotCollectionViewCell.self
        // Why isn't dataSource working in the storyboard
        spotsCollectionView.dataSource = self
        spotsCollectionView.delegate = self
        self.addSpots()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfSpots
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SpotCollectionViewCell = self.spotsCollectionView._dequeueReusableCell(for: indexPath)
        cell.numberOfSpot = indexPath.row
        cell.typeSpotButton = self.typeSpotButton
        cell.configerCell()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedSpot != indexPath.row {
            if let cell = self.spotsCollectionView.cellForItem(at: indexPath) as? SpotCollectionViewCell, (cell.typeSpotButton == .selectedFill || cell.typeSpotButton == .unselectedfill) {
                cell.selectedAction()
            }
            if let selected = self.selectedSpot, let cell = self.spotsCollectionView.cellForItem(at: IndexPath.init(item: selected, section: 0)) as? SpotCollectionViewCell, cell.typeSpotButton == .selectedFill {
                cell.unSelectedAction()
            }
            self.selectedSpot = indexPath.row
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 40
        let width = height
        return CGSize.init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
}


extension NumberOfParking {

    func checkNumberOfParkig() -> String? {
        if !self.numberOfParkingText.isHidden {
            if self.numberOfParkingText._getText._toInteger ?? 0 <= 0 {
                return "Enter the number of spots"
            }
        }
        return nil
    }

    private func addSpots() {
        if let number = numberOfParkingText.text?._toInteger {
            self.numberOfSpots = number
            self.spotsCollectionView.reloadData()
        }
    }
}
