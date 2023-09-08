//
//  sampleVC.swift
//  sampleChart
//
//  Created by Anandh Selvam on 26/08/23.
//

import UIKit
import SwiftUI



@objc
enum TrendPageType: Int {
    case hrd = 0
    case hrv = 1
    case sleep = 2
    case temperature = 3
}

@objcMembers
class TrendViewData: NSObject {
    let title: String
    let descriptions: String
    let subDescription: String
    let infoLabel: String

    init(title: String, description: String, subDescription: String, infoLabel: String) {
        self.title = title
        self.descriptions = description
        self.subDescription = subDescription
        self.infoLabel = infoLabel
        super.init()
    }
}

@objcMembers
class TrendDataWrapper: NSObject {
    let pageTitle: String
    let infoText: String
    let infoViewData: [TrendViewData]

    init(pageTitle: String, infoText: String, infoViewData: [TrendViewData]) {
        self.pageTitle = pageTitle
        self.infoText = infoText
        self.infoViewData = infoViewData
        super.init()
    }
}
@objc
class HRDipTrendVC: UIViewController {

    let segmentedControl = UISegmentedControl(items: ["Daily", "Weekly", "Monthly"])
    let scrollView = UIScrollView()
    let hostingController = UIHostingController(rootView: chartview(chartWidth: 700.0))
    let containerView = UIView() // Container for all views
    let dateRangeLabel = UILabel()
    let percentLabel = UILabel()
    @objc public var pageType = TrendPageType.hrd.rawValue
    @objc public var pageContent = TrendDataWrapper(pageTitle: "", infoText: "", infoViewData: [])


    override func viewDidLoad() {
        super.viewDidLoad()

        getValues(selectedSegemtn: 0)
        view.backgroundColor = .black
        self.title = pageContent.pageTitle
        // Configure the segmented control
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = UIColor.systemBlue

        // Customize the text color for the selected segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)

        // Configure the scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        // Create a container view to hold all views
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Add the segmented control to the container view
        containerView.addSubview(segmentedControl)
        
        

        // Add the scroll view to the container view
        containerView.addSubview(scrollView)
        
        

        // Add constraints for the container view
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Add constraints for the segmented control
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])

        // Add constraints for the scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        
        
        dateRangeLabel.textColor = .white
        dateRangeLabel.textAlignment = .left
        dateRangeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        scrollView.addSubview(dateRangeLabel)
        dateRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateRangeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            dateRangeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            percentLabel.widthAnchor.constraint(equalToConstant: 100),
            percentLabel.heightAnchor.constraint(equalToConstant: 20)
            
        ])
        
        // Blue label in the top right corner
        percentLabel.text = pageContent.infoText
        percentLabel.textColor = .white
        percentLabel.textAlignment = .left
        percentLabel.font = UIFont.boldSystemFont(ofSize: 12)
        scrollView.addSubview(percentLabel)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            percentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            percentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            percentLabel.widthAnchor.constraint(equalToConstant: 100),
            percentLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        
        // Add your hostingController as a child
        addChild(hostingController)
        scrollView.addSubview(hostingController.view) // Add it to the scroll view
        hostingController.didMove(toParent: self)

        // Set constraints for the hostingController's view within the scroll view
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor), hostingController.view.heightAnchor.constraint(equalToConstant: 250.0)
        ])
        
        
        
       
        if(pageContent.infoViewData.count>0)
        {
            // Create and add two more views with labels
            let view1 = createContentView(data: pageContent.infoViewData[0])
            scrollView.addSubview(view1)
            view1.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view1.topAnchor.constraint(equalTo: hostingController.view.bottomAnchor, constant: 16),
                view1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
                view1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32), // Width same as scrollView
                view1.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16), // Ensure proper spacing from the bottom
                view1.heightAnchor.constraint(greaterThanOrEqualToConstant: 150.0)
            ])
            
            if(pageContent.infoViewData.count>1)
            {
                let view2 = createContentView(data: pageContent.infoViewData[1])
                scrollView.addSubview(view2)
                view2.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    view2.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 16),
                    view2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
                    view2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32), // Width same as scrollView
                    view2.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16), // Ensure proper spacing from the bottom
                    view2.heightAnchor.constraint(greaterThanOrEqualToConstant: 150.0)
                ])
            }
        }
       
    }

    func createContentView(data: TrendViewData) -> UIView {
        let contentView = UIView()
        contentView.backgroundColor = .white.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 5
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = data.title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Description label
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white.withAlphaComponent(0.6)
        descriptionLabel.text = data.descriptions
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        // Description label
        let subdescriptionLabel = UILabel()
        subdescriptionLabel.textColor = .white
        subdescriptionLabel.text = data.subDescription
        subdescriptionLabel.numberOfLines = 0
        subdescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        subdescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subdescriptionLabel)

        // Blue label in the top right corner
        let blueLabel = UILabel()
        blueLabel.text = data.infoLabel
        blueLabel.textColor = .systemBlue
        blueLabel.textAlignment = .right
        blueLabel.font = UIFont.boldSystemFont(ofSize: 12)
        blueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(blueLabel)

        // Constraints for labels
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: blueLabel.leadingAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            
            subdescriptionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            subdescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            subdescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            subdescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            blueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            blueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            blueLabel.widthAnchor.constraint(equalToConstant: 60), // Width of the blue label
        ])

        return contentView
    }

    // Handle segmented control value changed event
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        getValues(selectedSegemtn: sender.selectedSegmentIndex)
        
    }
    
    func getValues(selectedSegemtn: Int)
    {
        let dateRange = self.getDate(dateType: selectedSegemtn)
        dateRangeLabel.text = dateRange.monthName
        if(pageType == TrendPageType.hrd.rawValue )
        {
            
            
            let timeRange = self.getTimeInterval(dateType: selectedSegemtn)
            dateRangeLabel.text = timeRange.monthName
            if let start = timeRange.startTimestamp, let end = timeRange.endTimestamp {
                
//                DBSleepData.queryDbSleep(by: DeviceCenter.instance().bindDevice?.macAddress ?? "", begin: start, endTime: end) { results in
//                    // Your completion block code here
//
//
//                }
                
                let sleepData = generateRandomNumbers(forDurationInDays: selectedSegemtn == 0 ? 1 : selectedSegemtn == 5 ?  7 : 30)
                print("adsfaf")

            }
            

        }
        else if(pageType == TrendPageType.hrv.rawValue)
        {
            if let start = dateRange.start, let end = dateRange.end {
                DBHrv.queryAverage(DeviceCenter.instance().bindDevice?.macAddress ?? "", begin: start, end: end) { average, maxTime, minTime in
                    // Your completion block code here
                    
                    
                }
            }
        }
        else if(pageType == TrendPageType.sleep.rawValue)
        {
            let timeRange = self.getTimeInterval(dateType: selectedSegemtn)
            dateRangeLabel.text = timeRange.monthName
            if let start = timeRange.startTimestamp, let end = timeRange.endTimestamp {
                DBSleepData.queryDbSleep(by: DeviceCenter.instance().bindDevice?.macAddress ?? "", begin: start, endTime: end) { results in
                    // Your completion block code here
                    
                    
                }
            }
        }
        else if(pageType == TrendPageType.temperature.rawValue)
        {
            if let start = dateRange.start, let end = dateRange.end {
                DBThermemoter.query(by: DeviceCenter.instance().bindDevice?.macAddress ?? "", begin: start, end: end, orderBeTimeDesc: true) { results, maxThermemoter, minThermemoter, avgThermemoter in
                    // Your completion block code here
                    
                    
                }
            }
        }
    }
    
    func getDate(dateType: Int) -> (start: Date?, end: Date?, monthName: String?, day: String?) {
        let calendar = Calendar.current
        let currentDate = Date()
        var start: Date?
        var end: Date?
        
        var monthName: String? = nil
        var day: String? = nil
        
        switch dateType {
        case 0:
            hostingController.rootView = chartview(stackedBarData:generateRandomNumbers(forDurationInDays: 5), chartWidth: self.view.frame.width - 20)
            start = Calendar.current.date(byAdding: .hour, value: -24, to: Date())
            end = currentDate
            break
        case 1:
            hostingController.rootView = chartview(stackedBarData:generateRandomNumbers(forDurationInDays: 7), chartWidth: self.view.frame.width - 20)
            start = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate)
            end = currentDate
            break
        case 2:
            hostingController.rootView = chartview(stackedBarData:generateRandomNumbers(forDurationInDays: 30), chartWidth: 600.0)
            start = calendar.date(byAdding: .month, value: -1, to: currentDate)
            end = currentDate
            break
        default:
            break
        }
        
        if let start = start, let end = end {
            // Check if it's for a single day, and if so, extract the month name and day.
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM"
                
                let startString = dateFormatter.string(from: start)
                let endString = dateFormatter.string(from: end)
                var dateRange = String()
                if startString == endString {
                    // If the start and end dates are the same day, display just one date
                    dateRange = startString
                } else {
                    // If the start and end dates are different days, display a date range
                    dateRange = "\(startString) - \(endString)"
                }
            
            return (start, end, dateRange, day)
        } else {
            // Return nil for start and end if dates couldn't be calculated
            return (nil, nil, nil, nil)
        }
    }
    

    func getTimeInterval(dateType: Int) -> (startTimestamp: TimeInterval?, endTimestamp: TimeInterval?, monthName: String?, day: String?) {
        let calendar = Calendar.current
        let currentDate = Date()
        var startTimestamp: TimeInterval?
        let endTimestamp = currentDate.timeIntervalSince1970
        var day: String? = nil

        switch dateType {
        case 0:
            startTimestamp = endTimestamp - (24 * 60 * 60) // 24 hours in seconds
            break
        case 1:
            startTimestamp = endTimestamp - (7 * 24 * 60 * 60) // 7 days in seconds
            break
        case 2:
            // Note: This assumes a month is approximately 30 days
            startTimestamp = endTimestamp - (30 * 24 * 60 * 60) // 30 days in seconds
            break
        default:
            break
        }

        if let startTimestamp = startTimestamp {
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM"
                
                let startString = dateFormatter.string(from: Date(timeIntervalSince1970: startTimestamp))
                let endString = dateFormatter.string(from: currentDate)
                var dateRange = String()
                if startString == endString {
                    // If the start and end dates are the same day, display just one date
                    dateRange = startString
                } else {
                    // If the start and end dates are different days, display a date range
                    dateRange = "\(startString) - \(endString)"
                }

            return (startTimestamp, endTimestamp, dateRange, day)
        } else {
            // Return nil for start and end timestamps if they couldn't be calculated
            return (nil, nil, nil, nil)
        }

    }
    
    
   


    func generateRandomNumbers(forDurationInDays days: Int) -> [HRSample] {
        var dummySleepDataArray: [HRSample] = []
        
        for _ in 0..<days {
            // Create a new SleepData object
            
            // Generate two random numbers between 1 and 24
            let randomValue1 = Double.random(in: 1.0...14.0)
            let randomValue2 = Double.random(in: 1.0...10.0)
            
            
            
            // Calculate the difference between the two values
            let dummySleepData = HRSample(date: generateRandomString(length: 5), min: Int(randomValue1), max: Int((randomValue1 + randomValue2)))
           dummySleepDataArray.append(dummySleepData)
          
        }
        
        return dummySleepDataArray
    }
    
    func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }


    







    

}
