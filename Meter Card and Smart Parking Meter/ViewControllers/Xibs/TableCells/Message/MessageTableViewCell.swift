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

    var message: MessageModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configerCell() {
        self.getSender(message: self.message)
        if let lastMessage = message?.messages.last, let message = lastMessage?.message, let time = lastMessage?.sentDate?._stringTime {
            if message._isValidValue {
                self.lastMessageLabel.text = message
            } else {
                self.lastMessageLabel.text = "Photo"
            }
            self.timeMessageLabel.text = time
        } else {
            self.lastMessageLabel.text = ""
            self.timeMessageLabel.text = ""
        }
    }

    private func getSender(message: MessageModel?) {
        var senderID = message?.senderID
        if message?.senderID == AuthManager.shared.getLocalAuth()?.id {
            senderID = message?.receiverID
        }
        AuthManager.shared.getAuth(id: senderID) { auth, message in
            self.imageSendView.fetchImageWithActivityIndicator(auth?.urlImage, ic_placeholderPerson)
            if let name = auth?.name {
                self.nameSendLabel.text = name
            }
        }
    }

}
