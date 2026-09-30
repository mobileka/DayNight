import AppKit
import DayNightKit

@main
enum DayNightApp {
    static func main() {
        switch LaunchAction.resolve(arguments: CommandLine.arguments) {
        case .runApp:
            let app = NSApplication.shared
            let delegate = AppDelegate()
            app.delegate = delegate
            app.setActivationPolicy(.accessory)
            app.run()

        case .printStatus(let mode):
            print(mode.rawValue)

        case .toggle:
            do {
                let mode = try AppearanceController().toggle()
                print(mode.rawValue)
            } catch {
                FileHandle.standardError.write(Data("error: could not change appearance (permission?)\n".utf8))
                exit(1)
            }
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let controller = AppearanceController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.target = self
            button.action = #selector(handleClick)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        updateIcon()

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(themeChanged),
            name: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil
        )
    }

    @objc private func themeChanged() {
        DispatchQueue.main.async { self.updateIcon() }
    }

    private func updateIcon() {
        let dark = SystemAppearance.current() == .dark
        let image = NSImage(
            systemSymbolName: dark ? "moon.fill" : "sun.max",
            accessibilityDescription: dark ? "Dark appearance, click for light" : "Light appearance, click for dark"
        )
        image?.isTemplate = true
        statusItem.button?.image = image
        statusItem.button?.toolTip = dark ? "DayNight: switch to Light" : "DayNight: switch to Dark"
    }

    @objc private func handleClick() {
        if NSApp.currentEvent?.type == .rightMouseUp {
            showMenu()
        } else {
            doToggle()
        }
    }

    @objc private func doToggle() {
        do {
            _ = try controller.toggle()
        } catch {
            showPermissionAlert()
        }
        updateIcon()
    }

    private func showMenu() {
        let menu = NSMenu()
        let toggle = NSMenuItem(title: "Toggle Appearance", action: #selector(doToggle), keyEquivalent: "")
        toggle.target = self
        menu.addItem(toggle)
        menu.addItem(.separator())
        let quit = NSMenuItem(title: "Quit DayNight", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quit)

        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    private func showPermissionAlert() {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = "DayNight needs permission to change appearance"
        alert.informativeText = "Turn on DayNight under System Settings → Privacy & Security → Automation (System Events), then click the icon again."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open Settings")
        alert.addButton(withTitle: "Not Now")
        if alert.runModal() == .alertFirstButtonReturn,
           let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation") {
            NSWorkspace.shared.open(url)
        }
    }
}
