//  Skaik_mo
//
//  AddParkingViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 26/03/2022.
//

import UIKit
import GoogleMaps
import MMBGoogleLocationPicker

class AddParkingViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var parkingNameText: UITextField!

    @IBOutlet weak var parkingImage: UIImageView!

    @IBOutlet weak var selectDate: SelectDateOrTime!
    @IBOutlet weak var selectTime: SelectDateOrTime!

    @IBOutlet weak var numberOfParking: NumberOfParking!

    @IBOutlet weak var hourButton: GreenButton!
    @IBOutlet weak var perdayButton: GreenButton!

    @IBOutlet weak var priceText: UITextField!
    
    var isSelectedPriceHour: Bool = true {
        didSet {
            self.switchButtons()
        }
    }
    
    var locationManager = CLLocationManager()

    var imagePicker = UIImagePickerController()
    var dataImage: Data?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._setTitleBackBarButton()
    }
    
    @IBAction func addPhotosAction(_ sender: Any) {
        debugPrint("addPhotosAction")
        self.addImage()
    }
    
    @IBAction func addParkingAction(_ sender: Any) {
        self.save()
    }
    
    @IBAction func goToSelectLoactionAction(_ sender: Any) {
        debugPrint("goToSelectLoactionAction")

//        LocationPicker.GMSServicesKey = GoogleMapManager.API_KEY
//        LocationPicker.GMSPlacesClientKey = GoogleMapManager.API_KEY
//        let locationPicker = LocationPicker.shared
//        locationPicker.pickCompletion = { (pickedLocationItem) in
//            if let coordinate = pickedLocationItem.coordinate {
//                debugPrint("Picked location is (latitude: \(coordinate.latitude), longitude: \(coordinate.longitude))")
//                GoogleMapManager.currentLocation(mapView: self.mapView, coordinate: coordinate, icon: "ic_pointLoaction"._toImage)
//            }
//        }
//        locationPicker.addBarButtons()
//        // Call this method to add a done and a cancel button to navigation bar and set navigation bar background.
//        let navigationController = UINavigationController(rootViewController: locationPicker)
//        navigationController.navigationBar.isTranslucent = false
//        navigationController.navigationBar.tintColor = .white
//        navigationController.navigationBar.barTintColor = .black
//        navigationController.view.backgroundColor = .black
//        navigationController.viewControllers.first?.view.backgroundColor = .black
//        present(navigationController, animated: true, completion: nil)
        
    }
    
    
    
}

extension AddParkingViewController {

    func setupView() {
        self.title = "Add new Parking"
        
        GoogleMapManager.currentLocation(mapView: self.mapView, coordinate: self.locationManager.location?.coordinate, icon: "ic_pointLoaction"._toImage)
        
        self.parkingNameText._placeholderColor = .black
        
        self.selectDate.selectionType = .date
        self.selectDate.title.text = "Availability:"
        self.selectDate.title.textColor = .black
        self.selectDate.isHiddenIcons = true
        self.selectDate.fromImageView.isHidden = false
        self.selectDate.fromLabel.text = "Date From"


        self.selectTime.selectionType = .time
        self.selectTime.title.isHidden = true
        self.selectTime.isHiddenIcons = true
        self.selectTime.fromImageView.isHidden = false
        self.selectTime.fromLabel.text = "Time From"

        numberOfParking.typeParkingView = .grayWithBorder
        numberOfParking.button.isHidden = false
        numberOfParking.title.text = "Spots"

        self.isSelectedPriceHour = true
        
        self.hourButton.handleButton = {
            debugPrint("hourButton")
            self.isSelectedPriceHour = true

        }
        
        self.perdayButton.handleButton = {
            debugPrint("perdayButton")
            self.isSelectedPriceHour = false
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func switchButtons() {
        if self.isSelectedPriceHour {
            self.hourButton.setUp(typeButton: .greenButton, corner: 6)
            self.perdayButton.setUp(typeButton: .grayButton, corner: 6)
            return
        }
        self.perdayButton.setUp(typeButton: .greenButton, corner: 6)
        self.hourButton.setUp(typeButton: .grayButton, corner: 6)

    }

}

extension AddParkingViewController {

    private func checkData() -> Bool {
        let isDateFieldsEmpty = self.selectDate.isEmptyFields()
        let isTimeFieldsEmpty = self.selectTime.isEmptyFields()

        if !parkingNameText._getText._isValidValue {
            self._showErrorAlert(message: "Enter parking name")
            return false
        }
        if self.dataImage == nil {
            self._showErrorAlert(message: "Enter parking image")
            return false
        }
        if isDateFieldsEmpty.status {
            self._showErrorAlert(message: isDateFieldsEmpty.errorMessage)
            return false
        }
        if isTimeFieldsEmpty.status {
            self._showErrorAlert(message: isTimeFieldsEmpty.errorMessage)
            return false
        }
        if !priceText._getText._isValidValue {
            self._showErrorAlert(message: "Enter price")
            return false
        }
        return true
    }

//    private func clearData() {
//    }

    private func getParking() -> ParkingModel? {
        guard self.checkData() else { return nil }
        
        return .init(name: self.parkingNameText._getText, fromDate: self.selectDate.fromText, toDate: selectDate.toText, fromTime: selectTime.fromText, toTime: selectTime.toText, price: priceText._getText, spots: nil, latitude: nil, longitude: nil)
    }

    private func save() {
        guard let _parking = self.getParking() else { return }
        ParkingManager.shared.setParking(parking: _parking, data: self.dataImage) { error in
            if let _error = error {
                self._showErrorAlert(message: _error.localizedDescription)
                return
            }
            debugPrint("added Parking")
        }
     
    }

}

extension AddParkingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func addImage() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker._presentVC()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        self._dismissVC()
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.parkingImage.image = image
        self.dataImage = image?.pngData()
    }

}

