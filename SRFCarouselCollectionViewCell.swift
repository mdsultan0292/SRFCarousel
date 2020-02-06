//
//  SRFCarouselCollectionViewCell.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Mohd Sultan on 07/01/20.
//  Copyright © 2020 Mohd Sultan. All rights reserved.
//

import UIKit

class SRFCarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var centreLabel: UILabel!
    @IBOutlet weak var pointerImgView: UIImageView!
    @IBOutlet weak var planCardView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var constraintsBottomPlanCardView: NSLayoutConstraint!
    
    
    let gradient: CAGradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bgView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        pointerImgView.isHidden = true
        self.roundCorners(with: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 5.0)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       bgView.layer.cornerRadius = 7
        setupPointerTriangle()
    }
    
    //Draw the bottom triangle.
    private func setupPointerTriangle(){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: pointerImgView.frame.width/2, y: pointerImgView.frame.height))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: pointerImgView.frame.width, y: 0.0))
        path.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.9921568627, green: 0.3725490196, blue: 0.05882352941, alpha: 1).cgColor//FD5F0F
        self.pointerImgView.layer.addSublayer(shapeLayer)
    }

    func setupCellLayouts(_ isSelectedCell: Bool){
        
        if isSelectedCell{
            pointerImgView.isHidden = false
            constraintsBottomPlanCardView.constant = 5
            DispatchQueue.main.async {
                self.applyGradient(colours: [#colorLiteral(red: 1, green: 0.5019607843, blue: 0, alpha: 1), #colorLiteral(red: 0.9803921569, green: 0.2745098039, blue: 0.0862745098, alpha: 1)])
            }
            planCardView.layer.cornerRadius = 0.0
            
        }else{
            gradient.removeFromSuperlayer()
            bgView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            pointerImgView.isHidden = true
            constraintsBottomPlanCardView.constant = 1.0
            self.roundCorners(with: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 5.0)
        }
        UIView.animate(withDuration: 0.15) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    
    //Add gredient with shadow and round corner.
    func applyGradient(colours: [UIColor])  {
        gradient.removeFromSuperlayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = self.bgView.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.cornerRadius = 5
        
        gradient.masksToBounds = false
        gradient.shadowOffset = CGSize(width: -1, height: 1)
        gradient.shadowRadius = 5
        gradient.shadowOpacity = 0.15
        gradient.shadowColor  = #colorLiteral(red: 0.151953131, green: 0.151953131, blue: 0.151953131, alpha: 0.7030330882).cgColor

        bgView.layer.insertSublayer(gradient, at: 0)
        self.bgView.layoutIfNeeded()
    }
    
    //Round perticular corner.
    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        planCardView.layer.cornerRadius = radius
        planCardView.layer.maskedCorners = [CACornerMask]
    }
}

