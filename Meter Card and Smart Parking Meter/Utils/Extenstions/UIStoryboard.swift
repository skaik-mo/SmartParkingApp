//
//  UIStoryboard.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 07/03/2022.
//

import Foundation
import UIKit

extension UIStoryboard {
    static let _mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    func instantiateVC(withIdentifier identifier: String) -> UIViewController? {
         if let identifiersList = self.value(forKey: "identifierToNibNameMap") as? [String: Any] {
              if identifiersList[identifier] != nil {
                  return self.instantiateViewController(withIdentifier: identifier)
              }
          }
          return nil
      }
}
