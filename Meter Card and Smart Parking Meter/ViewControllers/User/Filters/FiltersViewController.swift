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
    
    @IBOutlet weak var topView: UIView!
    
    var completionHandler: ((FilterModel?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let filter = FilterModel.init(distance: slider.value._toDouble, fromDate: self.selectDate.fromText, toDate: self.selectDate.toText, fromTime: self.selectTime.fromText, toTime: self.selectTime.toText)
        self.completionHandler?(filter)
        self._dismissTopToBottom()
        self._dismissVC()
    }
    
    @IBAction func dismissViewAction(_ sender: Any) {
        self._dismissTopToBottom()
        self._dismissVC()
    }
    

}

// MARK: - ViewDidLoad
extension FiltersViewController {

    private func setUpViewDidLoad() {
        self.title = "Filters"
        
        self.topView._roundCorners(isBottomLeft: true, isBottomRight: true, radius: 5)
        self.selectDate.selectionType = .date
        self.selectTime.selectionType = .time
        
    }
}


