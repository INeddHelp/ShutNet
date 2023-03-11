import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let frame = CGRect(x: 0, y: 0, width: 480, height: 272)
        window = NSWindow(contentRect: frame, styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView], backing: .buffered, defer: false)
        window.title = "ShutNet"
        window.center()
        window.contentView = NSView(frame: frame)

        let label = NSTextField(frame: NSMakeRect(20, 20, 200, 40))
        label.stringValue = "Scanning network for computers..."
        window.contentView?.addSubview(label)

        runScript()

        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {}

    func runScript() {
        var ipAddresses: [String] = []

        for i in 1...254 {
            let ip = "192.168.1.\(i)"
            let task = Process()
            task.launchPath = "/usr/bin/env"
            task.arguments = ["ping", "-c", "1", "-W", "1", ip]

            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe

            task.launch()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let pingResult = String(data: data, encoding: .utf8) ?? ""

            if pingResult.contains("1 received") {
                ipAddresses.append(ip)
            }
        }

        let filePath = "Ips.txt"
        let fileUrl = URL(fileURLWithPath: filePath)
        let ipData = ipAddresses.joined(separator: "\n")
        try? ipData.write(to: fileUrl, atomically: true, encoding: .utf8)

        for ip in ipAddresses {
            let task = Process()
            task.launchPath = "/usr/bin/env"
            task.arguments = ["ping", "-c", "1", "-W", "1", ip]

            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe

            task.launch()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let pingResult = String(data: data, encoding: .utf8) ?? ""

            if pingResult.contains("1 received") {
                let task2 = Process()
                task2.launchPath = "/usr/bin/env"
                task2.arguments = ["nslookup", ip]

                let pipe2 = Pipe()
                task2.standardOutput = pipe2
                task2.standardError = pipe2

                task2.launch()

                let data2 = pipe2.fileHandleForReading.readDataToEndOfFile()
                let nslookupResult = String(data: data2, encoding: .utf8) ?? ""
                let computerName = nslookupResult.components(separatedBy: "name = ")[safe: 1]?.components(separatedBy: ".")[safe: 0]

                if let computerName = computerName {
                    let task3 = Process()
                    task3.launchPath = "/usr/bin/env"
                    task3.arguments = ["ssh", "\(computerName)", "shutdown", "-h", "now"]
                    task3.launch()
                } else {
                    print("Could not resolve computer name for IP address \(ip)")
                }
            }
        }
    }
}
