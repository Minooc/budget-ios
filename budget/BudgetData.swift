//
//  BudgetData.swift
//  budget
//
//  Created by Minooc Choo on 8/22/17.
//  Copyright © 2017 Minooc Choo. All rights reserved.
//

import Foundation

class budgetData {
    
    var _desField: String = ""
    var _valField: String = ""
    
    var desField: String {
        return _desField
    }
    
    var valField: String {
        return _valField
    }
    
    init() {}
    
    func configureCell(valField: String, desField: String) {
        self._desField = desField
        let roundedValField = round(Double(valField)! * 100)/100
        self._valField = "\(roundedValField)"
    }
    
//    var name: String
//    var value: String
    
    
}
