/// What the process should do, based on its arguments.
public enum LaunchAction: Equatable {
    /// Start the menu bar app.
    case runApp
    /// Print the current appearance and exit.
    case printStatus(AppearanceMode)
    /// Flip the appearance, print the new mode and exit.
    case toggle

    /// `--toggle` wins over `--status`, matching the original CLI.
    public static func resolve(
        arguments: [String],
        currentMode: @escaping () -> AppearanceMode = { SystemAppearance.current() }
    ) -> LaunchAction {
        if arguments.contains("--toggle") { return .toggle }
        if arguments.contains("--status") { return .printStatus(currentMode()) }
        return .runApp
    }
}
