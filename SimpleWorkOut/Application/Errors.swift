//
//  Errors.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/25.
//

import Foundation

enum ExerciseError: LocalizedError {
    case CreateError
    case DuplicateError
    case ReadError
    var errorDescription: String? {
        switch self {
        case.CreateError:
            return NSLocalizedString("Can not create exercise.", comment: "create error")
        case.DuplicateError:
            return NSLocalizedString("Exercise already exists", comment: "duplicate error")
        case.ReadError:
            return NSLocalizedString("Can not read exercises", comment: "read error")
        }
    }
    var failureReason: String? {
        switch self {
        case.CreateError:
            return NSLocalizedString("Inclued empty value", comment: "create error reason")
        case.DuplicateError:
            return NSLocalizedString("Inclued duplicate value", comment: "duplicate error reason")
        case.ReadError:
            return NSLocalizedString("Incorrect entity name or key", comment: "duplicate error reason")
        }
    }
}
