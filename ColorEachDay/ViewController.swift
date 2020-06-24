//
//  ViewController.swift
//  ColorEachDay
//
//  Created by Kent Mei on 6/9/20.
//  Copyright © 2020 Kent Mei. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    
    @IBOutlet var calendarView: JTACMonthView!
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCalendarView()
    
    }
    
    func setupCalendarView() {
        calendarView.scrollDirection = .vertical
        calendarView.scrollingMode = .none
        calendarView.showsVerticalScrollIndicator = false
        
        calendarView.cellSize = CGFloat(Double(self.view.frame.size.width)/6);
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell else { return }
        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            //cell.selectedView.layer.cornerRadius = 13
            //cell.selectedView.backgroundColor = UIColor.blue
            //cell.selectedView.isHidden = false
            if (cellState.dateBelongsTo == .thisMonth) {
                transitionToColorPickerViewController();
            }
        } else {
            cell.selectedView.isHidden = true;
        }
    }
    
    func transitionToColorPickerViewController() {
        let colorPickerViewController = self.storyboard?.instantiateViewController(identifier: "ColorPickerViewController") as! ColorPickerViewController
        self.navigationController?.pushViewController(colorPickerViewController, animated: true)
    }

}

extension ViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2020 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: .forAllMonths, generateOutDates: .off)
    }
}

extension ViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        
        formatter.dateFormat = "MMMM y"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
        
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 90)
    }
    
    
    
}

