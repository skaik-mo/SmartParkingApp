//  Skaik_mo
//
//  MessageTableViewCell.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 22/03/2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageSendView: rImage!
    
    @IBOutlet weak var nameSendLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    @IBOutlet weak var timeMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configerCell() {
        
    }
    
}
