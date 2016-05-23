//
//  InformationEnterBaseCell.swift
//  Simplifi
//
//  Created by Jared on 5/20/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit
import SnapKit

protocol InformationTableViewCellTableView {
    func informationTextDidChange(sender: InformationEnterBaseCell) -> Void
    func informationTextFieldReturn() -> Void
}

class InformationEnterBaseCell: UITableViewCell, UITextFieldDelegate {
    
    let textfield = UITextField()
    
    var delegate: InformationTableViewCellTableView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.contentView.addSubview(textfield)
        textfield.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textfield.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-10)
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }
    
    func configureWithInstructions(instructions: String, andAnswer answer: String) {
        if answer != "" {
            textfield.text = answer
        } else {
            textfield.placeholder = instructions
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.informationTextDidChange(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate?.informationTextFieldReturn()
        return true
    }

}
