//
//  Helper.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 04/05/2022.
//

import Foundation
import ProgressHUD

class Helper {

    // if fromDate1 is Before or equal to fromDate2 and toDate1 is After or equal to toDate2 ==> true else false
    class func compareDate(fromDate1: String?, toDate1: String?, fromDate2: String?, toDate2: String?) -> Bool {
        guard let _fromDate1 = fromDate1?._toDate, let _fromDate2 = fromDate2?._toDate, let _toDate1 = toDate1?._toDate, let _toDate2 = toDate2?._toDate else { return false }
        if (_fromDate1._isBefore(date: _fromDate2) || _fromDate1._isSame(date: _fromDate2)), (_toDate1._isAfter(date: _toDate2) || _toDate1._isSame(date: _toDate2)) {
            return true
        }
        return false
    }


    // if fromTime1 is Before or equal to fromTime2 and toTime1 is After or equal to toTime2 ==> true else false
    class func compareTime(fromTime1: String?, toTime1: String?, fromTime2: String?, toTime2: String?) -> Bool {
        guard let _fromTime1 = fromTime1?._toTime, let _fromTime2 = fromTime2?._toTime, let _toTime1 = toTime1?._toTime, let _toTime2 = toTime2?._toTime else { return false }
        if (_fromTime1._isBefore(date: _fromTime2) || _fromTime1._isSame(date: _fromTime2)), (_toTime1._isAfter(date: _toTime2) || _toTime1._isSame(date: _toTime2)) {
            return true
        }
        return false
    }


    class func equalComparisonDate(fromDate1: String?, toDate1: String?, fromDate2: String?, toDate2: String?) -> Bool {
        guard let _fromDate1 = fromDate1?._toDate, let _fromDate2 = fromDate2?._toDate, let _toDate1 = toDate1?._toDate, let _toDate2 = toDate2?._toDate else { return false }
        if _fromDate1._isSame(date: _fromDate2) || _toDate1._isSame(date: _toDate2) {
            return true
        }
        return false
    }

    class func equalComparisonTime(fromTime1: String?, toTime1: String?, fromTime2: String?, toTime2: String?) -> Bool {
        guard let _fromTime1 = fromTime1?._toTime, let _fromTime2 = fromTime2?._toTime, let _toTime1 = toTime1?._toTime, let _toTime2 = toTime2?._toTime else { return false }
        if _fromTime1._isSame(date: _fromTime2) || _toTime1._isSame(date: _toTime2) {
            return true
        }
        return false
    }

    class func showIndicator(_ isShowIndicator: Bool) {
        if isShowIndicator {
            ProgressHUD.showIndicator()
        }
    }

    class func dismissIndicator(_ isShowIndicator: Bool) {
        if isShowIndicator {
            ProgressHUD.dismissIndicator()
        }
    }

}
