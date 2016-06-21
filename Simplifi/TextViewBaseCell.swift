//
//  TextViewBaseCell.swift
//  Simplifi
//
//  Created by Jared on 5/22/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit
import SnapKit

protocol TextViewBaseCellTableView {
    func textViewTextDidChange(sender: TextViewBaseCell) -> Void
}

class TextViewBaseCell: UITableViewCell, UITextViewDelegate {
    
    let informationEnterTextView = UITextView()
    
    private var placeholder = String()
    
    var delegate: TextViewBaseCellTableView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.informationEnterTextView.font = UIFont(name: "HelveticaNeue", size: 17.0)
        self.informationEnterTextView.delegate = self
        self.informationEnterTextView.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(informationEnterTextView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        informationEnterTextView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(5)
            make.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
        }
        delegate?.textViewTextDidChange(self)
        textView.resignFirstResponder()
    }
    
    func configureWithInstructions(instructions: String, andAnswer answer: String) {
        if answer != "" {
            self.informationEnterTextView.text = answer
        }
        self.informationEnterTextView.text = instructions
        self.placeholder = instructions
    }

}
