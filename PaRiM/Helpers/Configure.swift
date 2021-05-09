//
// Created by Иван Гайдамакин on 09.05.2021.
//

import Foundation

// I used this solution to avoid bugs on some cases instead of "lazy var".
// By "lazy var" I got new address of variable's object on every call to this variable,.

func Configure<T>(_ arg: T, _ closure: ((T) -> Void)? = nil) -> T {
    closure?(arg)
    return arg
}