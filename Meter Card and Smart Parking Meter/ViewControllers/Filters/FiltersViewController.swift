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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func searchAction(_ sender: Any) {
    }
    
    @IBAction func dismissViewAction(_ sender: Any) {
        self._dismissTopToBottom()
        self._dismissVC()
    }
    

}

extension FiltersViewController {

    func setupView() {
        self.title = "Filters"
        
        self.topView._roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        
        self.selectDate.selectionType = .date
        self.selectTime.selectionType = .time
        
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}


