import Testing

@testable import DayNightKit

@Suite("Appearance mode")
struct AppearanceModeTests {
    @Test func togglesBetweenLightAndDark() {
        #expect(AppearanceMode.light.toggled == .dark)
        #expect(AppearanceMode.dark.toggled == .light)
    }

    @Test func readsAppleInterfaceStyle() {
        #expect(AppearanceMode.fromAppleInterfaceStyle("Dark") == .dark)
        #expect(AppearanceMode.fromAppleInterfaceStyle("Light") == .light)
        #expect(AppearanceMode.fromAppleInterfaceStyle(nil) == .light)
        #expect(AppearanceMode.fromAppleInterfaceStyle("Unexpected") == .light)
    }

    @Test func rawValuesMatchTheCLIOutput() {
        #expect(AppearanceMode.dark.rawValue == "dark")
        #expect(AppearanceMode.light.rawValue == "light")
    }
}

@Suite("Appearance controller")
struct AppearanceControllerTests {
    @Test func reportsTheModeTheScriptReturned() throws {
        #expect(try AppearanceController(runner: { _ in true }).toggle() == .dark)
        #expect(try AppearanceController(runner: { _ in false }).toggle() == .light)
    }

    @Test func runsTheToggleScript() throws {
        var seen: String?
        let controller = AppearanceController(runner: { source in
            seen = source
            return true
        })
        _ = try controller.toggle()
        #expect(seen == AppearanceController.toggleSource)
    }

    @Test func throwsWhenSystemEventsRefuses() {
        let controller = AppearanceController(runner: { _ in nil })
        #expect(throws: AppearanceController.Failure.scriptFailed) {
            try controller.toggle()
        }
    }

    @Test func toggleScriptFlipsDarkMode() {
        #expect(AppearanceController.toggleSource.contains("set dark mode to not dark mode"))
        #expect(AppearanceController.toggleSource.contains("appearance preferences"))
    }
}

@Suite("Launch action")
struct LaunchActionTests {
    @Test func plainLaunchRunsTheApp() {
        #expect(LaunchAction.resolve(arguments: ["/Applications/DayNight.app/Contents/MacOS/DayNight"]) == .runApp)
    }

    @Test func statusPrintsTheCurrentMode() {
        let action = LaunchAction.resolve(arguments: ["DayNight", "--status"], currentMode: { .dark })
        #expect(action == .printStatus(.dark))
    }

    @Test func toggleWinsOverStatus() {
        let action = LaunchAction.resolve(arguments: ["DayNight", "--toggle", "--status"], currentMode: { .light })
        #expect(action == .toggle)
    }
}
