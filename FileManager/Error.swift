//
//  Error.swift
//  FileManager
//
//  Created by Maxim Shelepyuk on 24/03/2019.
//  Copyright © 2019 Maxim Shelepyuk. All rights reserved.
//

import Foundation

extension FileStorage {
    
    enum Error: LocalizedError, Equatable {
        case notExist
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .notExist:
                return "File not exist"
            case .unknown:
                return "Unknown error"
            }
        }
        
        var localizedDescription: String {
            return errorDescription ?? ""
        }
    }
}
