import Foundation
import SwiftSSH

var ipAddresses: [String] = []

for i in 1...254 {
    let ip = "192.168.1.\(i)"
    print("Scanning \(ip)")
    let task = Process()
    task.launchPath = "/sbin/ping"
    task.arguments = ["-c", "1", "-t", "1", ip]
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    if task.terminationStatus == 0 {
        ipAddresses.append(ip)
    }
}

let fileURL = URL(fileURLWithPath: "Ips.txt")
let ipString = ipAddresses.joined(separator: "\n")
try! ipString.write(to: fileURL, atomically: true, encoding: .utf8)

for ip in ipAddresses {
    print("Shutting down \(ip)")
    guard let computerName = try? SSH(host: ip, username: "username", password: "password").capture("hostname") else {
        print("Could not resolve computer name for IP address \(ip)")
        continue
    }
    let osName = try? SSH(host: ip, username: "username", password: "password").capture("uname")
    if osName?.contains("Windows") == true {
        try? SSH(host: ip, username: "username", password: "password").capture("shutdown.exe /s /t 0")
    } else if osName?.contains("Linux") == true {
        try? SSH(host: ip, username: "username", password: "password").capture("sudo shutdown -h now")
    } else if osName?.contains("Darwin") == true {
        try? SSH(host: ip, username: "username", password: "password").capture("sudo shutdown -h now")
    } else {
        print("Unknown operating system for \(ip)")
    }
}

// Clear the IP addresses file
try? FileManager.default.removeItem(at: fileURL)
