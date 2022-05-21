//  Skaik_mo
//
//  SenderMessageTableViewCell.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 28/03/2022.
//

import UIKit

class SenderMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var message: Message?
    var sender: AuthModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configerCell() {
        self.stackView._roundCorners(isTopLeft: true, isTopRight: true, isBottomRight: true, radius: 10)

        AuthManager.shared.setImage(authImage: self.senderImage, urlImage: self.sender?.urlImage)

        if let _message = self.message?.message, let sentDate = self.message?.sentDate {
            self.messageLabel.text = _message
            self.timeLabel.text = sentDate._stringTime
        }
    }
    
}
