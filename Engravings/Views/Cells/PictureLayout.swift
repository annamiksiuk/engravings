//
//  PictureLayout.swift
//  Engravings
//
//  Created by Anna Miksiuk on 22.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

class PictureLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    
    private var sizeCell: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let screenBounds = collectionView.bounds
        let size = screenBounds.size.width / 2
        return size
    }
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: - Methods
    
    override func prepare() {
        
        cache.removeAll()
        contentHeight = 0
        
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        
        let countElements = collectionView.numberOfItems(inSection: 0)
        
        var column: CGFloat = 0
        var row: CGFloat = 0
        
        for item in 0..<countElements {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let frame = CGRect(x: column * sizeCell,
                               y: row * sizeCell,
                               width: sizeCell,
                               height: sizeCell)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            
            column += 1
            if column >= 2 {
                row += 1
                column = 0
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
