//
//  ArrayExtention.swift
//  BaseKit
//
//  Created by chen on 2020/5/25.
//  Copyright © 2020 chen. All rights reserved.
//

import Foundation

extension Array {
    public func getOrNil(_ index: Int) -> Iterator.Element? {
        count > index && index >= 0 ? self[index] : nil
    }
    // 去重
    public // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

public struct FixedSizeArray<T> {
  private var maxSize: Int
  private var defaultValue: T
  private var array: [T]
  private (set) var count = 0
  
  public init(maxSize: Int, defaultValue: T) {
    self.maxSize = maxSize
    self.defaultValue = defaultValue
    self.array = [T](repeating: defaultValue, count: maxSize)
  }
  
  public subscript(index: Int) -> T {
    assert(index >= 0)
    assert(index < count)
    return array[index]
  }
  
  public mutating func append(_ newElement: T) {
    assert(count < maxSize)
    array[count] = newElement
    count += 1
  }
  
  public mutating func removeAt(index: Int) -> T {
    assert(index >= 0)
    assert(index < count)
    count -= 1
    let result = array[index]
    array[index] = array[count]
    array[count] = defaultValue
    return result
  }
  
  public mutating func removeAll() {
    for i in 0..<count {
      array[i] = defaultValue
    }
    count = 0
  }
}
