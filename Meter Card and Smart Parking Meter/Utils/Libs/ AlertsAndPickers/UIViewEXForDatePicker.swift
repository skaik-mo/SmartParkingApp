//
//  UIViewEXForDatePicker.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/03/2022.
//

import Foundation
import UIKit

extension UIView {
    
    /// This is the function to get subViews of a view of a particular type
        /// https://stackoverflow.com/a/45297466/5321670
        func subViews<T : UIView>(type : T.Type) -> [T]{
            var all = [T]()
            for view in self.subviews {
                if let aView = view as? T{
                    all.append(aView)
                }
            }
            return all
        }
        
        
        /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
        /// https://stackoverflow.com/a/45297466/5321670
        func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
            var all = [T]()
            func getSubview(view: UIView) {
                if let aView = view as? T{
                    all.append(aView)
                }
                guard view.subviews.count>0 else { return }
                view.subviews.forEach{ getSubview(view: $0) }
            }
            getSubview(view: self)
            return all
        }

}
