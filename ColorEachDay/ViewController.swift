//
//  ViewController.swift
//  ColorEachDay
//
//  Created by Kent Mei on 6/9/20.
//  Copyright © 2020 Kent Mei. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var calendarView: JTACMonthView!
    let formatter = DateFormatter()
    var container: NSPersistentContainer!
    var currentDate: Date?
    var dateColorPairs: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        container = NSPersistentContainer(name: "ColorEachDay")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        setupCalendarView()
        //populateDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        /*
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DateColor")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        */
        
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DateColor")
        
        do {
            dateColorPairs = try managedContext.fetch(fetchRequest)
            for dateColor in dateColorPairs {
                //managedContext.delete(dateColor)
                print(dateColor.value(forKeyPath: "date") as? Date)
                print(dateColor.value(forKeyPath: "color") as? String)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        
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
        handleCellBackgroundColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    func handleCellBackgroundColor(cell: DateCell, cellState: CellState) {
        //let dateString =
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            if (cellState.dateBelongsTo == .thisMonth) {
                currentDate = cellState.date
                performSegue(withIdentifier: "InputColor", sender: nil)
            }
        }
    }
    
    /*
    func transitionToColorPickerViewController() {
        let colorPickerViewController = self.storyboard?.instantiateViewController(identifier: "ColorPickerViewController") as! ColorPickerViewController
        self.navigationController?.pushViewController(colorPickerViewController, animated: true)
    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextVC = segue.destination as? ColorPickerViewController {
            nextVC.date = currentDate
        }
    }
    
    /*
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    */
    

}

extension ViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2020 01 01")!
        let endDate = formatter.date(from: "2020 12 01")!
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

