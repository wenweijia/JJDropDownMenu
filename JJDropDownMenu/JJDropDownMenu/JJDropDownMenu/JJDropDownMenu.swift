//
//  JJDropDownMenu.swift
//  JJDropDownMenu
//
//  Created by 文伟佳 on 2020/4/9.
//  Copyright © 2020 PCI.DATA. All rights reserved.
//

import UIKit

private let kScreenWidth = UIScreen.main.bounds.width
private let kScreenHeight = UIScreen.main.bounds.height
private let kScreenScale = UIScreen.main.scale
private let kBottomHeight = CGFloat(UIApplication.shared.statusBarFrame.size.height > 20 ? 34 : 0)
private let kAnimationDuration = 0.5

class JJDropDownMenu: UIView {

    /// 用于描述菜单中的下标
    public struct Index {
        /// 列
        var column: Int
        /// 行
        var row: Int
        /// 行的子行
        var item: Int
        /// 是否有item
        var haveItem:Bool {
            return item != -1
        }
        
        init(column: Int, row: Int, item: Int = -1) {
            self.column = column
            self.row = row
            self.item = item
        }
    }
    
    /// 菜单原始高度
    private var menuOrigin: CGPoint
    /// 菜单栏高度
    private var menuHeight: CGFloat
    /// 菜单栏标题颜色
    private var titleColor: UIColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
    /// 菜单栏标题选择颜色
    private var selectTitleColor: UIColor = .orange
    /** cell高度 */
    fileprivate let KTableViewCellH: CGFloat = 45
    /// 一共有多少列
    private var numberOfColumn = 0
    /// 当前选择第几列
    private var currentSelectedColumn = -1
    /// 当前选择第几行
      private var currentSelectedRow = 0
    /// 当前选择的行，子item的数组
    private var currentSelectedRows = [Int]()
    /// 当前视图的高度
    private var currentViewHeight: CGFloat = 0.0
    /** 最大显示数 */
    fileprivate let KMaxCellNum: CGFloat =  8
    /** 标记值 */
    fileprivate let KTitleButTag: Int = 1000
    /// 列表最大高度
    fileprivate var tableViewMaxHeight: CGFloat = 0
    /// 临时按钮
    fileprivate var tempButton = UIButton()
    /// 列表是否打开，默认为否
    fileprivate var isViewOpen: Bool = false
    /// 菜单栏标题数组
    private var titleArray = [String]()
    /// 按钮数组
    fileprivate lazy var buttonArray = [UIButton]()

    weak var delegate: JJMenuDelegate?
    weak var dataSource: JJMenuDataSource?{
        didSet{
            if oldValue === dataSource {
                
                return
            }
            didSetDataSource(ds: dataSource!)
        }
    }
    
    init(frame: CGRect, titleArr: Array<String>) {
        menuHeight = frame.size.height
        menuOrigin = frame.origin
        super.init(frame: frame)
        titleArray = titleArr
        tableViewMaxHeight = KTableViewCellH * KMaxCellNum
        setUI()
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //遮罩视图
    fileprivate lazy var backGroundView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: menuOrigin.y + menuHeight, width: kScreenWidth, height: kScreenHeight)
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        view.isOpaque = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maskBgViewTapClick)))
        return view
    }()
    
    private lazy var leftTableView: UITableView = {
        let view = UITableView(frame: CGRect(x: menuOrigin.x, y: menuOrigin.y + menuHeight, width: kScreenWidth / 2, height: 0))
        view.dataSource = self;
        view.delegate = self;
        view.rowHeight = KTableViewCellH
        view.backgroundColor = UIColor(white: 1.00, alpha: 1)
        return view
    }()
    
    private lazy var rightTableView: UITableView = {
        let view = UITableView(frame: CGRect(x: kScreenWidth / 2, y: menuOrigin.y + menuHeight, width: kScreenWidth / 2, height: 0))
        view.dataSource = self;
        view.delegate = self;
        view.rowHeight = KTableViewCellH
        view.backgroundColor = UIColor(white: 1.00, alpha: 1)
        return view
    }()
    
    private lazy var customView: CustomView = {
        let view = CustomView()
        view.layer.masksToBounds = true
        return view
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// MARK: - 私有方法
extension JJDropDownMenu {
    fileprivate func setUI() {
        addMenuButton()
        setTableView()
    }
    
    func setTableView() {
        leftTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        leftTableView.tableFooterView = UIView()
        rightTableView.tableFooterView = UIView()
    }
    
    private func didSetDataSource(ds: JJMenuDataSource) {
        // 列数
        numberOfColumn = ds.numberOfColumnsInMenu(self)
        // 当前的每列的选择情况
        currentSelectedRows = Array<Int>(repeating: 0, count: numberOfColumn)
    }
    
    fileprivate func addMenuButton() {
        // 添加标题按钮
        let butW: CGFloat = kScreenWidth/CGFloat(titleArray.count)
        for i in 0..<titleArray.count {
            let selectBut = UIButton(type: .custom)
            selectBut.frame = CGRect(x: CGFloat(i) * butW, y: 0, width: butW, height: self.menuHeight)
            selectBut.setTitle(titleArray[i], for: .normal)
            selectBut.setTitleColor(titleColor, for: .normal)
            selectBut.setTitleColor(selectTitleColor, for: .selected)
            selectBut.tag = KTitleButTag + i
            selectBut.addTarget(self, action: #selector(titleButtonClick(titleButton:)), for: .touchUpInside)
            selectBut.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            selectBut.setImage(UIImage(named: "downjiantou"), for: .normal)
            selectBut.setImage(UIImage(named: "shangjiantou"), for: .selected)
            addSubview(selectBut)
            // 添加到数组
            buttonArray.append(selectBut)
        }
    }
    
    func updateButtonMsg(tableView: UITableView, indexPath: IndexPath) {
        //更改标题
        if currentSelectedColumn == 2 {
            tempButton.isSelected = false
            let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            tempButton.setTitle(cell.titleLabel.text, for: .normal)
        }else {
            let cell = tableView.cellForRow(at: indexPath)!
            tempButton.setTitle(cell.textLabel!.text, for: .normal)
            tempButton.isSelected = false
        }
    
    }
}

// MARK: - 事件响应
extension JJDropDownMenu {
    /// 点击标题按钮
    @objc private func titleButtonClick(titleButton: UIButton) {
        guard let ds = dataSource else { return }
        // 获取到当前按钮下标值
        let index = titleButton.tag - KTitleButTag
        for button in buttonArray {
            if button == titleButton {
                button.isSelected = !button.isSelected
                tempButton = button
            }else {
                button.isSelected = false
            }
        }
        
        if index == 3 {
            currentSelectedColumn = index
            // 打开列表
            animateForBackgroundView(show: titleButton.isSelected, complete: {
                animateCustomView(show: titleButton.isSelected, complete: {
                    self.isViewOpen = titleButton.isSelected
                })
            })
            return
        }

        if titleButton.isSelected {
            currentSelectedColumn = index
            // 载入数据
            leftTableView.reloadData()
            
            if ds.menu(self, numberOfItemsInRow: currentSelectedRows[currentSelectedColumn], inColumn: currentSelectedColumn) > 0 || currentSelectedColumn == 1{
                currentSelectedRow = currentSelectedRows[currentSelectedColumn]
                rightTableView.reloadData()
            }
            // 打开列表
            animateForBackgroundView(show: true, complete: {
                animateTableView(show: true, complete: {
                    isViewOpen = true
                })
            })
        }else {
           // 收起列表
           animateForBackgroundView(show: false, complete: {
               animateTableView(show: false, complete: {
                   isViewOpen = false
               })
           })
        }
    }
    
    /// 点击蒙版,收起列表
    @objc private func maskBgViewTapClick() {
        tempButton.isSelected = false
        animateForBackgroundView(show: false, complete: {
            animateTableView(show: false, complete: {
                isViewOpen = false
            })
        })
    }
}

// MARK: - UITableViewDataSource / Delegate
extension JJDropDownMenu: UITableViewDataSource, UITableViewDelegate {
    //每一组的个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            if let ds = dataSource {
                return ds.menu(self, numberOfRowsInColumn: currentSelectedColumn)
            }
        }else {
            if let ds = dataSource {
//               let currentSelectedRow = currentSelectedRows[currentSelectedColumn]
                return ds.menu(self, numberOfItemsInRow: currentSelectedRow, inColumn: currentSelectedColumn)
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentSelectedColumn == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            if let ds = dataSource {
                cell.titleLabel.text = ds.menu(self, titleForRowAtIndexPath: Index(column: currentSelectedColumn, row: indexPath.row))
                // 选中上次选择的行
                if currentSelectedRows[currentSelectedColumn] == indexPath.row {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
            }
            return cell
        }else {
            let cellID = "cellID"
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellID)
            
            if cell == nil  {
                cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
                cell.textLabel?.textColor = titleColor
                cell.textLabel?.highlightedTextColor = selectTitleColor
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
                cell.selectedBackgroundView = UIView(frame: frame)
                cell.selectedBackgroundView?.backgroundColor = .white
            }
            
            if tableView == leftTableView {
                // 一级列表
                if let ds = dataSource {
                    cell.textLabel?.text = ds.menu(self, titleForRowAtIndexPath: Index(column: currentSelectedColumn, row: indexPath.row))
                    
                    // 选中上次选择的行
                    if currentSelectedRows[currentSelectedColumn] == indexPath.row {
                        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    }
                    //                let haveItems = ds.menu(self, numberOfItemsInRow: indexPath.row, inColumn: currentSelectedColumn) > 0
                    
                    cell.backgroundColor = currentSelectedColumn == 1 ? UIColor(white: 0.95, alpha: 1) : .white
                }
            }else {
                // 二级列表
                if let ds = dataSource {
                    //                let currentSelectedRow = currentSelectedRows[currentSelectedColumn]
                    cell.textLabel?.text = ds.menu(self, titleForItemsInRowAtIndexPath: Index(column: currentSelectedColumn, row: currentSelectedRow, item: indexPath.row))
                    // 选中上次选择的行
                    if cell.textLabel?.text == buttonArray[currentSelectedColumn].titleLabel?.text {
                        leftTableView.selectRow(at: IndexPath(row: currentSelectedRow, section: 0), animated: true, scrollPosition: .middle)
                        rightTableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                    }
                }
                cell.backgroundColor = .white
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let ds = dataSource else { return }
        
        if tableView == leftTableView {
            // 一级列表
            let haveItems = ds.menu(self, numberOfItemsInRow: indexPath.row, inColumn: currentSelectedColumn) > 0
            if haveItems {
                currentSelectedRow = indexPath.row
                rightTableView.reloadData()
            }else {
                currentSelectedRows[currentSelectedColumn] = indexPath.row
//                //更改标题
                updateButtonMsg(tableView: tableView, indexPath: indexPath)
                // 收回列表
                animateForBackgroundView(show: false, complete: {
                    animateTableView(show: false, complete: {
                        isViewOpen = false
                    })
                })
                
                delegate?.menu(self, didSelectRowAtIndexPath: Index(column: currentSelectedColumn, row: indexPath.row))
                
            }
                        
        }else {
            currentSelectedRows[currentSelectedColumn] = currentSelectedRow
            //更改标题
            updateButtonMsg(tableView: tableView, indexPath: indexPath)
            // 收回列表
            animateForBackgroundView(show: false, complete: {
                animateTableView(show: false, complete: {
                    isViewOpen = false
                })
            })
            
            delegate?.menu(self, didSelectRowAtIndexPath: Index(column: currentSelectedColumn, row: currentSelectedRows[currentSelectedColumn], item: indexPath.row))
        }
        
    }
}

// MARK: - Animation
private extension JJDropDownMenu {
    /// backgroundView动画
    func animateForBackgroundView(show: Bool, complete: () -> Void) -> Void {
        if show {
            superview?.addSubview(backGroundView)
            superview?.addSubview(self)
            UIView.animate(withDuration: kAnimationDuration, animations: {
                self.backGroundView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            })
        }else {
            UIView.animate(withDuration: kAnimationDuration, animations: {
                self.backGroundView.backgroundColor = UIColor(white: 0, alpha: 0)
            }, completion: { (finished) in
                if finished {
                    self.backGroundView.removeFromSuperview()
                }
            })
        }
        
        complete()
    }
    
    /// tableView动画
    func animateTableView(show: Bool, complete: () -> Void) -> Void {
        
        var haveItems = false
        let numberOfRow = leftTableView.numberOfRows(inSection: 0)
        if let ds = dataSource {
            for i in 0 ..< numberOfRow {
                if ds.menu(self, numberOfItemsInRow: i, inColumn: currentSelectedColumn) > 0 {
                    haveItems = true
                    break
                }
            }
        }
        
        let heightForTableView = CGFloat(numberOfRow) * KTableViewCellH > tableViewMaxHeight ? tableViewMaxHeight : CGFloat(numberOfRow) * KTableViewCellH;
        
        if show {
            if haveItems {
                leftTableView.frame = CGRect(x: 0, y: menuOrigin.y + menuHeight, width: kScreenWidth / 2, height: 0)
                rightTableView.frame = CGRect(x: kScreenWidth / 2, y: menuOrigin.y + menuHeight, width: kScreenWidth / 2, height: 0)
                
                superview?.addSubview(leftTableView)
                superview?.addSubview(rightTableView)

            }else {
                rightTableView.removeFromSuperview()
                leftTableView.frame = CGRect(x: 0, y: menuOrigin.y + menuHeight, width: kScreenWidth, height: 0)
                superview?.addSubview(leftTableView)
            }
            
            self.leftTableView.frame.size.height = currentViewHeight
            if haveItems {
                self.rightTableView.frame.size.height = currentViewHeight
            }
            UIView.animate(withDuration: kAnimationDuration) {
                self.leftTableView.frame.size.height = heightForTableView
                self.currentViewHeight = heightForTableView
                if haveItems {
                    self.rightTableView.frame.size.height = heightForTableView
                }
            }
        }else {
            currentViewHeight = 0
            UIView.animate(withDuration: kAnimationDuration, animations: {
                self.leftTableView.frame.size.height = 0
                if haveItems {
                    self.rightTableView.frame.size.height = 0
                }
            }, completion: { (finished) in
                self.leftTableView.removeFromSuperview()
                if haveItems {
                    self.rightTableView.removeFromSuperview()
                }
            })
        }
        
        complete()
    }
    
    /// tableView动画
    func animateCustomView(show: Bool, complete: () -> Void) -> Void {
        if show {
            customView.frame = CGRect(x: 0, y: menuOrigin.y + menuHeight, width: kScreenWidth, height: 0)
            superview?.addSubview(customView)
            UIView.animate(withDuration: kAnimationDuration) {
                self.customView.frame.size.height = 300
            }
        }else {
            UIView.animate(withDuration: kAnimationDuration, animations: {
                self.customView.frame.size.height = 0
            }, completion: { (finished) in
                self.customView.removeFromSuperview()
            })
        }
    }
}
