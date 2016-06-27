//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by William Zhang on 16/6/27.
//  Copyright © 2016年 Rounak Jain. All rights reserved.
//

import UIKit

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
  
  var anchorPoint = CGPoint(x: 0.5, y: 0.5)
  var angle: CGFloat = 0 {
    didSet {
      zIndex = Int(angle * 1000000)
      transform = CGAffineTransformMakeRotation(angle)
    }
  }
  
  override func copyWithZone(zone: NSZone) -> AnyObject {
    let copiedAttributes = super.copyWithZone(zone) as! CircularCollectionViewLayoutAttributes
    copiedAttributes.anchorPoint = anchorPoint
    copiedAttributes.angle = angle
    return copiedAttributes
  }
}

class CircularCollectionViewLayout: UICollectionViewLayout {

  let itemSize = CGSize(width: 133, height: 173)
  var radius: CGFloat = 500 {
    didSet {
      invalidateLayout()
    }
  }
  
  var anglePerItem: CGFloat {
    return atan(itemSize.width / radius)
  }
  
  var attributesList = [CircularCollectionViewLayoutAttributes]()
  
  var angleAtExtreme: CGFloat {
    return collectionView!.numberOfItemsInSection(0) > 0 ? -CGFloat(collectionView!.numberOfItemsInSection(0) - 1) : 0
  }
  
  var angle: CGFloat {
    return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize().width - CGRectGetWidth(collectionView!.bounds))
  }
  
  override class func layoutAttributesClass() -> AnyClass {
    return CircularCollectionViewLayoutAttributes.self
  }
  
  override func prepareLayout() {
    super.prepareLayout()
    
    let centerX = collectionView!.contentOffset.x + CGRectGetWidth(collectionView!.bounds) / 2.0
    let anchorPointY = (itemSize.height / 2.0 + radius) / itemSize.height
    
    let theta = atan2(CGRectGetWidth(collectionView!.bounds) / 2, radius + itemSize.height / 2 - CGRectGetHeight(collectionView!.bounds) / 2)
    
    var startIndex = 0
    var endIndex   = collectionView!.numberOfItemsInSection(0) - 1
    
    if angle < -theta {
      startIndex = Int(floor((-theta - angle) / anglePerItem))
    }
    
    endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
    if startIndex > endIndex {
      startIndex = 0
      endIndex   = 0
    }
    
    attributesList = (startIndex...endIndex).map { (i) -> CircularCollectionViewLayoutAttributes in
      let attributes = CircularCollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: i, inSection: 0))
      
      attributes.size   = itemSize
      attributes.center = CGPoint(x: centerX, y: CGRectGetMidY(collectionView!.bounds))
      attributes.angle  = anglePerItem * CGFloat(i) + angle
      attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
      
      return attributes
    }
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributesList
  }
  
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    return attributesList[indexPath.item]
  }
  
  override func collectionViewContentSize() -> CGSize {
    return CGSize(width: CGFloat(collectionView!.numberOfItemsInSection(0)) * itemSize.width, height: CGRectGetHeight(collectionView!.bounds))
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
}
