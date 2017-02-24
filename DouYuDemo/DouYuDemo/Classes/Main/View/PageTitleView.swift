//
//  PageTitleView.swift
//  DouYuDemo
//
//  Created by LT-MacbookPro on 17/2/23.
//  Copyright © 2017年 XFX. All rights reserved.
//

import UIKit

// MARK:- 定义常量
private let kTitleViewLineH : CGFloat = 3
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectedColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)

// MARK:- 定义协议
protocol PageTitleViewDelegate : class {
    func pageTitleView (titleView : PageTitleView, selectedIndex index : Int)
}

class PageTitleView: UIView {

    var currentIndex : Int = 0
    weak var delegate : PageTitleViewDelegate?
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
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            // 3 设置label的Frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            // 4 添加label
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //添加手势识别
            label.isUserInteractionEnabled = true
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)) )
            label.addGestureRecognizer(tapGes)
        }
    
    
    }

    
    private func setupBottomLine(){
    
        let line = UIView()
        let lineH : CGFloat = 0.5
        line.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(line)
        
        //
        guard let firstLabel = titleLabels.first else{ return }
        firstLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - lineH, width: firstLabel.frame.width, height: lineH)
    }

}

// MARK:- 手势监听
extension PageTitleView{

    @objc func titleLabelClick(tapGes : UITapGestureRecognizer){
    
        //获取当前Label
        guard  let currentLabel = tapGes.view as? UILabel else {return}
        
        //获取旧Label
        let oldlabel = titleLabels[currentIndex]
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        oldlabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        //更新Index
        currentIndex = currentLabel.tag
        //更新线位置
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        //通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

// MARK:- 对外暴露方法
extension PageTitleView{

    func setTitleWithProgress(progress: CGFloat,targetIndex : Int,sourceIndex : Int){
    
        //
        let sourceLabel  = titleLabels[sourceIndex]
        let targetlabel = titleLabels[targetIndex]
        
        //
        let moveX = (targetlabel.frame.origin.x - sourceLabel.frame.origin.x) * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        //颜色渐变
        let colorDelta = (kSelectedColor.0 - kNormalColor.0,kSelectedColor.1 - kNormalColor.1,kSelectedColor.2 - kNormalColor.2)
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDelta.0 * progress, g: kSelectedColor.1 - colorDelta.1 * progress, b: kSelectedColor.2 - colorDelta.2 * progress)
        targetlabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        //
        currentIndex = targetIndex
    }
    
}





