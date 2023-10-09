//
//  LogFormatter.swift
//  ZQMusic
//
//  Created by wupeng on 2021/9/9.
//

import CocoaLumberjack

class OSLogFormatter: NSObject, DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        "[\(logMessage.flag.string)] [业务模块:\(logMessage.business)] [\(logMessage.fileName):\(logMessage.line)] \(logMessage.message)"
    }
}
class FileLogFormatter: NSObject, DDLogFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
     
        dateFormatter.formatterBehavior = .behavior10_4
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
    }
    
    func format(message logMessage: DDLogMessage) -> String? {
        let date = dateFormatter.string(from: logMessage.timestamp)
        return "\(date) [\(logMessage.flag.string)] [业务模块:\(logMessage.business)] [\(logMessage.fileName):\(logMessage.line)] \(logMessage.message)"
    }
}

extension DDLogMessage {
    /**
     Keys used for associated objects.
     */
    private struct EXVarKeys {
        static var business        = "DDLogMessage.Business"
    }
    var business: String {
        get {
            if let value = objc_getAssociatedObject(self, &EXVarKeys.business) as? String {
                return value
            } else {
                return "unknown"
            }
        }
        set {
            objc_setAssociatedObject(self, &EXVarKeys.business, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
