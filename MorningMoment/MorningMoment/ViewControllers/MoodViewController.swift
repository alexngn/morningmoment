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


public class MoodViewController: UIViewController, ChartViewDelegate {
    
    // CLASS PROPERTIES
    weak var delegate: MoodViewControllerDelegate?
    var CDJournal: [CDJournalPage]!
    @IBOutlet weak var background_image: UIImageView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        var mood: [Double] = []                              // every mood (int value) input in the journal
        var mood_frequency = Array(repeating: 0.0, count: 9) // number of times each mood type (0..8) has been input in the journal
        
        // for each journal page: Input mood value in mood array and keep track of mood type frequency
        for page_index in 0..<CDJournal.count {
            let journal_page = CDJournal[page_index]
            mood.append(Double(journal_page.mood))
            mood_frequency[Int(journal_page.mood)] += 1
        }
        
        // create line and pie chart
        setLineChart(y_values: mood)
        setPieChart(frequencies: mood_frequency)
        view.sendSubviewToBack(background_image)
    }
    
    // set pie chart properties
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
        
        // set data entries
        for i in 0..<frequencies.count {
            
            let dataEntry: ChartDataEntry!
            let mood_freq = frequencies[i]
            var percentage = 100
            
            // input y values as percentage of mood type frequency relative to all input moods in journal
            if (mood_freq > 0 && CDJournal.count > 0) {
                
                percentage = Int(mood_freq/Double(CDJournal.count) * 100.0)
                dataEntry = PieChartDataEntry(value: mood_freq, label: String(percentage) + "%")
                // set mood type as x value
                dataEntry.x = Double(i)
            
                // ensure that 0 frequencies have no label and will appear in the pie chart
            } else {
                dataEntry = PieChartDataEntry(value: mood_freq, label: "")
            }
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        // attach a color to every y value (each representing a mood type)
        pieChartDataSet.colors = [emoji_8_col, emoji_7_col, emoji_6_col, emoji_5_col, emoji_4_col, emoji_3_col, emoji_2_col, emoji_1_col, emoji_0_col]
        // set percentage label color
        pieChartDataSet.entryLabelColor = UIColor.init(red: 34/255.0, green: 83/255.0, blue: 91/255.0, alpha: 1);
        pieChartDataSet.drawValuesEnabled = false
        
        // set pie chart layout
        pieChartView.delegate = self
        pieChartView.holeColor = UIColor(white: 1, alpha: 0.0)
        pieChartView.chartDescription?.enabled = false
        pieChartView.rotationEnabled = false
        pieChartView.isUserInteractionEnabled = true
        pieChartView.highlightPerTapEnabled = true
        pieChartView.legend.enabled = false
        pieChartView.data = pieChartData
        
    }
    
    // set line chart properties
    func setLineChart(y_values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        // set data entries: every mood that has been input in the journal
        for i in 0..<y_values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: y_values[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)

        // set chart layout
        lineChartDataSet.lineWidth = 2.0
        lineChartView.data = lineChartData
        lineChartView.rightAxis.axisMinimum = 0
        lineChartView.rightAxis.axisMaximum = 8
        lineChartView.rightAxis.drawGridLinesEnabled = true
        lineChartView.rightAxis.labelCount = 8
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.leftAxis.axisMaximum = 8
        lineChartView.leftAxis.labelCount = 8
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.lineData?.setDrawValues(false)
        lineChartView.legend.enabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.drawBordersEnabled = true
        lineChartView.borderColor =  UIColor.init(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1);
        lineChartView.animate(yAxisDuration: 1.5, easingOption: .easeOutSine)
        lineChartView.notifyDataSetChanged()
    }
    
    // back button clicked: return to menu
    @IBAction func backButtonClicked (sender: Any) {
        
        // ensure to not rerun viewDidLoad upon return to ViewController
        self.dismiss(animated: true, completion: self.delegate?.MoodViewControllerDidBack);
        
    }
    
    // pie chart slice clicked: show corresponding emoji on slice
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        // use entry x value (mood type) to identify mood being clicked on: set corresponding emoji image
        let emoji_image = getSliceEmojiWithID(number: Int(entry.x))
        // user marker position to set emoji image position
        let emoji_pos_x = chartView.getMarkerPosition(highlight: highlight).x + 25
        let emoji_pos_y = chartView.getMarkerPosition(highlight: highlight).y + 610
        
        // set emoji image size and position
        let emoji_view: UIImageView!
        emoji_view = UIImageView(frame:CGRect(x: Int(emoji_pos_x), y: Int(emoji_pos_y), width:33, height:33))
        emoji_view.image = emoji_image
        
        // add emoji image to view
        self.view.addSubview(emoji_view)
        
        // delay 1 second and fade emoji image out for 0.3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.transition(with: self.view, duration: 0.3, options: [.transitionCrossDissolve], animations:
               {emoji_view.removeFromSuperview()}, completion: nil)
        }
    }
    
    // return emoji image with the argument ID
    func getSliceEmojiWithID(number: Int) -> UIImage {
        
        var image = UIImage(named: "0_emoji");
        
        switch (number) {
        case 1: image = UIImage(named: "1_emoji"); break;
        case 2: image = UIImage(named: "2_emoji"); break;
        case 3: image = UIImage(named: "3_emoji"); break;
        case 4: image = UIImage(named: "4_emoji"); break;
        case 5: image = UIImage(named: "5_emoji"); break;
        case 6: image = UIImage(named: "6_emoji"); break;
        case 7: image = UIImage(named: "7_emoji"); break;
        case 8: image = UIImage(named: "8_emoji"); break;
        default: break;
        }
        
        return image!
    }
}

