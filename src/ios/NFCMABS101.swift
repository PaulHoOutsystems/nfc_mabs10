import Foundation

@objc(NFCMABS101Swift) 
class NFCMABS101Swift : CDVPlugin {
    @objc(echo:)
    func echo(command: CDVInvokedUrlCommand) {
        let inputParam = (command.arguments[0] as? NSObject)?.value(forKey: "param1") as? String ?? ""
        let status = inputParam.isEmpty ? CDVCommandStatus_ERROR : CDVCommandStatus_OK
        let message = inputParam.isEmpty ? "Please enter value in textfield" : "Welcome to cordova \(inputParam)"
        let pluginResult = CDVPluginResult(status: status, messageAs: message)
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
    }
}