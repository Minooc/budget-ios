//
//  TableCell.swift
//  budget
//
//  Created by Minooc Choo on 8/21/17.
//  Copyright © 2017 Minooc Choo. All rights reserved.
//

import UIKit

class IncomeTableCell: UITableViewCell  {

    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var incomeValue: UILabel!
    
    func configure(budget: budgetData) {
        incomeLbl.text = budget.desField
        incomeValue.text = "\(budget.valField)"
    }
    
}

class ExpenseTableCell: UITableViewCell  {

    @IBOutlet weak var expenseLbl: UILabel!
    @IBOutlet weak var expenseValue: UILabel!
    
    func configure(budget: budgetData) {
        expenseLbl.text = budget.desField
        expenseValue.text = "\(budget.valField)"
    }
    
}

