//  Skaik_mo
//
//  MyParkingsViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 25/03/2022.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import EmptyDataSet_Swift

class MyParkingsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var parkings: [ParkingModel] = []
    private var auth: AuthModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
    }

    @IBAction func addParkingAction(sender: Any) {
        let vc: AddParkingViewController = AddParkingViewController._instantiateVC(storyboard: self._businessStoryboard)
        vc.completionHandler = { parking in
            self.parkings.append(parking)
            self.collectionView.reloadData()
        }
        vc._push()
    }

}

// MARK: - ViewDidLoad
extension MyParkingsViewController {

    private func setUpViewDidLoad() {
        self.title = "My Parkings"

        self.auth = AuthManager.shared.getLocalAuth()

        setUpCollectionView()
    }

    private func setupData() {
        ParkingManager.shared.getParkingsByIdAuth(uid: self.auth?.id) { parkings, message in
            if let _message = message, _message._isValidValue {
                self._showErrorAlert(message: _message)
            }
            self.parkings = parkings
            self.collectionView.reloadData()
            self.collectionView.reloadEmptyDataSet()
        }
    }

}

// MARK: - ViewWillAppear
extension MyParkingsViewController {

    private func setUpViewWillAppear() {
        self._setTitleBackBarButton()
    }

}

extension MyParkingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {

    private func setUpCollectionView() {
        self.setUpEmptyDataView()
        self.collectionView._registerCell = ParkingCollectionViewCell.self
        self.setUpCHTCollectionViewWaterfallLayout()
        self.collectionView.reloadData()
    }

    private func setUpCHTCollectionViewWaterfallLayout() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 11
        layout.minimumInteritemSpacing = 11

        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.parkings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ParkingCollectionViewCell = self.collectionView._dequeueReusableCell(for: indexPath)
        cell.parking = self.parkings[indexPath.item]
        cell.configerCell()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: SpotDetailsViewController = SpotDetailsViewController._instantiateVC(storyboard: self._userStoryboard)
        vc.parking = self.parkings[indexPath.item]
        vc._push()
    }

    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _parkingImageURL = parkings[indexPath.row].parkingImageURL, let url = URL.init(string: _parkingImageURL), let size = self._sizeOfImageAt(url: url) {
            let height = size.height * 1.3
            return CGSize.init(width: size.width, height: height)
        }
        if let size = "placeholderParking"._toImage?.size {
            return CGSize.init(width: size.width, height: (size.height * 2))
        }
        return CGSize.init(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

}

extension MyParkingsViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    private func setUpEmptyDataView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return self.parkings.isEmpty
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
