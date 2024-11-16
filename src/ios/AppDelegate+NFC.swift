//
//  AppDelegate+NFC.swift
//
//  Created by André Gonçalves on 13/04/2020.
//
import CoreNFC

extension AppDelegate {
    // override open 
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        NSLog("Extending UIApplicationDelegate")
        
        return true;
    }
}
