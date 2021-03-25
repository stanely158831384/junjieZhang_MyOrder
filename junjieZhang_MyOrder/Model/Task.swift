//
//  Task.swift
//  junjieZhang_MyOrder
//
//  Created by Junjie Zhang on 2021-02-15.
//

import Foundation

class Task{
    public var coffeeType: String
    public var coffeeSize: String
    public var coffeeQTY: String
    
    init(coffeeT: String, coffeeS: String, coffeeQ: String){
        self.coffeeType = coffeeT
        self.coffeeSize = coffeeS
        self.coffeeQTY = coffeeQ
    }
}

