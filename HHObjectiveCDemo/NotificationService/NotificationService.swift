//
//  NotificationService.swift
//  NotificationService
//
//  Created by Michael on 2023/3/17.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    //contentHandler闭包 参数是UNNotificationContent 返回值是Void
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            //附件
            let userInfo: [AnyHashable : Any] = bestAttemptContent.userInfo
            let aps: [AnyHashable : Any] = userInfo["aps"] as! [AnyHashable : Any]
            let imgUrl: String? = aps["imageAbsoluteString"] as? String
            if (imgUrl == nil) {
                contentHandler(bestAttemptContent)
            } else {
                loadAttachment(imgUrl: imgUrl!) { attachment in
                    if (attachment != nil) {
                        bestAttemptContent.attachments = [attachment!]
                    }
                    contentHandler(bestAttemptContent)
                }
            }
        }
    }
    
    // MARK: 下载文件
    func loadAttachment(imgUrl: String, completionHandle: @escaping((_ attachment: UNNotificationAttachment?) -> Void)) {
        var attachment: UNNotificationAttachment?
        let attachmentUrl: URL = URL(string: imgUrl)!
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlRequest: URLRequest = URLRequest(url: attachmentUrl)
        session.downloadTask(with: urlRequest) { (temporaryFileLocation: URL?, response: URLResponse?, error: Error?) in
            if error == nil, temporaryFileLocation != nil {
                let fileManager: FileManager = FileManager.default
                let fileExt: String = ".jpg"
                if #available(iOSApplicationExtension 16.0, *) {
                    let localUrl: URL = URL(filePath: temporaryFileLocation!.path().appending(fileExt))
                    try! fileManager.moveItem(at: temporaryFileLocation!, to: localUrl)
                    try! attachment = UNNotificationAttachment(identifier: "", url: localUrl)
                } else {
                    // Fallback on earlier versions
                    let localUrl: URL = URL(fileURLWithPath: temporaryFileLocation!.path.appending(fileExt))
                    try! fileManager.moveItem(at: temporaryFileLocation!, to: localUrl)
                    try! attachment = UNNotificationAttachment(identifier: "", url: localUrl)
                }
            }
            completionHandle(attachment)
        }.resume()
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
