//  Skaik_mo
//
//  FiltersViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 14/03/2022.
//

import UIKit

class FiltersViewController: UIViewController {

    @IBOutlet weak var slider: ThumbTextSlider!

    @IBOutlet weak var selectDate: SelectDateOrTime!
    @IBOutlet weak var selectTime: SelectDateOrTime!

    var completionHandler: ((FilterModel?) -> Void)?

    let filter = FilterModel.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    @IBAction func searchAction(_ sender: Any) {
        self.search()
    }

    @IBAction func dismissViewAction(_ sender: Any) {
        self._dismissVC()
    }


}

// MARK: - ViewDidLoad
extension FiltersViewController {

    private func setUpViewDidLoad() {
        self.title = FILTERS_TITLE

        self.selectDate.selectionType = .date
        self.selectTime.selectionType = .time

    }
}

extension FiltersViewController {

    private func setDateAndTime() {
        let isEmptyDate = selectDate.isEmptyFields()
        let isEmptyTime = selectTime.isEmptyFields()

        if isEmptyDate.status == false && isEmptyTime.status == false {
            self.filter.fromDate = self.selectDate.fromText
            self.filter.toDate = self.selectDate.toText
            self.filter.fromTime = self.selectTime.fromText
            self.filter.toTime = self.selectTime.toText
        }
//        Date And Time is empty
    }

    private func search() {
        self.filter.distance = self.slider.value._toDouble
        self.setDateAndTime()
        self.completionHandler?(filter)
        self._dismissVC()
    }

}

