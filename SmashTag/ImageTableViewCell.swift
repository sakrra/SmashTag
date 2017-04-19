//
//  ImageTableViewCell.swift
//  SmashTag
//
//  Created by Sami Rämö on 17/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tweetImageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tweetImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var tweetImageURL: URL? { didSet { updateUI() } }
    
    private func updateUI() {
        if let url = tweetImageURL {
            print("Image url = \(url)")
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.spinner.startAnimating()
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self?.tweetImageView.image = UIImage(data: data)
                        self?.spinner.stopAnimating()
                    }
                }
            }
            
        }
    }

}
