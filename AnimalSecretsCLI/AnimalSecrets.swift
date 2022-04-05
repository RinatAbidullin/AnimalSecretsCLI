//
//  AnimalSecrets.swift
//  AnimalSecretsCLI
//
//  Created by Rinat Abidullin on 05.04.2022.
//

import ArgumentParser
import Foundation

struct AnimalSecrets: ParsableCommand {
    static var configuration: CommandConfiguration {
        .init(
            commandName: "animalsecrets",
            abstract: "Работа с credentials",
            version: "1.0.0",
            subcommands: [
                CredentialsGeneration.self
            ]
        )
    }
}
