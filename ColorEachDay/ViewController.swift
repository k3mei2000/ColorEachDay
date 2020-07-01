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
    let dayFormatter = DateFormatter()
    let headerFormatter = DateFormatter()
    var container: NSPersistentContainer!
    var currentDate: Date?
    var currentColorString: String?
    var dateColorPairs: [String:String] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        container = NSPersistentContainer(name: "ColorEachDay")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        //clearColors()
        //fetchColors()
        setupCalendarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchColors()
    }
    
    func clearColors() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
           
           
        let managedContext = appDelegate.persistentContainer.viewContext
           
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DateColor")
           
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
           
        do {
            try managedContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
           
    }
    
    func fetchColors() {
        
        dayFormatter.dateFormat = "yyyy MM dd"
        
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
            let dateColors = try managedContext.fetch(fetchRequest)
            for dateColor in dateColors {
                dateColorPairs.updateValue(dateColor.value(forKeyPath: "color") as! String, forKey: dayFormatter.string(from: (dateColor.value(forKeyPath: "date") as? Date)!))
                //print(dateColor.value(forKeyPath: "color"))
                //print(dayFormatter.string(from: (dateColor.value(forKeyPath: "date") as? Date)!))
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
           
        print(dateColorPairs)
        calendarView.reloadData()
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
        let dateString = dayFormatter.string(from: cellState.date)
        //print("Cell BG: " + dayFormatter.string(from: cellState.date))
        
        if dateColorPairs.contains(where: { $0.key == dateString }) {
            //print("!!! Not Nil " + dateString)
            let colorString = dateColorPairs[dateString]!
            cell.backgroundColor = UIColor(hexString: colorString)
            cell.contentView.viewWithTag(3)?.backgroundColor = UIColor(hexString: colorString)
        } else {
            cell.backgroundColor = UIColor.white
            cell.contentView.viewWithTag(3)?.backgroundColor = UIColor.white
        }
         
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            calendarView.deselectAllDates()
            if (cellState.dateBelongsTo == .thisMonth) {
                currentDate = cellState.date
                currentColorString = cell.backgroundColor?.toHexString()
                performSegue(withIdentifier: "InputColor", sender: nil)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextVC = segue.destination as? ColorPickerViewController {
            nextVC.date = currentDate
            nextVC.colorString = currentColorString
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
        dayFormatter.dateFormat = "yyyy MM dd"
        let startDate = dayFormatter.date(from: "2020 01 01")!
        let endDate = dayFormatter.date(from: "2020 12 01")!
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
        
        headerFormatter.dateFormat = "MMMM y"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = headerFormatter.string(from: range.start)
        return header
        
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 90)
    }
    
    
    
}

