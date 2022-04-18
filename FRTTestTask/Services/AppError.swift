//
//  AppError.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 16.04.22.
//

import Foundation
import CoreVideo

enum AppError: Error {
    case blankUsername
    case blankRepositoryName
    case blankRepository
    case cantGenerateURL
    case invalidURL
    case unknownError
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .blankUsername:
            return "Username is empty."
        case .cantGenerateURL:
            return "Can't generate URL."
        case .invalidURL:
            return "URL is invalid."
        case .blankRepositoryName:
            return "Repository name not specified."
        case .blankRepository:
            return "Repository data not specified."
        case .unknownError:
            return "Unknown error, please contact support."
        }
    }
}
