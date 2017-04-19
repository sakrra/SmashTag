//
//  ImageViewController.swift
//  SmashTag
//
//  Created by Sami Rämö on 19/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            //imageView.contentMode = .scaleAspectFill
            scrollView?.contentSize = imageView.frame.size
            scrollView?.zoom(to: imageView.frame, animated: false)
            setZoomScales()
        }
    }
    
    override func viewDidLayoutSubviews() {
        setZoomScales()
    }
    
    private func setZoomScales() {
        let widthScale = view.frame.size.width / imageView.bounds.width
        let heightScale = view.frame.size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        let scale = max(widthScale, heightScale) // starting zoom scale
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = scale
    }
}


extension ImageViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
