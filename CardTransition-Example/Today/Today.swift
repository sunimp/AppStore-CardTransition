//
//  Today.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import Foundation

struct Today: Codable, Hashable {
    let events: [Event]
}

struct Event: Codable, Hashable {
    
    enum `Type`: String, Codable {
        case cover = "COVER"
        case list = "LIST"
    }
    
    enum State: String, Codable {
        case ongoing = "ONGOING"
        case normal = "NORMAL"
        case available = "AVAILABLE"
        
        var displayTitle: String? {
            switch self {
            case .ongoing:
                return "正在进行"
            case .available:
                return "现已推出"
            case .normal:
                return nil
            }
        }
    }
    
    let id: String
    let type: `Type`
    let state: State
    let title: String
    let name: String
    let tagline: String
    let cover: String
    let introduce: Introduce?
    let items: [App]
}

struct Introduce: Codable, Hashable {
    
    enum ContentType: String, Codable, Hashable {
        case text = "TEXT"
        case image = "IMAGE"
    }
    
    struct Content: Codable, Hashable {
        let type: ContentType
        let value: String
    }
    
    let title: String?
    let contents: [Content]
}

struct App: Codable, Hashable {
    let id: String
    let icon: String
    let name: String
    let tagline: String
    let iap: Bool
}

extension Bundle {
    
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}
