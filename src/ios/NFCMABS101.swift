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
                    self.fireNdefEvent(message: message)
                }
            }
        }
        session.invalidate()
    }

    func fireNdefEvent(message: NFCNDEFMessage) {
        let response = message.ndefMessageToJSON()
        //completed(response, nil)
    } 
}