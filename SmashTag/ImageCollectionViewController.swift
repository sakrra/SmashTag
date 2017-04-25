//
//  ImageCollectionViewController.swift
//  SmashTag
//
//  Created by Sami Rämö on 24/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit
import Twitter

private let reuseIdentifier = "imageCollectionCell"

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var mediaItems = Array<MediaItem>() {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        //collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        collectionView?.delegate = self
        registerForPreviewing(with: self, sourceView: collectionView!)
        
        // Register cell classes
        // THIS NEED TO BE REMOVED, OTHERWISE IMAGES ARE NOT SHOWN IN COLLECTION VIEW!!
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCollectionViewLayout(with: size)
    }
    
    private func updateCollectionViewLayout(with size: CGSize) {
        print(size)
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let portraitSize = CGSize(width: floor(size.width / 3 - 20), height: floor(size.width / 3 - 20))
            let landscapeSize = CGSize(width: floor(size.height / 3 - 30), height: floor(size.height / 3 - 30))
            layout.itemSize = (size.width < size.height) ? portraitSize : landscapeSize
            layout.invalidateLayout()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showCollectionImage" {
            if let imageViewerVC = (segue.destination as? ImageViewController) {
                if let cell = (sender as? ImageCollectionViewCell) {
                    imageViewerVC.image = cell.imageView.image
                }
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("mediaItems.count = \(mediaItems.count)")
        return mediaItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        let mediaItem = mediaItems[indexPath.row]
        print("indexPath = \(indexPath)")
        if let imageCell = (cell as? ImageCollectionViewCell) {
            imageCell.imageView.image = nil
            imageCell.imageUrl = mediaItem.url
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = floor(view.frame.size.width / 3 - 20)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    
}

extension ImageCollectionViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = collectionView?.indexPathForItem(at: location) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: ImageViewController.identifier)
            if let imageViewController = viewController as? ImageViewController {
                if let cell = collectionView?.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                    imageViewController.shouldShowWholeImage = false
                    imageViewController.image = cell.imageView.image
                    let attributes = collectionView?.layoutAttributesForItem(at: indexPath)
                    let cellRect = attributes?.frame
                    previewingContext.sourceRect = previewingContext.sourceView.convert(cellRect!, from: collectionView)
                    return imageViewController
                }
            }
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let vc = (viewControllerToCommit as? ImageViewController) {
            vc.shouldShowWholeImage = true
        }
        show(viewControllerToCommit, sender: self)
    }
}

