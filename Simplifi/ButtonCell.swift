//
//  ButtonCell.swift
//  Simplifi
//
//  Created by Jared on 5/27/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    private var button = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.button.backgroundColor = SimplifiColor()
        self.contentView.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.button.snp_makeConstraints { make in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }
    
    func configureButton(withTarget target: AnyObject, andAction action: Selector, andTitle title: String) {
        self.button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        self.button.setTitle(title, forState: .Normal)
    }

}
