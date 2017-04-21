//
//  HistoryData.swift
//  SmashTag
//
//  Created by Sami Rämö on 19/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import Foundation

struct HistoryData {
    
    private let userDefaults = UserDefaults.standard
    
    var maxNumberOfItemsStored: Int {
        get {
            if userDefaults.integer(forKey: "historySize") > 0 {
                return userDefaults.integer(forKey: "historySize")
            } else {
                userDefaults.register(defaults: ["historySize" : 100])
                return 100 // default value
            }
        }
        set {
            if newValue < maxNumberOfItemsStored {
                var newArray = [String]()
                if let oldArray = data {
                    if oldArray.count > newValue {
                        for i in 0..<newValue {
                            newArray.append(oldArray[i])
                        }
                        userDefaults.set(newArray, forKey: "historyData")
                    }
                }
            }
            userDefaults.set(newValue, forKey: "historySize")
        }
    }

    var data: [String]? {
        get {
            return userDefaults.array(forKey: "historyData") as? [String]
        }
    }
    
    func add(_ item: String) {
        if data == nil {
            userDefaults.register(defaults: ["historyData" : [item]])
        } else {
            if var tempArray = data {
                if tempArray.contains(item) {
                    let index = tempArray.index(of: item)!
                    tempArray.remove(at: index)
                    tempArray.insert(item, at: 0)
                } else {
                    tempArray.insert(item, at: 0)
                    if tempArray.count > maxNumberOfItemsStored {
                        tempArray.removeLast()
                    }
                }
                userDefaults.set(tempArray, forKey: "historyData")
            }
        }
        userDefaults.synchronize()
        print("userDefaults historyData = \(String(describing: userDefaults.array(forKey: "historyData")))")
    }
    
}
