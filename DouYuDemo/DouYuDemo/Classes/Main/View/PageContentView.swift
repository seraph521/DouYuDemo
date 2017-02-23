//
//  PageContentView.swift
//  DouYuDemo
//
//  Created by LT-MacbookPro on 17/2/23.
//  Copyright © 2017年 XFX. All rights reserved.
//

import UIKit


class PageContentView: UIView {

     var childVcs : [UIViewController]
     var parent : UIViewController
    
    // MARK:- 懒加载
    lazy var collectionView : UICollectionView = {
    
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        
        return collectionView
    
    }()
    
    init(frame: CGRect,childVcs : [UIViewController],parentVc : UIViewController) {
        
        self.childVcs = childVcs
        self.parent = parentVc
        
        super.init(frame: frame)
        // MARK:- 设置UI
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageContentView{

    func setupUI(){
    
        // 将控制器添加到父控制器中
        for childVc in childVcs{
         parent.addChildViewController(childVc)
        }
        
    }

}
