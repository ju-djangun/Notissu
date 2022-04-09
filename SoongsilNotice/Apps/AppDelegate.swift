//
//  AppDelegate.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import GoogleMobileAds
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MajorModel.initializeMajor()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        HomeSwitcher.shared.updateRootVC()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let _ = components.path,
            let params = components.queryItems else {
                return false
        }
        
        NotissuProperty.openIndex = nil
        
        if let tabIndex = params.first(where: { $0.name == "index" })?.value {
            NotissuProperty.openIndex = Int(tabIndex) ?? 0
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "widget")))
            return true
        } else {
            return false
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "nil")")
        if let token = fcmToken {
            let dataDict:[String: String] = ["token": token]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
    }
}
