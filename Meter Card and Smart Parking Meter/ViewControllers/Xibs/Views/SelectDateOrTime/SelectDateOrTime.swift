//  Skaik_mo
//
//  SelectDateOrTime.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 14/03/2022.
//

import UIKit

class SelectDateOrTime: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var fromImageView: UIImageView!
    @IBOutlet weak var toImageView: UIImageView!

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!

    enum SelectionType {
        case date
        case time
    }

    var selectionType: SelectionType = .date {
        didSet {
            setUpView()
        }
    }

    var isHiddenIcons: Bool = false {
        didSet {
            setIcons()
        }
    }

    var fromText: String {
        var value = ""
        if let _text = self.fromLabel.text {
            if _text.lowercased().contains("from") {
                value = ""
            } else {
                value = _text._removeWhiteSpace
            }
        }
        return value
    }

    var toText: String {
        var value = ""
        if let _text = self.toLabel.text {
            if _text.lowercased().contains("to") {
                value = ""
            } else {
                value = _text._removeWhiteSpace
            }
        }
        return value
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureXib()
    }

    private func configureXib() {
        Bundle.main.loadNibNamed(SelectDateOrTime._id, owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()
    }

    @IBAction func FromAction(_ sender: Any) {
        showDateOrTime { value in
            if let _value = value {
                self.fromLabel.text = _value
                self.isHiddenIcons = true
            }
        }
    }


    @IBAction func toAction(_ sender: Any) {
        showDateOrTime { value in
            if let _value = value {
                self.toLabel.text = _value
                self.isHiddenIcons = true
            }

        }
    }




}

extension SelectDateOrTime {
    private func setIcons() {
        self.toImageView.isHidden = self.isHiddenIcons
        self.fromImageView.isHidden = self.isHiddenIcons
    }

    private func setUpView() {
        if selectionType == .date {
            setDate()
            return
        }
        setTime()
    }

    private func setDate() {
        self.title.text = SELECT_APPROPRIATE_DTAE_MESSAGE
        fromImageView.image = ic_calendar._toImage
        toImageView.image = ic_calendar._toImage
    }

    private func setTime() {
        self.title.text = SELECT_APPROPRIATE_TIME_MESSAGE
        fromImageView.image = ic_clock._toImage
        toImageView.image = ic_clock._toImage

    }

    private func showDateOrTime(handle: @escaping (_ value: String?) -> Void) {
        let alert = UIAlertController(style: .actionSheet, title: "Select \(selectionType.self)")
        let date = Date()._add(months: 2)
        var isSelectedValue = false
        if self.selectionType == .date {
            alert.addDatePicker(mode: .date, date: Date(), minimumDate: Date(), maximumDate: date) { date in
                handle(date._stringData)
                isSelectedValue = true
            }
        } else {
            alert.addDatePicker(mode: .time, date: Date(), minimumDate: Date()._add(days: -1), maximumDate: date) { time in
                handle(time._stringTime)
                isSelectedValue = true
            }
        }
        let okayAction = UIAlertAction.init(title: "OK", style: .cancel) { action in
            if !isSelectedValue {
                handle(self.selectionType == .date ? Date()._stringData: Date()._stringTime)
            }
        }
        alert.addAction(okayAction)
        alert._show()
    }

    private func checkDateOrTime() -> (status: Bool, errorMessage: String?) {
        switch self.selectionType {
        case .date:
            if let from = self.fromText._toDate, let to = self.toText._toDate {
                if from._isSame(date: to) || from._isBefore(date: to) {
                    return (false, nil)
                }
            }
            return (true, FINAL_DATA_ERROR_MESSAGE)
        case .time:
            if let from = self.fromText._toTime, let to = self.toText._toTime {
                if from._isBefore(date: to) {
                    return (false, nil)
                }
            }
            return (true, FINAL_TIME_ERROR_MESSAGE)
        }
    }

    func isEmptyFields() -> (status: Bool, errorMessage: String?) {
        if fromText._isValidValue, toText._isValidValue {
            return checkDateOrTime()
        }
        return (true, "Enter \(selectionType) fields")
    }

    func setData(from: String?, to: String?) {
        guard let _from = from, let _to = to else { return }
        self.fromLabel.text = _from
        self.toLabel.text = _to
        setEnable(isEnable: false)

    }

    private func setEnable(isEnable: Bool) {
        self.fromImageView.isUserInteractionEnabled = isEnable
        self.toImageView.isUserInteractionEnabled = isEnable
    }

}
