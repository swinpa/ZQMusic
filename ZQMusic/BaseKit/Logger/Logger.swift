//
//  Logger.swift
//  PureTuber
//
//  Created by wupeng on 2021/9/9.
//

import CocoaLumberjack

enum Business:String {
    case Debug
    case HTTP
    case DB
    case Search
}

/// 日志打印
enum Logger {
    private static let level: DDLogLevel = .all
    private static let osLogger = setupOSLogger()
    private static let setupToken = "LoggerSetupToken"
    
    
    private static func setup() {
        
        if let osLogger = osLogger {
            DDLog.add(osLogger)
        }
        /*
         osLogger 跟 DDTTYLogger 一起会导致Xcode 输出重复的
        #if DEBUG
        if let tyLogger = DDTTYLogger.sharedInstance {
            DDLog.add(tyLogger)
        }
        #endif
         */
    }
    
    // MARK: - private
    private static func setupOSLogger() -> DDOSLogger? {
        let logger = DDOSLogger.sharedInstance
        logger.logFormatter = OSLogFormatter()
        return logger
    }
    
    
    
    // TODO: - 等待swift5.5正式版发布后, 把`#file`改为`#fileID`更佳
    // - https://docs.swift.org/swift-book/ReferenceManual/Expressions.html#ID390
    
    @inlinable
    static func debug(_ business:Business,
                      message: @autoclosure () -> Any,
                      context: Int = 0,
                      file: StaticString = #fileID,
                      function: StaticString = #function,
                      line: UInt = #line,
                      tag: Any? = nil,
                      asynchronous async: Bool = asyncLoggingEnabled,
                      ddlog: DDLog = .sharedInstance) {
        DispatchQueue.once(token: setupToken) {
            setup()
        }
        let msg = message()
        if level.rawValue & DDLogFlag.debug.rawValue != 0 && dynamicLogLevel.rawValue & DDLogFlag.debug.rawValue != 0 {
            let logMessage = DDLogMessage(message: String(describing: msg),
                                          level: level,
                                          flag: .debug,
                                          context: context,
                                          file: String(describing: file),
                                          function: String(describing: function),
                                          line: line,
                                          tag: tag,
                                          options: [.copyFile, .copyFunction],
                                          timestamp: nil)
            logMessage.business = business.rawValue
            ddlog.log(asynchronous: async, message: logMessage)
        }
        
    }
    
    @inlinable
    static func info(_ business:Business,
                     message: @autoclosure () -> Any,
                     context: Int = 0,
                     file: StaticString = #fileID,
                     function: StaticString = #function,
                     line: UInt = #line,
                     tag: Any? = nil,
                     asynchronous async: Bool = asyncLoggingEnabled,
                     ddlog: DDLog = .sharedInstance) {
        DispatchQueue.once(token: setupToken) {
            setup()
        }
        let msg = message()
        if level.rawValue & DDLogFlag.info.rawValue != 0 && dynamicLogLevel.rawValue & DDLogFlag.info.rawValue != 0 {
            let logMessage = DDLogMessage(message: String(describing: msg),
                                          level: level,
                                          flag: .info,
                                          context: context,
                                          file: String(describing: file),
                                          function: String(describing: function),
                                          line: line,
                                          tag: tag,
                                          options: [.copyFile, .copyFunction],
                                          timestamp: nil)
            logMessage.business = business.rawValue
            ddlog.log(asynchronous: async, message: logMessage)
        }
    }
    
    @inlinable
    static func warn(_ business:Business,
                     message: @autoclosure () -> Any,
                     context: Int = 0,
                     file: StaticString = #fileID,
                     function: StaticString = #function,
                     line: UInt = #line,
                     tag: Any? = nil,
                     asynchronous async: Bool = asyncLoggingEnabled,
                     ddlog: DDLog = .sharedInstance) {
        DispatchQueue.once(token: setupToken) {
            setup()
        }
        let msg = message()
        if level.rawValue & DDLogFlag.warning.rawValue != 0 && dynamicLogLevel.rawValue & DDLogFlag.warning.rawValue != 0 {
            let logMessage = DDLogMessage(message: String(describing: msg),
                                          level: level,
                                          flag: .info,
                                          context: context,
                                          file: String(describing: file),
                                          function: String(describing: function),
                                          line: line,
                                          tag: tag,
                                          options: [.copyFile, .copyFunction],
                                          timestamp: nil)
            logMessage.business = business.rawValue
            ddlog.log(asynchronous: async, message: logMessage)
        }
    }
    
    @inlinable
    static func verbose(_ business:Business,
                        message: @autoclosure () -> Any,
                        context: Int = 0,
                        file: StaticString = #fileID,
                        function: StaticString = #function,
                        line: UInt = #line,
                        tag: Any? = nil,
                        asynchronous async: Bool = asyncLoggingEnabled,
                        ddlog: DDLog = .sharedInstance) {
        DispatchQueue.once(token: setupToken) {
            setup()
        }
        let msg = message()
        if level.rawValue & DDLogFlag.verbose.rawValue != 0 && dynamicLogLevel.rawValue & DDLogFlag.verbose.rawValue != 0 {
            let logMessage = DDLogMessage(message: String(describing: msg),
                                          level: level,
                                          flag: .info,
                                          context: context,
                                          file: String(describing: file),
                                          function: String(describing: function),
                                          line: line,
                                          tag: tag,
                                          options: [.copyFile, .copyFunction],
                                          timestamp: nil)
            logMessage.business = business.rawValue
            ddlog.log(asynchronous: async, message: logMessage)
        }
    }
    
    @inlinable
    static func error(_ business:Business,
                      message: @autoclosure () -> Any,
                      error: Error? = nil,
                      context: Int = 0,
                      file: StaticString = #fileID,
                      function: StaticString = #function,
                      line: UInt = #line,
                      tag: Any? = nil,
                      asynchronous async: Bool = asyncLoggingEnabled,
                      ddlog: DDLog = .sharedInstance) {
        DispatchQueue.once(token: setupToken) {
            setup()
        }
        let msg = message()
        if level.rawValue & DDLogFlag.error.rawValue != 0 && dynamicLogLevel.rawValue & DDLogFlag.error.rawValue != 0 {
            let logMessage = DDLogMessage(message: String(describing: msg),
                                          level: level,
                                          flag: .info,
                                          context: context,
                                          file: String(describing: file),
                                          function: String(describing: function),
                                          line: line,
                                          tag: tag,
                                          options: [.copyFile, .copyFunction],
                                          timestamp: nil)
            logMessage.business = business.rawValue
            ddlog.log(asynchronous: async, message: logMessage)
        }
    }
    
    
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:()->Void) {
        defer { objc_sync_exit(self) }
        objc_sync_enter(self);
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
