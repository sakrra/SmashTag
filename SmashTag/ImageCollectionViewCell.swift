//
//  ImageCollectionViewCell.swift
//  SmashTag
//
//  Created by Sami Rämö on 25/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView! { didSet { updateUI() } }
    
    var imageUrl: URL? { didSet { updateUI() } }
    
    private func updateUI() {
        if imageView != nil {
            if let url = imageUrl {
                print("url = \(url)")
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    if let data = (try? Data(contentsOf: url)) {
                        DispatchQueue.main.async {
                            //print("self?.imageView.image \(self?.imageView.image)")
                            print("data = \(data)")
                            self?.imageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
}
