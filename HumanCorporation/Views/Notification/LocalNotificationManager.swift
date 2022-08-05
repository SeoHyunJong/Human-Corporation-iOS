//
//  LocalNotificationManager.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/05.
//

import Foundation
import UserNotifications

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound]) {
                granted, error in
                if granted == true && error == nil {
                }
            }
    }
    
    func addNotification(title: String) {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings {
            settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    
    func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            
            content.sound = UNNotificationSound.default
            content.body = "벌써 하루가 끝나가는군! 오늘 너의 일과들이 생산적이었는지 점검해보자구!"
            
            var date = DateComponents()
            date.hour = 23
            date.minute = 30
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else {return}
                print("알림 스케쥴링 성공")
            }
        }
    }
}
