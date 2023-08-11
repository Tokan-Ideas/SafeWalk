//
//  AppDelegate.swift
//  SafeWalk
//
//  Created by Rahqi T. Sarsour on 7/30/23.
//

import Foundation
import UIKit
import Amplify


class AppDelegate: NSObject, UIApplicationDelegate {
    // Note: In order for this to work on the simulator, you must be running
    // on Apple Silicon, with macOS 13+, Xcode 14+, and iOS simulator 16+.
    //
    // If your development environment does not meet all of these requirements,
    // then you must run on a real device to get an APNs token.
    //
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Task {
            do {
                try await Amplify.Notifications.Push.registerDevice(apnsToken: deviceToken)
                print("Registered with Pinpoint.")
            } catch {
                print("Error registering with Pinpoint: \(error)")
            }
        }
    }
}
