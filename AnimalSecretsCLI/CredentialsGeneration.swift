//
//  CredentialsGeneration.swift
//  AnimalSecretsCLI
//
//  Created by Rinat Abidullin on 05.04.2022.
//

import ArgumentParser
import Foundation

struct CredentialsGeneration: ParsableCommand {
    static var configuration: CommandConfiguration {
        .init(
            commandName: "generate",
            abstract: "Загрузка credentials из удаленного репозитория и генерация файла для iOS-проекта"
        )
    }
    
    @Option var gitSource: String
    
    func run() throws {
        let rmOutput: String? = try shell(
            launchPath: "/bin/rm",
            [
                "-rf",
                "AnimalSecretsRepo"
            ]
        )
        
        let gitOutput: String? = try shell(
            launchPath: "/usr/bin/git",
            [
                "clone",
                gitSource
            ]
        )
        
        let keyFilepath = "AnimalSecretsRepo/keys"
        
        guard let content = try? String(contentsOfFile: keyFilepath, encoding: .utf8) else {
            throw CommandError.with(info: "The key file was not found on the passed path")
        }
        
        if let value = ProcessInfo.processInfo.environment["CONFIGURATION"] {
            print("// Configuration is: \(value)")
        }
        
        let key = content.components(separatedBy: "=")[1]
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("\nlet ANIMAL_SECRET_KEY = \"\(key)\"")
    }
}
