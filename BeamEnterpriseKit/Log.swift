//
//  Log.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/25/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

public enum BKLogLevel: Int {
    case debug //🍋✳️
    case info //✳️💡🛎
    case warning //🔮🔫☔️☄️
    case error //🚫🔫
    case critical //🆘🚨
    case exception //🌈💣
}

class BKLog {
        
    static var logLevel: BKLogLevel = .debug
    
    class func debug(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.debug.rawValue else { return }
        let fullMessage = "🍋 BeamKit DEBUG: " + message.description
        
        print(fullMessage)
    }
    
    class func debug(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.debug.rawValue else { return }
        let fullMessage = "🍋 BeamKit DEBUG: " + message
        
        print(fullMessage)
    }
    
    class func info(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.info.rawValue else { return }
        let fullMessage = "✳️ BeamKit INFO: " + message.description
        
        print(fullMessage)
    }
    
    class func info(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.info.rawValue else { return }
        let fullMessage = "✳️ BeamKit INFO: " + message
        
        print(fullMessage)
    }
    
    class func warning(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.warning.rawValue else { return }
        let fullMessage = "☔️💧 BeamKit WARNING: " + message.description
        
        print(fullMessage)
    }
    
    class func warning(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.warning.rawValue else { return }
        let fullMessage = "☔️💧 BeamKit WARNING: " + message
        
        print(fullMessage)
    }
    
    class func error(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.error.rawValue else { return }
        let fullMessage = "🚫🔫 BeamKit ERROR: " + message.description
        
        print(fullMessage)
    }
    
    class func error(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.error.rawValue else { return }
        let fullMessage = "🚫🔫 BeamKit ERROR: " + message
        
        print(fullMessage)
    }
    
    class func critical(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.critical.rawValue else { return }
        let fullMessage = "🆘🚨 BeamKit CRITICAL: " + message.description
        
        print(fullMessage)
    }
    
    class func critical(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.critical.rawValue else { return }
        let fullMessage = "🆘🚨 BeamKit CRITICAL: " + message
        
        print(fullMessage)
    }
    
    class func exception(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.exception.rawValue else { return }
        let fullMessage = "🌈💣 BeamKit EXCEPTION: " + message.description
        print(fullMessage)
    }
    
    class func exception(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLogLevel.exception.rawValue else { return }
        let fullMessage = "🌈💣 BeamKit EXCEPTION: " + message
        print(fullMessage)
    }
}
