import AppKit
import Foundation

/// Drives System Events to flip the system appearance.
public struct AppearanceController {
    public enum Failure: Error, Equatable {
        /// System Events refused to run the script, usually because Automation
        /// permission was not granted.
        case scriptFailed
    }

    /// AppleScript that flips dark mode and returns the new value.
    public static let toggleSource = """
    tell application "System Events"
        tell appearance preferences
            set dark mode to not dark mode
            return dark mode
        end tell
    end tell
    """

    /// Runs an AppleScript source and returns its boolean result. Injectable
    /// so tests do not need Automation permission.
    public typealias ScriptRunner = (String) -> Bool?

    private let runner: ScriptRunner

    public init(runner: @escaping ScriptRunner = AppearanceController.runInSystemEvents) {
        self.runner = runner
    }

    /// Flips the appearance and returns the new mode.
    public func toggle() throws -> AppearanceMode {
        guard let isDark = runner(Self.toggleSource) else {
            throw Failure.scriptFailed
        }
        return isDark ? .dark : .light
    }

    /// Runs the script through `NSAppleScript`, exactly like the app does.
    public static func runInSystemEvents(_ source: String) -> Bool? {
        guard let script = NSAppleScript(source: source) else { return nil }
        var error: NSDictionary?
        let result = script.executeAndReturnError(&error)
        guard error == nil else { return nil }
        return result.booleanValue
    }
}
