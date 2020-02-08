//
//  Stack.swift
//  Chess
//
//  Created by dimitris paidarakis on 1/2/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import Foundation

struct Stack<T: Hashable & CustomStringConvertible>: Equatable {
    private var array: [T] = []
    private var set: Set<T> = []
    
    var count: Int {
        return array.count
    }
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    mutating func push(_ element: T) {
        if !set.contains(element) {
            set.insert(element)
            array.append(element)
        }
    }
    
    mutating func pop() -> T? {
        let element = array.popLast()
        if element != nil {
            set.remove(element!)
        }
        return element
    }
    
    func peek() -> T? {
        return array.last
    }
    
    func contains(element: T) -> Bool {
        return set.contains(element)
    }
}

extension Stack: CustomStringConvertible {
  var description: String {
    let stackElements = array.reduce("") { (res, element) -> String in
        return res == "" ? element.description : res + " - " + element.description
    }
    return stackElements
  }
}
