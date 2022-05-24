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

    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!

    var message: Message?
    var sender: AuthModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configerCell() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(fullImageAction))
        messageImage.addGestureRecognizer(tap)
        
        self.stackView._roundCorners(isTopLeft: true, isTopRight: true, isBottomRight: true, radius: 10)

        self.senderImage.fetchImage(sender?.urlImage)

        if let sentDate = self.message?.sentDate {
            if let imageURL = self.message?.imageURL, imageURL._isValidValue {
                self.messageImage._roundCorners(isTopLeft: true, isTopRight: true, isBottomRight: true, radius: 6)
                self.setData(false)
                self.messageImage.fetchImageWithActivityIndicator(imageURL, "ic_placeholderImage")

            } else if let _message = self.message?.message, _message._isValidValue {
                self.setData(true)
                self.messageLabel.text = _message
            }
            self.timeLabel.text = sentDate._stringTime
        }
    }

    private func setData(_ isHiddenImage: Bool) {
        let vertical: CGFloat = isHiddenImage ? 14 : 4
        let horizontal: CGFloat = isHiddenImage ? 14 : 4

        self.stackView.directionalLayoutMargins = NSDirectionalEdgeInsets.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
        self.messageImage.isHidden = isHiddenImage
        self.messageLabel.isHidden = !isHiddenImage
    }
    
    @objc private func fullImageAction() {
        let vc: ZoomViewController = ZoomViewController._instantiateVC(storyboard: self._accountStoryboard)
        vc.imageSelected = self.messageImage.image
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc._presentVC()
    }

}
