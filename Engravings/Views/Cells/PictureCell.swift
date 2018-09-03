//
//  PictureCell.swift
//  Engravings
//
//  Created by Anna Miksiuk on 22.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var blackView: UIView!
    
    // MARK: - Properties
    
    var visiblePicture = false
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureImage.layer.cornerRadius = 15
        pictureImage.layer.borderColor = UIColor.customOrange.cgColor
        pictureImage.layer.borderWidth = 3
        
        blackView.layer.cornerRadius = 15
        blackView.layer.borderColor = UIColor.customOrange.cgColor
        blackView.layer.borderWidth = 3
        
        blackView.alpha = 1
    }
    
    override func prepareForReuse() {
        pictureImage.image = nil
        visiblePicture = false
        blackView.alpha = 1
    }
    
    override var reuseIdentifier: String? {
        get {
            return "PictureCell"
        }
    }
    
    // MARK: - Private
    
    func configureCell(image: UIImage, visible: Bool) {
        pictureImage.image = image
        visiblePicture = visible
        if visiblePicture {
            blackView.alpha = 0
        }
    }
    
}
