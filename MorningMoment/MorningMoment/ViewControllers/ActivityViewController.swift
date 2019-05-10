//
//  ActivityViewController.swift
//  MorningMoment
//
//  Created by Thea Birk Berger on 5/1/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import UIKit
import Charts

protocol ActivityViewControllerDelegate: class {
    func ActivityViewControllerDidBack();
}


class ActivityViewController: UIViewController {
    
    // CLASS PROPERTIES
    weak var delegate: ActivityViewControllerDelegate?
    var CDJournal: [CDJournalPage]!
    @IBOutlet weak var barChartView: BarChartView!
    let calendar = Calendar.current
    let all_months_name_string = ["None", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let all_months_int_string = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    let month_duration = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 30]
    let dateFormatter = DateFormatter();
    var todays_month: Int!
    
    // data for graph showing activity as a function months
    var x_months: [Int]! = []
    var x_months_names: [String]! = []
    var y_months_activity: [Double] = []
    var y_months_frequency: [Int] = []
    
    // data for graph showing activity as a function years
    var x_years: [String] = []
    var y_years_frequency: [Int]! = []
    var y_years_activity: [Double]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let today_date = Date();
        let todays_date = today_date as NSDate
        let todays_date_string = dateFormatter.string(from: todays_date as Date);
        todays_month = Int(String(Array(todays_date_string)[0...1])) ?? 0
        
        setBarChartData()
        
        for i in 0..<x_months.count {
            x_months_names.append(all_months_name_string[x_months[i]])
        }
        
        setBarChart(x_values: x_months_names, y_values: y_months_activity)
        
    }
    
    func setBarChartData() {
        
        for index in 0..<(CDJournal.count) {
            
            let journal_page = CDJournal[index]
            let page_date_string: String! = journal_page.date_string ?? "00/00/0000"
            let page_month = Int(String(Array(page_date_string)[0...1])) ?? 0
            let page_year = Int(String(Array(page_date_string)[6...9])) ?? 0
            
            
            if (x_months.count == 0 || page_month != x_months.last) {
                

                let last_month = x_months.last ?? page_month
                var loop_iterations = 0
                
                if (page_month < last_month) {
                    loop_iterations = (12 - last_month + page_month - 1)
                } else if (last_month < page_month) {
                    loop_iterations = page_month - last_month - 1
                }
                
                for i in 1..<(loop_iterations + 1) {
                    x_months.append((last_month + i) % 12)
                    y_months_frequency.append(0)
                    y_months_activity.append(0.0)
                }
                x_months.append(page_month)
                y_months_frequency.append(0)
                y_months_activity.append(0.0)
            }
           
            y_months_frequency[y_months_frequency.count - 1] += 1
            
            var days_in_month = 0
            if (page_month == 2 && isLeapYear(page_year)) {
                days_in_month = 29
            } else if (page_month == todays_month) {
                days_in_month = Int(String(Array(page_date_string)[3...4])) ?? 0
            } else {
                days_in_month = month_duration[page_month]
            }
            
            let current_frequency = Double(y_months_frequency.last ?? 0)
            y_months_activity[y_months_activity.count - 1] = (current_frequency/(Double(days_in_month)) * 100.0)
           
        }
    }
    
  
    func isLeapYear(_ year: Int) -> Bool {
        
        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
        return isLeapYear
    }
    
    
    func setBarChart(x_values: [String], y_values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        let start_index = max(y_values.count - 12, 0)
        
        for i in start_index..<y_values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: y_values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        chartDataSet.setColor(NSUIColor(displayP3Red: 252/255.0, green: 129/255.0, blue: 144/255.0, alpha: 1))
        
        let chartData = BarChartData(dataSet: chartDataSet)
        let valueFormatter = NumberFormatter()
        valueFormatter.numberStyle = .percent
        valueFormatter.maximumFractionDigits = 1
        valueFormatter.multiplier = 1.0
        valueFormatter.percentSymbol = "%"
        valueFormatter.zeroSymbol = ""
        chartData.setValueFormatter(DefaultValueFormatter(formatter: valueFormatter))
        chartData.setValueFont(NSUIFont(name: "SinhalaSangamMN", size: 15)!)
        chartData.setValueTextColor(NSUIColor(displayP3Red: 252/255.0, green: 129/255.0, blue: 144/255.0, alpha: 1))
        
        // set shart layout
        barChartView.data = chartData
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 100
        barChartView.drawBordersEnabled = true
        barChartView.borderColor =  UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1);
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.drawValueAboveBarEnabled = true
        barChartView.legend.enabled = false
        barChartView.drawValueAboveBarEnabled = true
        barChartView.xAxis.axisMinimum = -0.5
        barChartView.xAxis.axisMaximum = Double(x_values.count) - 0.5
        barChartView.xAxis.labelCount = x_values.count
        barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: Array(x_values[start_index...(x_values.count-1)]))
        barChartView.xAxis.labelRotationAngle = -45
        barChartView.xAxis.labelFont = UIFont(name: "SinhalaSangamMN", size: 15)!
        barChartView.xAxis.labelTextColor = UIColor.init(red: 47/255.0, green: 113/255.0, blue: 118/255.0, alpha: 1);
        barChartView.leftAxis.labelFont = UIFont(name: "SinhalaSangamMN", size: 15)!
        barChartView.leftAxis.labelTextColor = UIColor.init(red: 47/255.0, green: 113/255.0, blue: 118/255.0, alpha: 1);
        barChartView.notifyDataSetChanged()
       
    }
    
    
    @IBAction func backButtonClicked (sender: Any) {
        
        // ensure to not rerun viewDidLoad upon return to ViewController
        self.dismiss(animated: true, completion: self.delegate?.ActivityViewControllerDidBack);
        
    }

    
    func daysInMonth(start_in: String, end_in: String) -> Int {
        
        let start_date: Date! = dateFormatter.date(from: start_in)
        let end_date: Date! = dateFormatter.date(from: end_in)
        
        let diff: Int! = Date.daysBetween(start: start_date, end: end_date)
        
        return (diff - 1)
        
    }
    
}

extension Date {
    
    func daysBetween(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
}
