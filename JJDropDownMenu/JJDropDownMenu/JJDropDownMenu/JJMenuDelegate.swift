//
//  JJMenuDelegate.swift
//  JJDropDownMenu
//
//  Created by 文伟佳 on 2020/4/10.
//  Copyright © 2020 PCI.DATA. All rights reserved.
//

import Foundation

protocol JJMenuDelegate: class {
    
    /// 设置菜单栏每个cell的高度
    /// - Parameters:
    ///   - menu: 菜单栏
    ///   - indexPath: 位置
    func menu(_ menu: JJDropDownMenu, heightForRowAtIndexPath indexPath: JJDropDownMenu.Index) -> Float
    
    
    /// 点击菜单栏下的内容
    /// - Parameters:
    ///   - menu: 菜单栏
    ///   - indexPath: 位置
    func menu(_ menu: JJDropDownMenu, didSelectRowAtIndexPath indexPath: JJDropDownMenu.Index) -> Void

}

