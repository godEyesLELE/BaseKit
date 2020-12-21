//
//  ViewExtention.swift
//  mbc_jrcxpt
//
//  Created by chen on 2020/3/17.
//  Copyright © 2020 MBC. All rights reserved.
//

import UIKit

extension UIView {
    
    public static var parent: MParentView = MParentView()

}

func getNavbarHeight() -> CGFloat {
    let screenHeight = UIScreen.main.nativeBounds.size.height
    if screenHeight == 2436 || screenHeight == 1792 || screenHeight == 2688 || screenHeight == 1624 {
        return 88.0
    }
    return 64.0
}


