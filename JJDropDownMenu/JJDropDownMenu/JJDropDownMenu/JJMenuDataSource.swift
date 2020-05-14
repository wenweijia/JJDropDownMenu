//
//  JJMenuDataSource.swift
//  JJDropDownMenu
//
//  Created by 文伟佳 on 2020/4/10.
//  Copyright © 2020 PCI.DATA. All rights reserved.
//

import UIKit

protocol JJMenuDataSource: class {
    // required
    /// 有多少列，默认为1列
      func numberOfColumnsInMenu(_ menu: JJDropDownMenu) -> Int
    
    ///每列有多少行
    func menu(_ menu: JJDropDownMenu, numberOfRowsInColumn column: Int) -> Int
    
    ///每列中的每行的title
    func menu(_ menu: JJDropDownMenu, titleForRowAtIndexPath indexPath: JJDropDownMenu.Index) -> String
    
    // optional
    // MARK: - 一级菜单
    /// 每一行的视图
    func menu(_ menu: JJDropDownMenu, viewForRowAtIndexPath indexPath: JJDropDownMenu.Index) -> UIView?
    
    /// 某列的某行item的数量，如果有，则说明有二级菜单，反之亦然
    func menu(_ menu: JJDropDownMenu, numberOfItemsInRow row: Int, inColumn column: Int) -> Int
    
    // MARK: - 二级菜单
    /// 二级菜单的标题
    func menu(_ menu: JJDropDownMenu, titleForItemsInRowAtIndexPath indexPath: JJDropDownMenu.Index) -> String
}

extension JJMenuDataSource {
    
    /// 有多少个section，默认为1列
    func numberOfsectionsInMenu(_ menu: JJDropDownMenu) -> Int {
        return 1
    }
    
//    // MARK: - 一级菜单
//    /// 每列中的每行的title
//    func menu(_ menu: JJDropDownMenu, titleForRowAtIndexPath indexPath: JJDropDownMenu.Index) -> String? {
//        return ""
//    }
    
    /// 每一行的视图
    func menu(_ menu: JJDropDownMenu, viewForRowAtIndexPath indexPath: JJDropDownMenu.Index) -> UIView? {
        return nil
    }

    
    // MARK: - 二级菜单
    /// 二级菜单的标题
    func menu(_ menu: JJDropDownMenu, titleForItemsInRowAtIndexPath indexPath: JJDropDownMenu.Index) -> String {
        return ""
    }

}
