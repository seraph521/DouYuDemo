//
//  PageContentView.swift
//  DouYuDemo
//
//  Created by LT-MacbookPro on 17/2/23.
//  Copyright © 2017年 XFX. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class{
    func pageContentView(pageContentView : PageContentView, progress : CGFloat,targetindex : Int,sourceIndex : Int)
}

private let contentCellID = "contentCellID"

class PageContentView: UIView {

     weak var delegate : PageContentViewDelegate?
     var startOffSetX : CGFloat = 0
     var childVcs : [UIViewController]
     weak var parent : UIViewController?
     var isForbidScrollDelegate : Bool = false
    // MARK:- 懒加载
    lazy var collectionView : UICollectionView = { [weak self] in
    
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)
        return collectionView
    }()
    
    init(frame: CGRect,childVcs : [UIViewController],parentVc : UIViewController?) {
        
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
         parent?.addChildViewController(childVc)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
    }

}
// MARK:- 遵守CollectionView DataSouce协议
extension PageContentView : UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        //cell设置内容
        
        for view in cell.contentView.subviews{
        
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }

}
// MARK:- 对外暴露的方法
extension PageContentView{

   public func setCurrentIndex(currentIndex : Int){
   
    isForbidScrollDelegate = true
    //计算偏移量
    let offSetX = CGFloat(currentIndex) * collectionView.frame.width
    collectionView.setContentOffset(CGPoint(x:offSetX,y:0), animated: false)
    }
}
// MARK:- 遵守UIcollectionView Delegate
extension PageContentView : UICollectionViewDelegate{

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffSetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScrollDelegate {return}
        //定义需要获取的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //判断左右滑
        let currentOffSetX : CGFloat = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffSetX>startOffSetX{//左滑动
            
            progress = currentOffSetX / scrollViewW - floor(currentOffSetX / scrollViewW)
            sourceIndex = Int(currentOffSetX / scrollViewW)
            targetIndex = sourceIndex + 1
            if targetIndex>=childVcs.count{
            
                targetIndex = childVcs.count - 1
            }
            
            if currentOffSetX - startOffSetX == scrollViewW{
            
                progress = 1
                targetIndex = sourceIndex
            }
        
        }else{//右滑动
            
            progress = 1 - (currentOffSetX / scrollViewW - floor(currentOffSetX / scrollViewW))
            targetIndex = Int(currentOffSetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex>=childVcs.count{
                
                sourceIndex = childVcs.count - 1
            }
        }
        // 代理传递参数
        delegate?.pageContentView(pageContentView: self, progress: progress, targetindex: targetIndex, sourceIndex: sourceIndex)
    }
}





