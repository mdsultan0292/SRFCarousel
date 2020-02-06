//
//  SRFCarouselVC.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Mohd Sultan on 07/01/20.
//  Copyright © 2020 Mohd Sultan. All rights reserved.
//

import UIKit

class SRFCarouselVC: UIViewController {

   
    
    @IBOutlet weak var bgView: UIView!
    
    var flowLayout = SRFCarouselFlowLayout()

    var collectionLayouts = SRFCarouselCollectionView()
    
    var selectedIndex = IndexPath(item: 0, section: 0)
    
    var numberOfItems = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        collectionLayouts = SRFCarouselCollectionView.init()

        collectionLayouts.carouselCollectionView.delegate = self
        collectionLayouts.carouselCollectionView.dataSource = self
        collectionLayouts.carouselCollectionView.register(UINib(nibName: "SRFCarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SRFCarouselCollectionViewCell")
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        collectionLayouts.frame = CGRect(x: 0, y: 0, width: bgView.frame.width, height: 300)
        
        self.bgView.addSubview(collectionLayouts)
        itemSizeAndCounts()
    }
    
    @IBAction func singleItemBtnTap(_ sender: UIButton) {
        numberOfItems = 1
        itemSizeAndCounts()
    }
    
    @IBAction func doubleItemBtnTap(_ sender: UIButton) {
        numberOfItems = 2

        itemSizeAndCounts()
        
    }
    
    @IBAction func multipleItemBtnTap(_ sender: UIButton) {
        numberOfItems = 10
        itemSizeAndCounts()
    }
    
    @IBAction func withSpaceItemTap(_ sender: UIButton) {
        numberOfItems = 10
        selectedIndex = IndexPath(item: 0, section: 0)
        flowLayout = SRFCarouselFlowLayout(itemSize: CGSize(width: (bgView.bounds.width/2 + 20), height: (bgView.bounds.width/2)-10), minimumLineSpacing: 45, minimumInteritemSpacing: 0, activeDistance: 200, zoomFactor: 0.3)
        collectionLayouts.carouselCollectionView.collectionViewLayout = flowLayout
        collectionLayouts.carouselCollectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: true)
        
        collectionLayouts.carouselCollectionView.reloadData()

    }
    private func itemSizeAndCounts(){
        
        if numberOfItems == 0{
            return
        }
        selectedIndex = IndexPath(item: 0, section: 0)

        var itemWidth:CGFloat = 0.0
        switch numberOfItems {
        case 1:
            itemWidth = (bgView.bounds.width - 100)
            collectionLayouts.carouselCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        case 2:
            itemWidth = (bgView.bounds.width/2 - 20)

        default:
            itemWidth = (bgView.bounds.width/3 - 15)

        }
        flowLayout = SRFCarouselFlowLayout(itemSize: CGSize(width: itemWidth, height: (bgView.bounds.width/3)+20), minimumLineSpacing: 0, minimumInteritemSpacing: 0, activeDistance: 200, zoomFactor: 0.3)
        collectionLayouts.carouselCollectionView.collectionViewLayout = flowLayout
        collectionLayouts.carouselCollectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: true)

        collectionLayouts.carouselCollectionView.reloadData()
    }
}

extension SRFCarouselVC:UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SRFCarouselCollectionViewCell", for: indexPath) as! SRFCarouselCollectionViewCell
        cell.centreLabel.text = "\(indexPath.item)"
        if selectedIndex == indexPath{
            cell.setupCellLayouts(true)
        }else{
            cell.setupCellLayouts(false)
        }
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex != indexPath{
            self.selectedIndex = indexPath
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
        }
    }
    
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.scrollViewDidEndScrolling(scrollView)
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.scrollViewDidEndScrolling(scrollView)
            }
        }
    }
    
    func scrollViewDidEndScrolling(_ scrollView: UIScrollView) {
        

        let centerPoint = CGPoint(x: bgView.bounds.midX, y: bgView.bounds.midY)
        let collectionViewCenterPoint = self.bgView.convert(centerPoint, to: collectionLayouts.carouselCollectionView)
        guard let centerIndexPath = collectionLayouts.carouselCollectionView.indexPathForItem(at: collectionViewCenterPoint) else{return}
        
        if let _ = collectionLayouts.carouselCollectionView.cellForItem(at: centerIndexPath) as? SRFCarouselCollectionViewCell{
            if self.selectedIndex != centerIndexPath{
                self.selectedIndex = centerIndexPath
                collectionLayouts.carouselCollectionView.reloadData()
            }
        }
    }
}
