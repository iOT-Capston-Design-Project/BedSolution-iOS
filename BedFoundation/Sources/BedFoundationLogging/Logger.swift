import Foundation
import OSLog

public enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

public protocol Logging {
    func log(_ level: LogLevel, module: String, _ message: String)
}

public final class Logger: Logging {
    public static let shared = Logger()
    private let queue = DispatchQueue(label: "com.bedsolution.logger", qos: .utility)
    private let log: OSLog

    private init() {
        let subsystem = Bundle.main.bundleIdentifier ?? "BedSolution"
        self.log = OSLog(subsystem: subsystem, category: "BedFoundation")
    }

    public func log(_ level: LogLevel, module: String, _ message: String) {
        queue.async {
            let formatted = "\(self.timestamp()) [\(module)] [\(level.rawValue)] \(message)"
            os_log("%{public}@", log: self.log, type: self.osLogType(for: level), formatted)
            if level == .error {
                self.writeToFile(formatted)
            }
        }
    }

    private func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }

    private func osLogType(for level: LogLevel) -> OSLogType {
        switch level {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        }
    }

    private func writeToFile(_ text: String) {
        guard let url = logFileURL() else { return }
        let entry = text + "\n"
        if FileManager.default.fileExists(atPath: url.path) {
            if let handle = try? FileHandle(forWritingTo: url) {
                handle.seekToEndOfFile()
                if let data = entry.data(using: .utf8) {
                    handle.write(data)
                }
                try? handle.close()
            }
        } else {
            try? entry.write(to: url, atomically: true, encoding: .utf8)
        }
    }

    private func logFileURL() -> URL? {
        let fm = FileManager.default
        guard let doc = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return doc.appendingPathComponent("bedsolution.log")
    }
}
