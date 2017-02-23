//
//  UIColor_Extension.swift
//  DouYuDemo
//
//  Created by LT-MacbookPro on 17/2/23.
//  Copyright © 2017年 XFX. All rights reserved.
//

import UIKit

extension UIColor {

  convenience  init(r :CGFloat,g :CGFloat,b :CGFloat){
     
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    
    }

}

