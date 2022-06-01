//
//  ZoomViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 24/05/2022.
//

import Foundation
import UIKit

class ZoomViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    var imageSelected: UIImage?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        scrollView.delegate = self

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.zoomScale = 1.0

        self.imageView.image = self.imageSelected
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(didTap))
        tap.numberOfTapsRequired = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc private func didTap(){
        scrollView.setZoomScale(1, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }


}
