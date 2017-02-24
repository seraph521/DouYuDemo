//
//  HomeViewController.swift
//  DouYuDemo
//
//  Created by LT-MacbookPro on 17/2/23.
//  Copyright © 2017年 XFX. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    // MARK:- 懒加载PageTitleView
        lazy  var pageTitleView : PageTitleView = { [weak self] in
    
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
            titleView.delegate = self
        return titleView
    }()
    
    // MARK:- 懒加载PageContentView
    lazy var pageContentView : PageContentView = { [weak self] in
        // 1 确定内容Frame
        let contentH : CGFloat = kScreenH - (kStatusBarH + kNavigationBarH + kTitleViewH)
        let contentFrame  = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        // 2 确定子控制器
        var childVcs  =  [UIViewController]()
        for _ in 0..<4{
            
         let childVc = UIViewController()
         childVc.view.backgroundColor = UIColor.init(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(childVc)
        }
        
        let contentView : PageContentView  = PageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
        contentView.delegate = self
       
        return contentView
    
    }()
    
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // MARK:- 设置UI界面
        setupUI()
        
    }
    
}

extension HomeViewController{
    
    func setupUI(){
        
            automaticallyAdjustsScrollViewInsets = false
            // MARK:- 设置导航栏
            setupNavigationBar()
        
            // MARK:- 添加PageTitleView
        
            view.addSubview(pageTitleView)
        
           // MARK:- 添加pageContentView
        
           view.addSubview(pageContentView)
        
        
    }
    
    func setupNavigationBar(){
    
        //1 左侧
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // 2 右侧
        let size = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImage: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImage: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImage: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }

}

// MARK:- 实现协议
extension HomeViewController : PageTitleViewDelegate{

    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}
// MARK:- 实现pageContentViewDelegate 代理
extension HomeViewController : PageContentViewDelegate{

    func pageContentView(pageContentView: PageContentView, progress: CGFloat, targetindex: Int, sourceIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, targetIndex: targetindex, sourceIndex: sourceIndex)
    }
}


