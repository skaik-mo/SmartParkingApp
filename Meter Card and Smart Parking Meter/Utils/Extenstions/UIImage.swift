//
//  UIImage.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 22/05/2022.
//

import Foundation

import UIKit

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    
    convenience init?(url: URL?) {
        guard let url = url else { return nil }

        do {
            self.init(data: try Data(contentsOf: url))
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

//func _sizeOfImageAt(url: URL) -> CGSize? {
//    // with CGImageSource we avoid loading the whole image into memory
//    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
//
//    let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
//    guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else { return nil }
//
//    if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat, let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
//        return CGSize(width: (width * 2), height: (height * 2))
//    } else {
//        return nil
//    }
//}
