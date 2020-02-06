//
//  SRFCarouselCollectionView.swift
//  EazyDinerProd
//
//  Created by Mohd Sultan on 07/01/20.
//  Copyright © 2020 Mohd Sultan. All rights reserved.
//

import UIKit

class SRFCarouselCollectionView: UIView {

    
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle =  Bundle(for: type(of: self))
        let nib = UINib(nibName: "SRFCarouselCollectionView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
