//  Skaik_mo
//
//  DateCell.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import UIKit
import JTAppleCalendar

class DateCell: JTAppleCell {

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var centerView: UIView!

    var selectedDates: [String]?
    var index: Int?
    var cellState: CellState?

    let lightGreen = "D0EFDA"._hexColor
    let green = "A4E0B7"._hexColor
    let gray = "929292"._hexColor

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configerCell() {
        if let _cellState = cellState, let _selectedDates = selectedDates {
            self.dateLabel.text = _cellState.text
            let isSelectedCell = _selectedDates.contains(where: { date in
                return date == _cellState.date._stringData
            })
            selectionCell(isSelected: isSelectedCell, index: index)
        }
    }

    private func selectionCell(isSelected: Bool, index: Int?) {
        self.centerView.backgroundColor = .clear
        if isSelected {
            self.setColorViews(leftColor: lightGreen, rightColor: lightGreen, centerColor: .clear, textColor: gray)
            handleCellSelected(index: index)
            return
        }
        self.setColorViews(leftColor: .clear, rightColor: .clear, centerColor: .clear, textColor: gray)

    }

    private func handleCellSelected(index: Int?) {
        guard let _index = index else { return }
        if _index % 7 == 0 {
            self.setCornerRadius(letfCorner: 7, rightCorner: 0)

        } else if _index % 7 == 6 {
            self.setCornerRadius(letfCorner: 0, rightCorner: 7)

        } else {
            self.setCornerRadius(letfCorner: 0, rightCorner: 0)
        }

        if cellState?.date._stringData == selectedDates?.first {
            if _index % 7 == 6 {
                self.setColorViews(leftColor: .clear, rightColor: .clear, centerColor: green, textColor: .white)

            } else {
                self.setColorViews(leftColor: .clear, rightColor: lightGreen, centerColor: green, textColor: .white)
            }
        }
        if cellState?.date._stringData == selectedDates?.last {
            if _index % 7 == 0 {
                self.setColorViews(leftColor: .clear, rightColor: .clear, centerColor: green, textColor: .white)
            } else {
                self.setColorViews(leftColor: lightGreen, rightColor: .clear, centerColor: green, textColor: .white)
            }
        }
    }

    private func setCornerRadius(letfCorner: CGFloat, rightCorner: CGFloat) {
        leftView._roundCorners(isTopLeft: true, isBottomLeft: true, radius: letfCorner)
        rightView._roundCorners(isTopRight: true, isBottomRight: true, radius: rightCorner)
    }

    private func setColorViews(leftColor: UIColor, rightColor: UIColor, centerColor: UIColor, textColor: UIColor) {
        self.leftView.backgroundColor = leftColor
        self.rightView.backgroundColor = rightColor
        self.centerView.backgroundColor = centerColor
        self.dateLabel.textColor = textColor
    }

}
