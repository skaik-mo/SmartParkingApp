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

//    @IBOutlet weak var imageButton: UIButton!
//    @IBOutlet weak var sendButton: UIButton!

    var isSender = true
    var count = 0

    var messages: [Message] = [
        Message.init(message: "Hey, how it is going?", isSender: true, time: "28-3-2022 10:10 am"._dateWithFormate(dataFormat: "dd-MM-yyyy h:mm a")),
        Message.init(message: "Hey, i don't know", isSender: true, time: "28-3-2022 10:11 am"._dateWithFormate(dataFormat: "dd-MM-yyyy h:mm a")),
        Message.init(message: "How are you? That is great idea, we shoud go!", isSender: false, time: "28-3-2022 10:12 am"._dateWithFormate(dataFormat: "dd-MM-yyyy h:mm a")),
        Message.init(message: "Perfect, im fine thanks, when do you have a time?", isSender: true, time: "28-3-2022 10:13 am"._dateWithFormate(dataFormat: "dd-MM-yyyy h:mm a")),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._setTitleBackBarButton()
        setKeyboard(true)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setKeyboard(false)
    }

    @IBAction func imageAction(_ sender: Any) {

    }

    @IBAction func sendAction(_ sender: Any) {
        sendMessage()
    }

}

extension MessageViewController {

    func setupView() {
        self.title = "name another user"
        setUpTable()
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

extension MessageViewController {

    func setKeyboard(_ isDistanceZero: Bool) {
        if isDistanceZero {
//            _addKeyboardObserver()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        } else {
//            _removeKeyboardObserver()
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        IQKeyboardManager.shared.enable = !isDistanceZero
        IQKeyboardManager.shared.enableAutoToolbar = !isDistanceZero
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = !isDistanceZero
    }


    @objc func keyboardWillShow(notification: NSNotification) {
        guard let statusBar = self._getStatusBarHeightBottom, let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        bottomConstraint.constant = statusBar - keyboardSize.height
        self.view.layoutIfNeeded()

        self.tableView.scrollToRow(at: IndexPath.init(item: self.messages.count - 1, section: 0), at: .top, animated: false)

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }

}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {

    private func setUpTable() {
        self.tableView._registerCell = ReceiverMessageTableViewCell.self
        self.tableView._registerCell = SenderMessageTableViewCell.self
        self.tableView.keyboardDismissMode = .onDrag
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.tableView.scrollToRow(at: IndexPath.init(item: self.messages.count - 1, section: 0), at: .top, animated: false)
        }
    }

    private func sendMessage() {
        self.isSender.toggle()
        self.count = self.count == 59 ? 0 : self.count + 1
        let time = "28-3-2022 10:\(self.count) am"
        self.messages.insert(Message.init(message: "Perfect, im fine thanks, when do you have a time??!", isSender: isSender, time: time._dateWithFormate(dataFormat: "dd-MM-yyyy h:mm a")), at: 0)
        self.messages.sort(by: { $0.time < $1.time })
        let last = IndexPath.init(item: self.messages.count - 1, section: 0)
        self.tableView.insertRows(at: [last], with: .bottom)
        self.tableView.scrollToRow(at: last, at: .top, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        if message.isSender ?? false {
            let cell: ReceiverMessageTableViewCell = self.tableView._dequeueReusableCell()
            cell.message = message
            cell.configerCell()
            return cell
        } else {
            let cell: SenderMessageTableViewCell = self.tableView._dequeueReusableCell()
            cell.message = message
            cell.configerCell()
            return cell
        }

    }

}
