//
//  SRFCarouselFlowLayout.swift
//  EazyDinerProd
//
//  Created by Mohd Sultan on 07/01/20.
//  Copyright © 2020 Mohd Sultan. All rights reserved.
//

import UIKit

class SRFCarouselFlowLayout: UICollectionViewFlowLayout {
    
    var activeDistance: CGFloat = 200
    var zoomFactor: CGFloat = 0.3
    var numberOfSections = 0
    var numberOfItems = 0

    override init() {
        super.init()
        
        scrollDirection = .horizontal
    }
    
    init(itemSize: CGSize, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat,activeDistance: CGFloat? = 200, zoomFactor: CGFloat? = 0.3 ) {
        super.init()
        scrollDirection = .horizontal
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.itemSize = itemSize
        self.activeDistance = activeDistance ?? 200
        self.zoomFactor = zoomFactor ?? 0.3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        setupCollectionView()
        guard let collectionView = collectionView else { fatalError() }
        let collectionSize = collectionView.bounds.size
        let yInset = (collectionSize.height - self.itemSize.height) / 2
        let xInset = (collectionSize.width - self.itemSize.width) / 2
        self.sectionInset = UIEdgeInsets.init(top: yInset, left: xInset, bottom: yInset, right: xInset)
        self.numberOfItems = collectionView.numberOfItems(inSection: 0)

    }
    
    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        
        // Make the cells be zoomed when they reach the center of the screen
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance
            
//            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                let visibleRect = CGRect(origin: self.collectionView!.contentOffset, size: self.collectionView!.bounds.size)
                let dist = attributes.frame.midX-visibleRect.midX
                var transform = CATransform3DScale(CATransform3DIdentity, zoom, zoom, 1)
                transform = CATransform3DTranslate(transform, 0, 0, -abs(dist/1000))

                attributes.transform3D = transform
                attributes.zIndex = Int(zoom.rounded())
//            }
        }
        
        return rectAttributes
        
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView , !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }

        let isHorizontal = (self.scrollDirection == .horizontal)

        let midSide = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height) / 2
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide

        var targetContentOffset: CGPoint
        if isHorizontal {
            let closest = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        }
        else {
            let closest = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
        }

        return targetContentOffset

    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
    
}
