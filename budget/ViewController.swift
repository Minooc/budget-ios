//
//  ViewController.swift
//  budget
//
//  Created by Minooc Choo on 8/20/17.
//  Copyright © 2017 Minooc Choo. All rights reserved.
//

import UIKit

var initialize = false

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var totalExpenseLbl: UILabel!
    @IBOutlet weak var totalIncomeLbl: UILabel!
    @IBOutlet weak var totalBudgetLbl: UILabel!
    @IBOutlet weak var monthPicker: UIPickerView!
    @IBOutlet weak var monthPickerBtn: UIButton!
    @IBOutlet weak var currentMonthLbl: UILabel!
    @IBOutlet weak var incomeTableView: UITableView!
    @IBOutlet weak var expenseTableView: UITableView!


    var budgetdata: budgetData!
    
    var incomeArray: [String:[budgetData]] = [:]
    var expenseArray: [String:[budgetData]] = [:]
    
    var type = ""
    var totalIncome: [String:Double] = [:]
    var totalExpense: [String:Double] = [:]
    var totalBudget: [String:Double] = [:]
    

    var currentMonth = "January"
    var month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        monthPickerBtn.setTitle(currentMonth, for: .normal)
        currentMonthLbl.text = "Available Budget in \(currentMonth):"
        
        if initialize == false {
            // Perform an action that will only be done once
            initailizeData()
            initialize = true
        }
        
        
        monthPicker.delegate = self
        monthPicker.dataSource = self
        
        incomeTableView.delegate = self
        incomeTableView.dataSource = self
        
        expenseTableView.delegate = self
        expenseTableView.dataSource = self

        updateBudgetView()
    }
    
    func initailizeData() {
        for i in 0...month.count-1 {
            incomeArray[month[i]] = []
            expenseArray[month[i]] = []
            totalIncome[month[i]] = 0.0
            totalExpense[month[i]] = 0.0
            totalBudget[month[i]] = 0.0
        }
    }

    
    
    /* UI Picker View */
    
    @IBAction func monthBtnPressed(_ sender: Any) {
        monthPicker.isHidden = false
        monthPickerBtn.isHidden = true
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return month.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return month[row]
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        monthPickerBtn.setTitle(month[row], for: UIControlState.normal)
        monthPicker.isHidden = true
        monthPickerBtn.isHidden = false
        currentMonth = month[row]
        monthPickerBtn.titleLabel?.text = currentMonth
        incomeTableView.reloadData()
        expenseTableView.reloadData()
        updateBudgetView()
        currentMonthLbl.text = "Available Budget in \(currentMonth):"
        
    }
    
    
    /* UITableView */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1    // need 1 section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.isEqual(incomeTableView)) {
            return incomeArray[currentMonth]!.count
        } else {
            return expenseArray[currentMonth]!.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView.isEqual(incomeTableView)) {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "incomeTableCell", for: indexPath) as? IncomeTableCell {
                
                let budget: budgetData!
                let x = incomeArray[currentMonth]
                budget = x?[indexPath.row]
                cell.configure(budget: budget)
                
                return cell
            } else {
                return UITableViewCell()
            }

        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "expenseTableCell", for: indexPath) as? ExpenseTableCell {
                
                var budget: budgetData!
                let x = expenseArray[currentMonth]
                budget = x?[indexPath.row]
                cell.configure(budget: budget)
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
    
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if (tableView.dequeueReusableCell(withIdentifier: "incomeTableCell") as? IncomeTableCell) != nil {
                type = "Income"
                
                let x = incomeArray[currentMonth]!
                let budget = x[indexPath.row]
                subtractBudget(thisBudget: budget)
                incomeArray[currentMonth]!.remove(at: indexPath.item)
                incomeTableView.reloadData()


            }
            else if (tableView.dequeueReusableCell(withIdentifier: "expenseTableCell") as? ExpenseTableCell) != nil {
                type = "Expense"
                
                let x = expenseArray[currentMonth]!
                let budget = x[indexPath.row]
                subtractBudget(thisBudget: budget)
                expenseArray[currentMonth]!.remove(at: indexPath.item)
                expenseTableView.reloadData()
            }
            
            updateBudgetView()

        }
    }
    
    
    
    
    //segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? AddValueController
        nextVC?.incomeArray = self.incomeArray
        nextVC?.expenseArray = self.expenseArray
        
        nextVC?.totalIncome = self.totalIncome
        nextVC?.totalExpense = self.totalExpense
        nextVC?.totalBudget = self.totalBudget
        
        nextVC?.currentMonth = self.currentMonth
    }
    
    
    
    // Calculate budget
    
    func calculateBudget(thisBudget: budgetData) -> [Double] {
        
        if (type == "Income") {
            var newIncome = totalIncome[currentMonth]!
            newIncome += Double(thisBudget.valField)!
            newIncome = round(newIncome * 100) / 100
            totalIncome.updateValue(newIncome, forKey: currentMonth)


        } else if (type == "Expense") {
            var newExpense = totalExpense[currentMonth]!
            newExpense += Double(thisBudget.valField)!
            newExpense = round(newExpense * 100) / 100
            totalExpense.updateValue(newExpense, forKey: currentMonth)
            
        }
        
        totalBudget[currentMonth] = totalIncome[currentMonth]! - totalExpense[currentMonth]!
        totalBudget[currentMonth] = round(totalBudget[currentMonth]! * 100) / 100
 
        let ret : [Double] = [totalIncome[currentMonth]!, totalExpense[currentMonth]!, totalBudget[currentMonth]!]
        return ret
    }
    
    func subtractBudget(thisBudget: budgetData) {
        
        if (type == "Income") {
            var newIncome = totalIncome[currentMonth]!
            newIncome -= Double(thisBudget.valField)!
            newIncome = round(newIncome * 100) / 100
            totalIncome.updateValue(newIncome, forKey: currentMonth)
            
        } else if (type == "Expense") {
            var newExpense = totalExpense[currentMonth]!
            newExpense -= Double(thisBudget.valField)!
            newExpense = round(newExpense * 100) / 100
            totalExpense.updateValue(newExpense, forKey: currentMonth)
            
        }
        
        totalBudget[currentMonth] = totalIncome[currentMonth]! - totalExpense[currentMonth]!
        totalBudget[currentMonth] = round(totalBudget[currentMonth]! * 100) / 100
        
        
    }
    
    
    // update View
    
    func updateBudgetView() {
        totalIncomeLbl?.text = "+\(totalIncome[currentMonth]!)"
        totalExpenseLbl?.text = "-\(totalExpense[currentMonth]!)"
        if (totalBudget[currentMonth]! >= 0) {
            totalBudgetLbl?.text = "+\(totalBudget[currentMonth]!)"
        }
        else {
            totalBudgetLbl?.text = "\(totalBudget[currentMonth]!)"
        }
    }
 



}

