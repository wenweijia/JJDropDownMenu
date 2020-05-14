//
//  CustomTableViewCell.swift
//  JJDropDownMenu
//
//  Created by 文伟佳 on 2020/4/12.
//  Copyright © 2020 PCI.DATA. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubview(titleLabel)
        titleLabel.frame = self.frame
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.highlightedTextColor = .orange
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
