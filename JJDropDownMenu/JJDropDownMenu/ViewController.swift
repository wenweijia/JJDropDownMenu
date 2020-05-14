//
//  ViewController.swift
//  JJDropDownMenu
//
//  Created by 文伟佳 on 2020/4/9.
//  Copyright © 2020 PCI.DATA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JJMenuDataSource, JJMenuDelegate {
    
    let titleArray = ["智能排序", "附近", "全部美食", "筛选"]
    let sortArray = ["智能排序", "离我最近", "好评优先", "销量最高"]
    let cityArray = [
        ["name": "全部地区",
                     "distance": []],
        ["name": "越秀区",
                           "distance": ["智能排序1", "离我最近2", ]],
        ["name": "天河区",
                           "distance": ["智能排序20", "离我最近21", "好评优先22", "销量最高23"]],
        ["name": "番禺区",
                           "distance": ["智能排序30", "离我最近31", "好评优先32", "销量最高33","销量最高34"]],
        ["name": "海珠区",
                           "distance": ["智能排序40", "离我最近41", "好评优先42", "销量最高43", "销量最高44","销量最高45"]],
        ["name": "白云区",
                           "distance": ["智能排序51", "离我最近52", "好评优先53", "销量最高54"]],
        ["name": "黄埔区",
                           "distance": ["智能排序61", "离我最近62", "好评优先63", "销量最高64"]],
    ]
    let customArray = ["测试", "开发", "验证", "生产"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let menu = JJDropDownMenu(frame: CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 44.0), titleArr: titleArray)
        menu.delegate = self
        menu.dataSource = self
        view.addSubview(menu)
        // Do any additional setup after loading the view.
    }
    
    //有4列
    func numberOfColumnsInMenu(_ menu: JJDropDownMenu) -> Int {
        return titleArray.count
    }
    
    //每一列有几个
     func menu(_ menu: JJDropDownMenu, numberOfRowsInColumn column: Int) -> Int {
         if column == 1 {
             return cityArray.count
         }else if column == 2 {
             return customArray.count
         }else {
             return sortArray.count
         }
      }
    
    //如果是第2列,则有行数
    func menu(_ menu: JJDropDownMenu, numberOfItemsInRow row: Int, inColumn column: Int) -> Int {
        if column == 1 {
            let itemArr = cityArray[row]["distance"] as! Array<String>
            return itemArr.count
        }
        return 0
    }
     
    //每一行的高度
    func menu(_ menu: JJDropDownMenu, heightForRowAtIndexPath indexPath: JJDropDownMenu.Index) -> Float {
        return 50
    }
    
    //每一行的内容
    func menu(_ menu: JJDropDownMenu, titleForRowAtIndexPath indexPath: JJDropDownMenu.Index) -> String {
        if indexPath.column == 1 {
            return cityArray[indexPath.row]["name"] as! String
        }else if indexPath.column == 2 {
            return customArray[indexPath.row]
        }
        return sortArray[indexPath.row]
    }
    
    /// 二级菜单的标题
    func menu(_ menu: JJDropDownMenu, titleForItemsInRowAtIndexPath indexPath: JJDropDownMenu.Index) -> String {
        if indexPath.column == 1 {
            let itemArr = cityArray[indexPath.row]["distance"] as! Array<String>
            return itemArr[indexPath.item]
        }else {
            return ""
        }
    }
    
    func menu(_ menu: JJDropDownMenu, didSelectRowAtIndexPath indexPath: JJDropDownMenu.Index) {
        print("选中了第\(indexPath.column)列, 一级列表的第\(indexPath.row)行\(indexPath.haveItem ? ", 二级列表的第\(indexPath.item)行" : ", 没有选择二级列表")")
    }
    
}

