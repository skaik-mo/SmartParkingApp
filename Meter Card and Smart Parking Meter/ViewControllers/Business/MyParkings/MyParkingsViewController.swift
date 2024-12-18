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

    private let refreshControl = UIRefreshControl.init()

    private var parkings: [ParkingModel] = []
    private var auth: AuthModel?
    private var isEmptyData = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
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
        self.title = MY_PARKINGS_TITLE
        setUpCollectionView()
    }

    private func fetchData(isShowIndicator: Bool = true, handlerDidFinishRequest: (() -> Void)? = nil) {
        ParkingManager.shared.getParkingsByIdAuth(isShowIndicator: isShowIndicator, uid: self.auth?.id) { parkings, message in
            handlerDidFinishRequest?()
            if let _message = message, _message._isValidValue {
                self._showErrorAlert(message: _message)
            }
            self.parkings = parkings
            self.collectionView.reloadData()
            self.isEmptyData = self.parkings.isEmpty
            self.collectionView.reloadEmptyDataSet()
        }
    }

}

// MARK: - ViewWillAppear
extension MyParkingsViewController {

    private func setUpViewWillAppear() {
        self._setTitleBackBarButton()
        self.auth = AuthManager.shared.getLocalAuth()
        self.fetchData()
    }

}

extension MyParkingsViewController {
    private func setUpRefreshControl() {
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }

    @objc private func pullToRefresh() {
        self.parkings.removeAll()
        self.collectionView.reloadData()
        self.fetchData(isShowIndicator: false) {
            self.refreshControl.endRefreshing()
        }
    }
}

extension MyParkingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    private func setUpCollectionView() {
        self.collectionView._registerCell = ParkingCollectionViewCell.self
        self.setUpEmptyDataView()
        self.setUpCHTCollectionViewWaterfallLayout()
        self.setUpRefreshControl()
        self.collectionView.reloadData()
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

}

//MARK: - CollectionView Waterfall Layout
extension MyParkingsViewController: CHTCollectionViewDelegateWaterfallLayout {

    private func setUpCHTCollectionViewWaterfallLayout() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 11
        layout.minimumInteritemSpacing = 11

        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.parkings[indexPath.row].getSizeImage()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

}

extension MyParkingsViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    private func setUpEmptyDataView() {
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
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
        return NSAttributedString.init(string: NO_DATA_MESSAGE, attributes: [NSAttributedString.Key.font: fontMontserratRegular17 ?? UIFont.systemFont(ofSize: 17, weight: .bold)])
    }

}
