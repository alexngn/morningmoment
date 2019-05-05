//
//  MoodViewController.swift
//  MorningMoment
//
//  Created by Thea Birk Berger on 5/1/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import UIKit
import Charts

protocol MoodViewControllerDelegate: class {
    
    func MoodViewControllerDidBack();
}


public class MoodViewController: UIViewController {
    
    // CLASS PROPERTIES
    weak var delegate: MoodViewControllerDelegate?
    var CDJournal: [CDJournalPage]!
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        var mood: [Double] = []
        var mood_frequency = Array(repeating: 0.0, count: 9)
        
        // for each journal page: Input mood as y-value and keep track of mood type frequency
        for page_index in 0..<CDJournal.count {
            let journal_page = CDJournal[page_index]
            mood.append(Double(journal_page.mood))
            mood_frequency[Int(journal_page.mood)] += 1
        }
        
        // create line and pie chart
        setLineChart(y_values: mood)
        setPieChart(frequencies: mood_frequency)
    }
    
    
    func setPieChart(frequencies: [Double]) {
        
        // set emoji/mood colors
        let emoji_0_col = UIColor.init(red: 191/255.0, green: 239/255.0, blue: 154/255.0, alpha: 1);
        let emoji_1_col = UIColor.init(red: 172/255.0, green: 211/255.0, blue: 142/255.0, alpha: 1);
        let emoji_2_col = UIColor.init(red: 146/255.0, green: 180/255.0, blue: 119/255.0, alpha: 1);
        let emoji_3_col = UIColor.init(red: 253/255.0, green: 240/255.0, blue: 151/255.0, alpha: 1);
        let emoji_4_col = UIColor.init(red: 250/255.0, green: 222/255.0, blue: 134/255.0, alpha: 1);
        let emoji_5_col = UIColor.init(red: 226/255.0, green: 200/255.0, blue: 120/255.0, alpha: 1);
        let emoji_6_col = UIColor.init(red: 170/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1);
        let emoji_7_col = UIColor.init(red: 147/255.0, green: 174/255.0, blue: 224/255.0, alpha: 1);
        let emoji_8_col = UIColor.init(red: 129/255.0, green: 153/255.0, blue: 198/255.0, alpha: 1);
        
        var dataEntries: [ChartDataEntry] = []
        
        // set data entries: Mood type frequency relative to all input moods in journal
        for i in 0..<frequencies.count {
            
            let dataEntry: ChartDataEntry!
            let mood_freq = frequencies[i]
            var percentage = 100
            
            if (mood_freq > 0 && CDJournal.count > 1) {
                percentage = Int(mood_freq/Double(CDJournal.count - 1) * 100.0)
                dataEntry = PieChartDataEntry(value: mood_freq, label: String(percentage) + "%")
            } else {
                dataEntry = PieChartDataEntry(value: mood_freq, label: "")
            }
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        // set chart layout
        pieChartDataSet.colors = [emoji_8_col, emoji_7_col, emoji_6_col, emoji_5_col, emoji_4_col, emoji_3_col, emoji_2_col, emoji_1_col, emoji_0_col]
        pieChartDataSet.entryLabelColor = UIColor.init(red: 34/255.0, green: 83/255.0, blue: 91/255.0, alpha: 1);
        pieChartDataSet.drawValuesEnabled = false
        pieChartView.chartDescription?.enabled = false
        pieChartView.rotationAngle = 0
        pieChartView.rotationEnabled = false
        pieChartView.isUserInteractionEnabled = false
        pieChartView.legend.enabled = false
        pieChartView.data = pieChartData
        
    }
    
    func setLineChart(y_values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<y_values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: y_values[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        // set chart layout
        lineChartView.data = lineChartData
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.leftAxis.axisMaximum = 8
        lineChartView.leftAxis.labelCount = 1
        lineChartView.notifyDataSetChanged()
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.lineData?.setDrawValues(false)
        lineChartView.legend.enabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.drawBordersEnabled = true
        lineChartView.borderColor =  UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1);
    }
    
    @IBAction func backButtonClicked (sender: Any) {
        
        // ensure to not rerun viewDidLoad upon return to ViewController
        self.dismiss(animated: true, completion: self.delegate?.MoodViewControllerDidBack);
        
    }
    
    
}

