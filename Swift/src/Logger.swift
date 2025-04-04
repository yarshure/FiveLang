import Foundation

public class Logger { // Mark the class as public
    public static var isDebugEnabled: Bool = false // Mark the property as public

    public static func log(_ message: String) { // Mark the method as public
        if isDebugEnabled {
            print("[DEBUG] \(message)")
        }
    }

    public static func error(_ message: String) { // Mark the method as public
        print("[ERROR] \(message)")
    }

    public static func info(_ message: String) { // Mark the method as public
        print("[INFO] \(message)")
    }
}