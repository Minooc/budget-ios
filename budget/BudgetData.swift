//
//  BudgetData.swift
//  budget
//
//  Created by Minooc Choo on 8/22/17.
//  Copyright © 2017 Minooc Choo. All rights reserved.
//

import Foundation

class budgetData: NSObject, NSCoding {

    var _desField: String = ""
    var _valField: String = ""
    
    var desField: String {
        return _desField
    }
    
    var valField: String {
        return _valField
    }
    
    init(des: String, val: String) {
        self._desField = des
        self._valField = val
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self._desField, forKey: "Description")
        aCoder.encode(self._valField, forKey: "Value")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let storedDes = aDecoder.decodeObject(forKey: "Description") as? String
        let storedVal = aDecoder.decodeObject(forKey: "Value") as? String
        
        guard storedDes != nil && storedVal != nil else {
            return nil
        }
        
        self.init(des: storedDes!, val: storedVal!)
    }
    
    func configureCell(valField: String, desField: String) {
        self._desField = desField
        let roundedValField = round(Double(valField)! * 100)/100
        self._valField = "\(roundedValField)"
    }
    
}
