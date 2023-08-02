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
    case NotWorkOutError
    var errorDescription: String? {
        switch self {
        case.CreateError:
            return NSLocalizedString("Can not create exercise.", comment: "create error")
        case.DuplicateError:
            return NSLocalizedString("Exercise already exists", comment: "duplicate error")
        case.ReadError:
            return NSLocalizedString("Can not read exercises", comment: "read error")
        case.NotWorkOutError:
            return NSLocalizedString("Can not work out", comment: "work out error")
        }
    }
    var failureReason: String? {
        switch self {
        case.CreateError:
            return NSLocalizedString("Include empty value", comment: "create error reason")
        case.DuplicateError:
            return NSLocalizedString("Include duplicate value", comment: "duplicate error reason")
        case.ReadError:
            return NSLocalizedString("Incorrect entity name or key", comment: "duplicate error reason")
        case.NotWorkOutError:
            return NSLocalizedString("Inculde incorrect value (set, rest ...)", comment: "work out error reason")
        }
    }
}

enum WorkOutError: LocalizedError {
    case RecordError
    var errorDescription: String? {
        switch self {
        case.RecordError:
            return NSLocalizedString("Can not recode work out value.", comment: "record error")
        }
    }
    var failureReason: String? {
        switch self {
        case.RecordError:
            return NSLocalizedString("Inculde incorrect value (weight, reps ...)", comment: "recode error reason")
        }
    }
}

enum RoutineError: LocalizedError {
    case CreateError
    case EmptyCreateError
    case DuplicateError
    case ReadExerciseError
    case ReadError
    case NotWorkOutError
    var errorDescription: String? {
        switch self {
        case.CreateError:
            return NSLocalizedString("Can not create routine.", comment: "create error")
        case.EmptyCreateError:
            return NSLocalizedString("Can not create routine.", comment: "create error")
        case.DuplicateError:
            return NSLocalizedString("Routine already exists", comment: "duplicate error")
        case.ReadExerciseError:
            return NSLocalizedString("Can not read exercise", comment: "read error")
        case.ReadError:
            return NSLocalizedString("Can not read routines", comment: "read error")
        case.NotWorkOutError:
            return NSLocalizedString("Can not work out", comment: "work out error")
        }
    }
    var failureReason: String? {
        switch self {
        case.CreateError:
            return NSLocalizedString("Include incorrect value (exercist.set, rest ...)", comment: "create error reason")
        case.EmptyCreateError:
            return NSLocalizedString("Include empty value (name, exercise ...)", comment: "create error reason")
        case.DuplicateError:
            return NSLocalizedString("Include duplicate value", comment: "duplicate error reason")
        case.ReadExerciseError:
            return NSLocalizedString("Include incorrect exercise key", comment: "read error reason")
        case.ReadError:
            return NSLocalizedString("Incorrect entity name or key", comment: "read error reason")
        case.NotWorkOutError:
            return NSLocalizedString("Inculde incorrect routine value", comment: "work out error reason")
        }
    }
}
