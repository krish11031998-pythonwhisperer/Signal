//
//  CommonWrappers.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 13/11/2022.
//

import Foundation
import UIKit

@propertyWrapper
public enum Lazy<Value> {
    case uninitialized(() -> Value)
    case initialized(Value)

    public init(wrappedValue: @autoclosure @escaping () -> Value) {
        self = .uninitialized(wrappedValue)
    }

    public var wrappedValue: Value {
        mutating get {
            switch self {
            case .uninitialized(let initializer):
                let value = initializer()
                self = .initialized(value)
                return value
            case .initialized(let value):
                return value
            }
        }
        set {
            self = .initialized(newValue)
        }
    }
}

public func configure<Value>(_ value: Value, _ closure: (Value) -> Void) -> Value {
    closure(value)
    return value
}
