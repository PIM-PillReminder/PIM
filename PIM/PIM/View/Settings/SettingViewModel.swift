//
//  SettingViewModel.swift
//  PIM
//
//  Created by 장수민 on 12/12/23.
//

import Foundation
import SwiftUI
import UserNotifications

class SettingViewModel: ObservableObject {
  @Published var selectedTime: Date? = UserDefaults.standard.object(forKey: "SelectedTime") as? Date ?? nil
  @Published var modalBackground: Bool = false
}
