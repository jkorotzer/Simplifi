//
//  BaseTableViewController.swift
//  Simplifi
//
//  Created by Jared on 5/20/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func registerCells() {
        assert(false, "Override in subclass")
    }
    
    func displayActivityIndicator(msg:String, _ indicator:Bool ) {
        let bgView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.screenWidth(), height: UIScreen.screenHeight())))
        bgView.backgroundColor = UIColor.clearColor()
        let strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        let messageFrame = UIView(frame: CGRect(x: bgView.frame.midX - 90, y: bgView.frame.midY - 50, width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = SimplifiColor()
        bgView.tag = 100
        if indicator {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        bgView.addSubview(messageFrame)
        view.addSubview(bgView)
    }
    
    func removeActivityIndicator() {
        let activityView = self.view.viewWithTag(100)
        activityView?.removeFromSuperview()
    }

}
