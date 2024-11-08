//
//  AppDelegate+NFC.swift
//
//  Created by André Gonçalves on 13/04/2020.
//
import CoreNFC

extension AppDelegate {
    
    override open func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        NSLog("Extending UIApplicationDelegate")
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else {
            return false
        }
        
        // Confirm that the NSUserActivity object contains a valid NDEF message.
        if #available(iOS 12.0, *) {
            let ndefMessage = userActivity.ndefMessagePayload
            guard ndefMessage.records.count > 0,
            ndefMessage.records[0].typeNameFormat != .empty else {
                return false
            }
            
            // RT3079764 NOTE: The below is commented out as it is not supported in swift 5

            //let nfcPluginInstance: NfcPlugin = self.viewController.getCommandInstance("NfcPlugin") as! NfcPlugin            
            var resolved: Bool = false;
            // NSLog(nfcPluginInstance.debugDescription);
            //     DispatchQueue.global().async {
            //         let waitingTimeInterval: Double = 0.1;
            //         print("<NFC> Did start timeout")
            //         for _ in 1...2000 { // 5?s timeout
            //             if ( !nfcPluginInstance.isListeningNDEF ) {
            //             Thread.sleep(forTimeInterval: waitingTimeInterval)
            //             } else {
            //                 let jsonDictionary = ndefMessage.ndefMessageToJSON()
            //                 nfcPluginInstance.sendThroughChannel(jsonDictionary: jsonDictionary)
            //                 resolved = true
            //                 return
            //             }
            //         }
            // }
            return resolved
            
        } else {
            return false
        }
    }
}
