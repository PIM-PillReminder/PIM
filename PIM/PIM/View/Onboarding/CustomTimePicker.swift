//
//  CustomPickerView.swift
//  PIM
//
//  Created by 신정연 on 2023/09/23.
//

import SwiftUI

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "a hh : mm"
    formatter.amSymbol = "오전" // "AM"을 "오전"으로 변경
    formatter.pmSymbol = "오후" // "PM"을 "오후"로 변경
    return formatter
}()

struct TimePickerDataGenerator {
    static func generateTimes() -> [Date] {
        let calendar = Calendar.current
        let currentDate = Date()
        var times: [Date] = []

        for hour in 0..<24 {
            for minute in [0, 15, 30, 45] {
                if let time = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate) {
                    times.append(time)
                }
            }
        }

        return times
    }
}
import SwiftUI

struct CustomTimePicker: View {
    
    @Binding var selectedTime: Date
    
    // 시간과 분을 저장할 변수들을 추가합니다.
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 10) {
                Spacer()
                // 오후/오전 피커
                Picker("", selection: $selectedTime) {
                    Text("오전").tag("AM")
                    Text("오후").tag("PM")
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: geometry.size.width * 0.2)
                
                // 시간 피커
                Picker("", selection: $selectedHour) {
                    ForEach(1...12, id: \.self) { hour in
                        Text("\(hour)")
                            .tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: geometry.size.width * 0.2, height: 200)
                
                // 분 피커
                Picker("", selection: $selectedMinute) {
                    ForEach(0...59, id: \.self) { minute in
                        Text("\(minute)")
                            .tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: geometry.size.width * 0.2, height: 200)
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .onChange(of: selectedTime) { _ in
            // 선택된 시간, 분을 기반으로 selectedTime을 업데이트합니다.
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: selectedTime)
            let minute = calendar.component(.minute, from: selectedTime)
            
            var dateComponents = DateComponents()
            dateComponents.hour = selectedHour
            dateComponents.minute = selectedMinute
            dateComponents.second = 0
            
            let newDate = calendar.date(bySettingHour: hour >= 12 ? (selectedHour + 12) : selectedHour, minute: selectedMinute, second: 0, of: selectedTime)
            
            if let newDate = newDate {
                selectedTime = newDate
            }
        }
    }
}

struct CustomTimePicker_Previews: PreviewProvider {
    @State static var selectedTime = Date()

    static var previews: some View {
        CustomTimePicker(selectedTime: $selectedTime)
    }
}

