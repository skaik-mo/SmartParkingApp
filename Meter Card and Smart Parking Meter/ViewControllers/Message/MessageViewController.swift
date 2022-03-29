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
        Message.init(message: "Perfect, im fine thanks, when do you have a time?", isSender: true, time: "28-3-2022 10:13 am"._dateWithFormate(dataFormat: "dd-MM-yyyy h:mm a"))
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        self.messages = self.messages.reversed()
        setUpTable()
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

    func setKeyboard(_ isDistanceZero: Bool) {
        IQKeyboardManager.shared.shouldResignOnTouchOutside = isDistanceZero
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = !isDistanceZero
        IQKeyboardManager.shared.enableAutoToolbar = !isDistanceZero
        IQKeyboardManager.shared.keyboardDistanceFromTextField =  isDistanceZero ? 0 : 10.0
    }

}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {

    private func setUpTable() {
        self.tableView._registerCell = ReceiverMessageTableViewCell.self
        self.tableView._registerCell = SenderMessageTableViewCell.self
//        self.tableView.scrollToRow(at: IndexPath.init(item: self.messages.count - 1, section: 0), at: .bottom, animated: true)
    }

    private func sendMessage() {
        self.isSender.toggle()
        self.count = self.count == 59 ? 0 : self.count + 1
        let time = "28-3-2022 10:\(self.count) am"
        self.messages.insert(Message.init(message: "Perfect, im fine thanks, when do you have a time??!", isSender: isSender, time: time._dateWithFormate(dataFormat: "dd-MM-yyyy h:mm a")), at: 0)
        self.tableView.insertRows(at: [IndexPath.init(item: 0, section: 0)], with: .bottom)
//        self.tableView.scrollToRow(at: IndexPath.init(item: self.messages.count - 1, section: 0), at: .bottom, animated: true)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        let message = self.messages[indexPath.row]
        if message.isSender ?? false {
            let cell: ReceiverMessageTableViewCell = self.tableView._dequeueReusableCell(for: indexPath)
            cell.message = message
            cell.configerCell()
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        } else {
            let cell: SenderMessageTableViewCell = self.tableView._dequeueReusableCell(for: indexPath)
            cell.message = message
            cell.configerCell()
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }

    }

}
