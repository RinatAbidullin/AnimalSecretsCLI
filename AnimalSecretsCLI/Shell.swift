//
//  File.swift
//  
//
//  Created by Rinat Abidullin on 14.08.2021.
//

import Foundation

enum ShellError: LocalizedError {
    case with(info: String)

    public var errorDescription: String? {
        switch self {
        case .with(let info):
            return info
        }
    }
}

// wrapper function for shell commands
// must provide full path to executable
func shell(launchPath: String, _ arguments: [String] = []) -> (String?, Int32) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: launchPath)
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    do {
        try task.run()
    } catch {
        // handle errors
        print("Error: \(error.localizedDescription)")
        return (nil, 1)
    }
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)
    
    task.waitUntilExit()
    return (output, task.terminationStatus)
}

// Wrapper function for shell commands
// Must provide full path to executable
func shell(launchPath: String, _ arguments: [String] = []) throws -> String? {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: launchPath)
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    
    try task.run()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)
    
    task.waitUntilExit()
    
    if task.terminationStatus != 0 {
        throw ShellError.with(info: output ?? "Unknown error")
    }
    
    return output
}

func shell(command: String, _ arguments: [String] = []) -> (String?, Int32) {
    let (output, status) = shell(launchPath: "/usr/bin/type", [command])
    
    if status == 0 {
        if let commandPath = output?.replacingOccurrences(of: "\(command) is ", with: "").trimmingCharacters(in: .newlines) {
            return shell(launchPath: commandPath, arguments)
        }
    }
    
    return ("Error: cant find command '\(command)'", 1)
}

struct ShellCommandPath {
    static var xcrun: String? = {
        return fullPath(for: "xcrun")
    }()
    
    static func fullPath(for command: String) -> String? {
        let (output, status) = shell(launchPath: "/usr/bin/type", [command])
        if status == 0 {
            if let commandPath = output?
                .replacingOccurrences(of: "\(command) is ", with: "")
                .trimmingCharacters(in: .newlines)
            {
                return commandPath
            }
        }
        return nil
    }
}
