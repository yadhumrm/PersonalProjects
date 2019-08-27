//
//  PVCollectionViewLayout.swift
//  PhotoViewer
//
//  Created by Yadhu Manoharan on 27/08/19.
//  Copyright © 2019 YadhuManoharan. All rights reserved.
//

import UIKit


protocol PVCollectionViewLayoutDelegate: class {
    //Find the size of the content at the the inedx
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGSize
}

class PVCollectionViewLayout: UICollectionViewLayout {
    //Layout Delegate
    weak var delegate: PVCollectionViewLayoutDelegate!
    
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 5
    
    //array to store attributes.
    fileprivate var layoutAttributeBackup = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // Content height and size
    fileprivate var contentHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        // Execute only once to find the attribute list
        guard layoutAttributeBackup.count == 0, let collectionView = collectionView else {
            return
        }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        // Iterates through the list of items in the first section
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            // get the size of the picture through delegate and calculates the cell frame.
            let photoSize = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let photoHeight = photoSize.height * contentWidth / (2 * photoSize.width)
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutAttributeBackup.append(attributes)
            
            // Updates the collection view content height
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in layoutAttributeBackup {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributeBackup[indexPath.item]
    }
    
}
