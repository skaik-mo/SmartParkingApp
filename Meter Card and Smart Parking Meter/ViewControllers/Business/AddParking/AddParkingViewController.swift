//  Skaik_mo
//
//  AddParkingViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 26/03/2022.
//

import UIKit
import GoogleMaps

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

    @IBOutlet weak var parkLicenseText: CustomText!

    private var coordinate: CLLocationCoordinate2D?

    private var isPerDay: Bool = false {
        didSet {
            self.switchButtons()
        }
    }

    private var imagePicker = UIImagePickerController()
    private var heightImage: CGFloat? = 0
    private var widthImage: CGFloat? = 0
    private var dataParking: Data?
    private var dataParkLicense: Data?
    private var isParkingImage: Bool?

    private var auth: AuthModel?

    var completionHandler: ((ParkingModel) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
    }

    @IBAction func addPhotosAction(_ sender: Any) {
        self.addImage(isParkingImage: true)
    }

    @IBAction func addParkingAction(_ sender: Any) {
        self.save()
    }

    @IBAction func goToSelectLoactionAction(_ sender: Any) {
        let vc: AddLocationViewController = AddLocationViewController._instantiateVC(storyboard: self._businessStoryboard)
        vc.handler = { coordinate in
            self.coordinate = coordinate
        }
        vc._push()
    }

}

// MARK: - ViewDidLoad
extension AddParkingViewController {

    private func setUpViewDidLoad() {
        self.title = "Add new Parking"

        self.auth = AuthManager.shared.getLocalAuth()

        GoogleMapManager.shared.currentLocation(mapView: self.mapView, icon: ic_pointLoactionMarker._toImage)

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

        numberOfParking.numberOfParkingText.isHidden = false
        self.numberOfParking.setUpNumberOfParking(typeSpotButton: .grayWithBorder, title: "Spots", spots: 1)

        self.isPerDay = false

        self.parkLicenseText.showCameraIcon = true
        self.parkLicenseText.handleAddImage = {
            self.addImage(isParkingImage: false)
        }

        self.hourButton.handleButton = {
            self.isPerDay = false

        }

        self.perdayButton.handleButton = {
            self.isPerDay = true
        }
    }

    private func switchButtons() {
        if self.isPerDay {
            self.perdayButton.setUp(typeButton: .greenButton, corner: 6)
            self.hourButton.setUp(typeButton: .grayButton, corner: 6)
            return
        }
        self.hourButton.setUp(typeButton: .greenButton, corner: 6)
        self.perdayButton.setUp(typeButton: .grayButton, corner: 6)
    }

}

// MARK: - ViewWillAppear
extension AddParkingViewController {

    private func setUpViewWillAppear() {
        self._setTitleBackBarButton()
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
        if self.dataParking == nil {
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
        if coordinate == nil {
            self._showErrorAlert(message: "Click on map and add location")
            return false
        }
        if let message = self.numberOfParking.checkNumberOfParkig() {
            self._showErrorAlert(message: message)
            return false
        }
        if self.dataParkLicense == nil {
            self._showErrorAlert(message: "Enter park license")
            return false
        }
        if !(self.auth?.id?._isValidValue ?? false), !(self.auth?.name?._isValidValue ?? false), !(self.auth?.plateNumber?._isValidValue ?? false) {
            self._showErrorAlert(message: "You must log out and try to log in again")
            return false
        }
        return true
    }

    private func getParking() -> ParkingModel? {
        guard self.checkData() else { return nil }

        return .init(uid: self.auth?.id, name: self.parkingNameText._getText,height: self.heightImage, width: self.widthImage, fromDate: self.selectDate.fromText, toDate: selectDate.toText, fromTime: selectTime.fromText, toTime: selectTime.toText, price: priceText._getText, spots: self.numberOfParking.numberOfParkingText._getText._toInteger, latitude: self.coordinate?.latitude, longitude: self.coordinate?.longitude, isPerDay: self.isPerDay)
    }

    private func save() {
        guard let _parking = self.getParking() else { return }
        ParkingManager.shared.setParking(parking: _parking, dataParking: self.dataParking, dataParkLicense: self.dataParkLicense) { errorMessage in
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
                return
            }
            self.completionHandler?(_parking)
            self._pop()
        }
    }

}

extension AddParkingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private func addImage(isParkingImage: Bool) {
        self.isParkingImage = isParkingImage
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker._presentVC()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self._dismissVC()
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let _data = image?._jpeg(.low) {
            if self.isParkingImage == true {
                self.heightImage = image?.size.height
                self.widthImage = image?.size.width
                self.parkingImage.image = image
                self.dataParking = _data
            } else {
                self.parkLicenseText.isSelectedText = true
                self.dataParkLicense = _data
            }
        }
    }

}

