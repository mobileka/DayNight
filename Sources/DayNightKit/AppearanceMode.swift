import Foundation

/// Light or dark system appearance.
public enum AppearanceMode: String, Equatable, CaseIterable {
    case light
    case dark

    public var toggled: AppearanceMode {
        self == .dark ? .light : .dark
    }

    /// `AppleInterfaceStyle` is `"Dark"` in dark mode and missing (or
    /// `"Light"`) otherwise.
    public static func fromAppleInterfaceStyle(_ value: String?) -> AppearanceMode {
        value == "Dark" ? .dark : .light
    }
}

/// Reads the current appearance from user defaults.
public enum SystemAppearance {
    public static let interfaceStyleKey = "AppleInterfaceStyle"

    public static func current(in defaults: UserDefaults = .standard) -> AppearanceMode {
        AppearanceMode.fromAppleInterfaceStyle(defaults.string(forKey: interfaceStyleKey))
    }
}
