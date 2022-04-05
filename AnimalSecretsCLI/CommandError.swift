//
//  CommandError.swift
//  AnimalSecretsCLI
//
//  Created by Rinat Abidullin on 04.04.2022.
//

import Foundation

enum CommandError: LocalizedError {
    case with(info: String)

    public var errorDescription: String? {
        switch self {
        case .with(let info):
            return info
        }
    }
}
