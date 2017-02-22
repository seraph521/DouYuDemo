//
//  MainTabBarController.swift
//  DouYuDemo
//
//  Created by LT-MacbookPro on 17/2/22.
//  Copyright © 2017年 XFX. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVc(storyName: "Home")
        addChildVc(storyName: "Live")
        addChildVc(storyName: "Follow")
        addChildVc(storyName: "Profile")

    }

    private func addChildVc(storyName :String){
    
        //1 通过StoryBoard获取控制器
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        //2 添加子控制器
        addChildViewController(childVC)
    
    }
    
}
