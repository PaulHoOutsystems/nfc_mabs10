import Foundation
import CoreNFC

@objc(NFCMABS101Swift) 
class NFCMABS101Swift : CDVPlugin, NFCNDEFReaderSessionDelegate {
    @objc(echo:)
    func echo(command: CDVInvokedUrlCommand) {
        let inputParam = (command.arguments[0] as? NSObject)?.value(forKey: "param1") as? String ?? ""
        let status = inputParam.isEmpty ? CDVCommandStatus_ERROR : CDVCommandStatus_OK
        let message = inputParam.isEmpty ? "Please enter value in textfield" : "Welcome to cordova \(inputParam)"
        let pluginResult = CDVPluginResult(status: status, messageAs: message)
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
    }


    // Adapted from https://github.com/cizodevahm/NFC-tag-reader/blob/main/nfcdemo/NFCWriter.swift
    var nfcSession:NFCNDEFReaderSession?
    var dataFromNFC = ""
    func scan(withData:String){
        
        guard NFCReaderSession.readingAvailable else {
            return
        }
                
        nfcSession = NFCNDEFReaderSession(
            delegate: self,
            queue: nil,
            invalidateAfterFirstRead: false // set true if read mode
        )
        nfcSession?.alertMessage = "Hold NFC card near iPhone"
        nfcSession?.begin()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
    }


    func invalidateSession(_ command: CDVInvokedUrlCommand) {
        nfcSession?.invalidate()
    }
 
    func enabled(_ command: CDVInvokedUrlCommand) {
        let errorResponse: [AnyHashable: Any] = [ // see https://unpkg.com/browse/cordova-plugin-fingerprint-aio@5.0.0/src/ios/Fingerprint.swift, line 80
            "message": "Something went wrong"
        ];
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "No NFC")

        if NFCNDEFReaderSession.readingAvailable // see https://gist.github.com/basvankuijck/85684800c1351a0c9346356790cb742a, line 10
        {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Success")
        } 
        
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
 
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        print("Detected tags with \(messages.count) messages")
        
        for message in messages
        {
            for record in message.records
            {
                if record.typeNameFormat == .nfcWellKnown
                {
                    let val = record.wellKnownTypeTextPayload()
                    print(val)
                    if let s = val.0,!s.isEmpty,let v = val.0
                    {
                        dataFromNFC = v
                        NotificationCenter.default.post(name: Notification.Name("NFCDataReceived"), object: nil, userInfo: ["data": dataFromNFC])

                    }
                 }
            }
            self.fireNdefEvent(message: message)
        }
        session.invalidate()
    }

    func ndefToNSDictionary(record: NFCNDEFPayload) -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setObject(record.typeNameFormat.rawValue, forKey: "tnf" as NSString)
        dict.setObject([UInt8](record.type), forKey: "type" as NSString)
        dict.setObject([UInt8](record.identifier), forKey: "id" as NSString)
        dict.setObject([UInt8](record.payload), forKey: "payload" as NSString)
        
        return dict
    }

    func fireNdefEvent(message: NFCNDEFMessage) {
        let array = NSMutableArray()
        for record in message.records {
            let recordDictionary = self.ndefToNSDictionary(record: record)
            array.add(recordDictionary)
        }
        let wrapper = NSMutableDictionary()
        wrapper.setObject(array, forKey: "ndefMessage" as NSString)
        
        let returnedJSON = NSMutableDictionary()
        returnedJSON.setValue("ndef", forKey: "type")
        returnedJSON.setObject(wrapper, forKey: "tag" as NSString)

        // return returnedJSON as! [AnyHashable : Any]     
        //completed(returnedJSON, nil)
    } 
}