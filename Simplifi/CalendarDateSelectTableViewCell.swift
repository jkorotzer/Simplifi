//
//  CalendarDateSelectTableViewCell.swift
//  Simplifi
//
//  Created by Jared on 5/22/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit
import SnapKit

protocol CalendarCellTableView {
    func nextButtonPressed() -> Void
    func previousButtonPressed() -> Void
}

class CalendarDateSelectTableViewCell: UITableViewCell {
    
    let previousButton = UIButton()
    
    let nextButton = UIButton()
    
    let currentDateLabel = UILabel()
    
    var delegate: CalendarCellTableView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.currentDateLabel.textAlignment = .Center
        self.currentDateLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(20))
        self.nextButton.setTitle(">", forState: .Normal)
        self.previousButton.setTitle("<", forState: .Normal)
        self.nextButton.addTarget(self, action: #selector(CalendarDateSelectTableViewCell.nextButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.previousButton.addTarget(self, action: #selector(CalendarDateSelectTableViewCell.previousButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.nextButton.setTitleColor(SimplifiColor(), forState: .Normal)
        self.previousButton.setTitleColor(SimplifiColor(), forState: .Normal)
        self.contentView.addSubview(previousButton)
        self.contentView.addSubview(nextButton)
        self.contentView.addSubview(currentDateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        currentDateLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.width.equalTo(self.contentView).multipliedBy(0.6)
            make.centerX.equalTo(self.contentView)
        }
        previousButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(self.currentDateLabel.snp_left)
        }
        nextButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.currentDateLabel.snp_right)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
        }
    }
    
    func nextButtonPressed(sender: AnyObject) {
        delegate?.nextButtonPressed()
    }
    
    func previousButtonPressed(sender: AnyObject) {
        delegate?.previousButtonPressed()
    }
    
    func configureCurrentDateLabel(withDate date: NSDate) {
        let dateTuple = SimplifiUtility.tupleFromDate(date)
        let sunday = date.dateByAddingTimeInterval(6 * 24 * 60 * 60)
        let sundayTuple = SimplifiUtility.tupleFromDate(sunday)
        let dateString = "\(dateTuple.1)/\(dateTuple.0)/\(dateTuple.2) - \(sundayTuple.1)/\(sundayTuple.0)/\(sundayTuple.2)"
        self.currentDateLabel.text = dateString
    }

}
