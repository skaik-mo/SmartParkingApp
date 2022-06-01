//  Skaik_mo
//
//  MessageViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 28/03/2022.
//

import UIKit
import IQKeyboardManagerSwift

class MessageViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var messageTextField: UITextField!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lodingImageStack: UIStackView!
    @IBOutlet weak var lodingImageView: UIView!
    @IBOutlet weak var lodingImage: UIImageView!

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!

    private var imagePicker = UIImagePickerController()

    var sender: AuthModel?
    private var receiver: AuthModel?
    private var message: MessageModel?

    private var isSendImage: Bool = false
    private var isLoading: Bool = false {
        didSet {
            self.showOrHideLoading()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
        fetchData()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setKeyboard(false)
    }

    @IBAction func imageAction(_ sender: Any) {
        self.addImage()
    }

    @IBAction func sendAction(_ sender: Any) {
        guard let _text = self.messageTextField.text, _text._isValidValue else { return }
        sendMessage()
    }

}

// MARK: - ViewDidLoad
extension MessageViewController {

    private func setUpViewDidLoad() {
        self.receiver = AuthManager.shared.getLocalAuth()

        if let nameSender = sender?.name {
            self.title = nameSender
        }
        setUpTable()
    }

    private func fetchData() {
        MessageManager.shared.getMessage(senderID: self.sender?.id, receiverID: self.receiver?.id) { message, errorMessage in
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
                return
            }
            self.message?.messages.removeAll()
            self.message = message
            self.tableView.reloadData()
            self.raiseTable()
        }
    }

}

// MARK: - ViewWillAppear
extension MessageViewController {
    private func setUpViewWillAppear() {
        AppDelegate.shared?.rootNavigationController?.setWhiteNavigation()
        self._setTitleBackBarButton()
        setKeyboard(true)
    }
}

extension MessageViewController {

    private func showOrHideLoading() {
        self.sendButton.isEnabled = !self.isLoading
        self.imageButton.isEnabled = !self.isLoading
        if isSendImage {
            self.loadingImageAnimation()
            return
        }
        self.clearData()
    }

    private func clearData() {
        self.messageTextField.text = ""
    }

    // Show Or Hide Loading Image by Animation
    private func loadingImageAnimation() {
        UIView.transition(with: self.lodingImageStack, duration: 0.5,
            options: .transitionFlipFromRight,
            animations: {
                self.isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
                self.messageTextField.placeholder = self.isLoading ? "Loading..." : "write a message"
                self.lodingImageStack.isHidden = !self.isLoading
                self.lodingImage.isHidden = !self.isLoading
                self.lodingImageView.isHidden = !self.isLoading
                self.messageTextField.isUserInteractionEnabled = !self.isLoading
            })
    }

    private func sendMessage(imageData: Data? = nil) {

        if self.message == nil {
            self.message = .init(senderID: self.sender?.id, receiverID: self.receiver?.id)
        }
        let message = Message.init(message: self.messageTextField.text, imageURL: nil, sentDate: Date(), sender: self.receiver?.id)
        self.message?.messages.append(message)

        self.isLoading = true
        MessageManager.shared.setMessage(message: self.message, imageData: imageData) { errorMessage in
            self.isLoading = false
            self.isSendImage = false
            if let _errorMessage = errorMessage {
                self._showErrorAlert(message: _errorMessage)
            }
        }
    }

    private func raiseTable() {
        if let count = self.message?.messages.count, count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                self.tableView.scrollToRow(at: IndexPath.init(item: count - 1, section: 0), at: .top, animated: false)
            }
        }
    }

    private func isReceiver(message: Message?) -> Bool {
        if let _sender = message?.sender, _sender == self.sender?.id {
            return false
        }
        // if Receiver
        return true
    }
}

// MARK: - Keyboard
extension MessageViewController {

    private func setKeyboard(_ isDistanceZero: Bool) {
        if isDistanceZero {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        } else {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        IQKeyboardManager.shared.enable = !isDistanceZero
        IQKeyboardManager.shared.enableAutoToolbar = !isDistanceZero
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = !isDistanceZero
    }


    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let statusBar = self._getStatusBarHeightBottom, let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        bottomConstraint.constant = statusBar - keyboardSize.height
        self.view.layoutIfNeeded()

        if let count = self.message?.messages.count, count > 0 {
            self.tableView.scrollToRow(at: IndexPath.init(item: count - 1, section: 0), at: .top, animated: false)
        }

    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }

}

// MARK: - TableView
extension MessageViewController: UITableViewDelegate, UITableViewDataSource {

    private func setUpTable() {
        self.tableView._registerCell = ReceiverMessageTableViewCell.self
        self.tableView._registerCell = SenderMessageTableViewCell.self
        self.tableView.keyboardDismissMode = .onDrag
        if let count = self.message?.messages.count, count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                self.tableView.scrollToRow(at: IndexPath.init(item: count - 1, section: 0), at: .top, animated: false)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message?.messages.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.message?.messages[indexPath.row]
        if self.isReceiver(message: message) {
            let cell: ReceiverMessageTableViewCell = self.tableView._dequeueReusableCell()
            cell.message = message
            cell.selectionStyle = .none
            cell.configerCell()
            return cell
        } else {
            let cell: SenderMessageTableViewCell = self.tableView._dequeueReusableCell()
            cell.message = message
            cell.selectionStyle = .none
            cell.sender = self.sender
            cell.configerCell()
            return cell
        }

    }

}

// MARK: - ImagePicker
extension MessageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private func addImage() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker._presentVC()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self._dismissVC()
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.lodingImage.image = image
        if let _data = image?._jpeg(.medium) {
            self.isSendImage = true
            self.sendMessage(imageData: _data)
        }
    }

}
