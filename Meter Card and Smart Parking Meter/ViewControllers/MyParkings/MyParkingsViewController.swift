//  Skaik_mo
//
//  MyParkingsViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 25/03/2022.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class MyParkingsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var images: [UIImage?] = [
        "demo"._toImage,
        "demo1"._toImage,
        "demo2"._toImage,
        "demo3"._toImage,
        "demo4"._toImage,
    ]

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
    
    
    @IBAction func addParkingAction(sender: Any) {
        let vc: AddParkingViewController = AddParkingViewController._instantiateVC(storyboard: self._businessStoryboard)
        vc._push()
    }

}

extension MyParkingsViewController {

    func setupView() {
        self.title = "My Parkings"
        setUpCollectionView()
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

extension MyParkingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {

    private func setUpCollectionView() {
        self.collectionView._registerCell = ParkingCollectionViewCell.self
        setupCollectionView()
    }

    func setupCollectionView() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 11
        layout.minimumInteritemSpacing = 11

        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ParkingCollectionViewCell = self.collectionView._dequeueReusableCell(for: indexPath)
        cell.parkingImage.image = self.images[indexPath.item]
        cell.configerCell()
        return cell
    }

    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let imageSize = self.images[indexPath.item]?.size
        return imageSize ?? CGSize.init(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
