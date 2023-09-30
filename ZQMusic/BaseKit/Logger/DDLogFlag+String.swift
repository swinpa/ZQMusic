//
//  DDLogFlag+String.swift
//  PureTuber
//
//  Created by wupeng on 2021/9/9.
//

import CocoaLumberjack

extension DDLogFlag {
    var string: String {
        switch self {
            case .debug:
                return "Debug"
            case .info:
                return "Info"
            case .warning:
                return "Warning"
            case .verbose:
                return "Verbose"
            case .error:
                return "Error"
            default:
                return "U"
        }
    }
}
