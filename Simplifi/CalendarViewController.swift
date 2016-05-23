//
//  CalendarViewController.swift
//  Simplifi
//
//  Created by Jared on 4/17/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class CalendarViewController: BaseTableViewController, CalendarCellTableView {
    
    var times: [Int] = [0, 0, 0, 0, 0, 0, 0]
    
    var dataHasLoaded = false
    
    var currentDate = NSDate() {
        didSet {
            getTimesForCurrentDate()
        }
    }
    
    private let labelCellIdentifier = "labelCell"
    
    private struct Days {
        static let Monday = "Monday"
        static let Tuesday = "Tuesday"
        static let Wednesday = "Wednesday"
        static let Thursday = "Thursday"
        static let Friday = "Friday"
        static let Saturday = "Saturday"
        static let Sunday = "Sunday"
    }
    
    private let daysToNum = [Days.Monday: 0, Days.Tuesday: 1, Days.Wednesday: 2, Days.Thursday: 3, Days.Friday: 4, Days.Saturday: 5, Days.Sunday: 6]
    private let numToDays = [Days.Monday, Days.Tuesday, Days.Wednesday, Days.Thursday, Days.Friday, Days.Saturday, Days.Sunday]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        let startDate = SimplifiUtility.getDay(.Previous, Days.Monday,considerToday: true)
        currentDate = startDate
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.row == 0 {
            cell = calendarDateCell()
        } else if indexPath.row == 8 {
            cell = totalTimeCell()
        } else  {
            cell = cellForDay(day: numToDays[indexPath.row - 1])
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }
        return UITableViewAutomaticDimension
    }
    
    override func registerCells() {
        self.tableView.registerClass(LabelBaseCell.self, forCellReuseIdentifier: labelCellIdentifier)
    }
    
    func nextButtonPressed() {
        currentDate = currentDate.dateByAddingTimeInterval(7 * 24 * 60 * 60)
    }
    
    func previousButtonPressed() {
        currentDate = currentDate.dateByAddingTimeInterval(-7 * 24 * 60 * 60)
    }
    
    private func calendarDateCell() -> CalendarDateSelectTableViewCell {
        let cell = CalendarDateSelectTableViewCell()
        cell.configureCurrentDateLabel(withDate: currentDate)
        cell.delegate = self
        return cell
    }
    
    private func totalTimeCell() -> LabelBaseCell {
        let cell = LabelBaseCell()
        let seconds = times.reduce(0, combine: +)
        cell.configureForInfo("Total time this week: \(SimplifiUtility.timeStringForSeconds(seconds))")
        return cell
    }
    
    private func cellForDay(day day: String) -> LabelBaseCell {
        let cell = LabelBaseCell()
        let seconds = times[daysToNum[day]!]
        let timeString = SimplifiUtility.timeStringForSeconds(seconds)
        let labelString = "\(day): \(timeString)"
        cell.configureForInfo(labelString)
        return cell
    }
    
    private func getTimesForCurrentDate() {
        self.displayActivityIndicator("Getting times...", true)
        let startTuple = SimplifiUtility.tupleFromDate(currentDate)
        TimesheetService.getTimesForDays(startTuple.0, numDays: 7, month: startTuple.1, year: startTuple.2, completionHandler: { (times) in
            dispatch_async(dispatch_get_main_queue(), {
                self.times = times
                self.removeActivityIndicator()
                self.dataHasLoaded = true
                self.tableView.reloadData()
            })
        }) {
            //implement
        }
    }
    
}
