//
//  Occupiable.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/21.
//

import Foundation

public protocol Occupiable {
    
    var isEmpty: Bool { get }
    var isNotEmpty: Bool { get }
}

extension Occupiable {
    
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String: Occupiable { }
extension Array: Occupiable { }
extension Dictionary: Occupiable { }
extension Set: Occupiable { }

extension NSIndexSet: Occupiable {
    
    public var isEmpty: Bool {
        return self.count > 0
    }
}
