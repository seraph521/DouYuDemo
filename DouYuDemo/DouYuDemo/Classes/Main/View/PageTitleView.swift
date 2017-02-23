//
//  PageTitleView.swift
//  DouYuDemo
//
//  Created by LT-MacbookPro on 17/2/23.
//  Copyright © 2017年 XFX. All rights reserved.
//

import UIKit

private let kTitleViewLineH : CGFloat = 2

class PageTitleView: UIView {

    lazy var scrollView : UIScrollView = {
    
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.scrollsToTop = false
        return scrollView
    
    }()
    
    lazy var scrollLine : UIView = {
    
        let scrollLine : UIView = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    
    }()
    // MARK:- 存放所有标题Label数组
    lazy var titleLabels : [UILabel] = [UILabel]()
    
    var titles : [String]
    
    init(frame: CGRect,titles: [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageTitleView{

    func setupUI(){
    
        // MARK:- 添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // MARK:- 添加title对应的Label
        setupTitlelabels()
        
        // MARK:- 添加底部线
        setupBottomLine()
    }
    
    
    private func setupTitlelabels(){
        
        let labelW :CGFloat = bounds.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kTitleViewLineH
        let labelY : CGFloat = 0
        for (index,title) in titles.enumerated(){
        
            // 1 创建UILabel
            let label = UILabel()
            // 2 添加属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            label.textColor = UIColor.darkGray
            // 3 设置label的Frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            // 4 添加label
            scrollView.addSubview(label)
            titleLabels.append(label)
        }
    
    
    }

    
    private func setupBottomLine(){
    
        let line = UIView()
        let lineH : CGFloat = 0.5
        line.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(line)
        
        //
        guard let firstLabel = titleLabels.first else{ return }
        firstLabel.textColor = UIColor.orange
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - lineH, width: firstLabel.frame.width, height: lineH)
    }




}
