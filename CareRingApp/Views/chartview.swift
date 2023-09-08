//
//  chartview.swift
//  sampleChart
//
//  Created by Anandh Selvam on 26/08/23.
//

import SwiftUI
import Charts


struct HRSample: Identifiable {
    let id = UUID()
    let date: String
    let min: Int
    let max: Int
}

var stackedBarData: [HRSample] = []

// Define a function to generate sample data
func generateSampleDataForJuly() -> [HRSample] {
    var stackedBarData: [HRSample] = []
    let calendar = Calendar.current
    let julyRange = calendar.range(of: .day, in: .month, for: Date(timeIntervalSinceNow: 0)) // Get the number of days in July
    
    if let daysInJuly = julyRange?.count {
        for day in 1...daysInJuly {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            
            // Generate a date within July with a time interval corresponding to the day
            let randomDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: 7, day: day))!
            
            // Format the date as "Jul 20"
            let formattedDate = dateFormatter.string(from: randomDate)
            
            
            // Generate random min and max values
            let randomMin = Int.random(in: 40..<80)
            let randomMax = Int.random(in: (randomMin + 1)..<120) // Ensure max is greater than min
            
            let sample = HRSample(date: formattedDate, min: randomMin, max: randomMax)
            stackedBarData.append(sample)
        }
    }
    
    return stackedBarData
}


struct chartview: View {
    
    var stackedBarData: [HRSample] = generateSampleDataForJuly()
    var chartWidth: CGFloat
    
    var body: some View {
        
        
            ScrollView(.horizontal, showsIndicators: false) {
                Chart {
                    ForEach(stackedBarData) { sample in
                        BarMark(
                            x: .value("Sample Date", sample.date),
                            yStart: .value("BPM Min", sample.min),
                            yEnd: .value("BPM Max", sample.max),
                            width: .fixed(7)
                        )
                        .clipShape(Capsule()).foregroundStyle(Color.init(hex: "e43f6f"))
                        
                    }
                }
                .frame(height: 200) // Set the height to 200
                .frame(width: chartWidth) // Set the height to 200
                .padding(20)
                
                .chartYAxis {
                    AxisMarks(values: [4,8,12,16,20,24]) { value in
                        AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                            .foregroundStyle(Color.gray)
                        AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 2))
                            .foregroundStyle(Color.white)
                        AxisValueLabel() { // construct Text here
                            if let intValue = value.as(Int.self) {
                                Text("\(intValue)")
                                    .font(.system(size: 10)) // style it
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                            .foregroundStyle(Color.gray)
                        AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 0))
                            .foregroundStyle(Color.white)
                        AxisValueLabel() { // construct Text here
                            if let intValue = value.as(String.self) {
                                Text("\(intValue)")
                                    .font(.system(size: 10)) // style it
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            
            
            
            
        }.background(Color.black)

        
            

    }
        
    
    mutating func changeChartWidth(newWidth: CGFloat) {
            chartWidth = newWidth
    }
                    
    
}

struct chartview_Previews: PreviewProvider {
    static var previews: some View {
        chartview(chartWidth: 700.0)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        
        scanner.scanHexInt64(&rgb)
        
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}






