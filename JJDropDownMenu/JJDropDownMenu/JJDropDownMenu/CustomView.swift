//
//  CustomView.swift
//  JJDropDownMenu
//
//  Created by 文伟佳 on 2020/4/12.
//  Copyright © 2020 PCI.DATA. All rights reserved.
//

import UIKit

class CustomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        backgroundColor = .white
        self.addSubview(titleLabel)
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: 300, height: 300)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.highlightedTextColor = .orange
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "自定义视图"
        return label
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
