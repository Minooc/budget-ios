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
    
    var type = ""
    
    var currentMonth = "January"
    var month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !initialize {
            Manager.instance.initializeData()
            initialize = true
        }
        
        monthPickerBtn.setTitle(currentMonth, for: .normal)
        currentMonthLbl.text = "Available Budget in \(currentMonth):"
        
        
        monthPicker.delegate = self
        monthPicker.dataSource = self
        
        incomeTableView.delegate = self
        incomeTableView.dataSource = self
        
        expenseTableView.delegate = self
        expenseTableView.dataSource = self
        
        updateBudgetView()
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
            let incArray = Manager.instance.getIncomeArray(currentMonth: currentMonth)
            return incArray.count
        } else {
            let expArray = Manager.instance.getExpenseArray(currentMonth: currentMonth)
            return expArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView.isEqual(incomeTableView)) {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "incomeTableCell", for: indexPath) as? IncomeTableCell {
                
                let budget: budgetData!
                let x = Manager.instance.getIncomeArray(currentMonth: currentMonth)
            
                if (!x.isEmpty) {
                budget = x[indexPath.row]
                cell.configure(budget: budget)
                }
                
                return cell
            } else {
                return UITableViewCell()
            }
        
        } else {

            if let cell = tableView.dequeueReusableCell(withIdentifier: "expenseTableCell", for: indexPath) as? ExpenseTableCell {

                var budget: budgetData!
                let x = Manager.instance.getExpenseArray(currentMonth: currentMonth)

                if (!x.isEmpty) {
                    budget = x[indexPath.row]
                    cell.configure(budget: budget)
                }

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
                
                let x = Manager.instance.getIncomeArray(currentMonth: currentMonth)
                let budget = x[indexPath.row]
                subtractBudget(thisBudget: budget)
                
                Manager.instance.removeIncome(currentMonth: currentMonth, indexPath: indexPath)
                incomeTableView.reloadData()
                
                
            }
            else if (tableView.dequeueReusableCell(withIdentifier: "expenseTableCell") as? ExpenseTableCell) != nil {
                type = "Expense"
                
                let x = Manager.instance.getExpenseArray(currentMonth: currentMonth)
                let budget = x[indexPath.row]
                subtractBudget(thisBudget: budget)
                
                Manager.instance.removeExpense(currentMonth: currentMonth, indexPath: indexPath)
                expenseTableView.reloadData()
            }
            
            updateBudgetView()
            
        }
    }
    
    
    
    
    //segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? AddValueController
        
        nextVC?.currentMonth = self.currentMonth
    }
    
    
    
    // Calculate budget
    
    func calculateBudget(thisBudget: budgetData) {
        
        print(thisBudget._valField)
        
        if (type == "Income") {
            var newIncome = Manager.instance.getTotalIncome(currentMonth: currentMonth)
            newIncome = newIncome + Double(thisBudget.valField)!
            newIncome = round(newIncome * 100) / 100
            print(currentMonth)
            Manager.instance.setTotalIncome(totalIncome: newIncome, currentMonth: currentMonth)
            
            
        } else if (type == "Expense") {
            var newExpense = Manager.instance.getTotalExpense(currentMonth: currentMonth)
            newExpense += Double(thisBudget.valField)!
            newExpense = round(newExpense * 100) / 100
            Manager.instance.setTotalExpense(totalExpense: newExpense, currentMonth: currentMonth)
            
        }
        
        var newTotalBudget = Manager.instance.getTotalIncome(currentMonth: currentMonth) - Manager.instance.getTotalExpense(currentMonth: currentMonth)

        newTotalBudget = round(newTotalBudget * 100) / 100
        Manager.instance.setTotalBudget(totalBudget: newTotalBudget, currentMonth: currentMonth)

        
    }
    
    func subtractBudget(thisBudget: budgetData) {
        
        if (type == "Income") {
            var newIncome = Manager.instance.getTotalIncome(currentMonth: currentMonth)
            newIncome -= Double(thisBudget.valField)!
            newIncome = round(newIncome * 100) / 100
            Manager.instance.setTotalIncome(totalIncome: newIncome, currentMonth: currentMonth)
            
        } else if (type == "Expense") {
            var newExpense = Manager.instance.getTotalExpense(currentMonth: currentMonth)
            newExpense -= Double(thisBudget.valField)!
            newExpense = round(newExpense * 100) / 100
            Manager.instance.setTotalExpense(totalExpense: newExpense, currentMonth: currentMonth)
            
        }
        
        var newTotalBudget = Manager.instance.getTotalIncome(currentMonth: currentMonth) - Manager.instance.getTotalExpense(currentMonth: currentMonth)
        newTotalBudget = round(newTotalBudget * 100) / 100
        
        Manager.instance.setTotalBudget(totalBudget: newTotalBudget, currentMonth: currentMonth)
        
        
    }
    
    
    // update View
    
    func updateBudgetView() {
        totalIncomeLbl?.text = "+\(Manager.instance.getTotalIncome(currentMonth: currentMonth))"
        totalExpenseLbl?.text = "-\(Manager.instance.getTotalExpense(currentMonth: currentMonth))"
        if (Manager.instance.getTotalBudget(currentMonth: currentMonth) >= 0) {
            totalBudgetLbl?.text = "+\(Manager.instance.getTotalBudget(currentMonth: currentMonth))"
        }
        else {
            totalBudgetLbl?.text = "\(Manager.instance.getTotalBudget(currentMonth: currentMonth))"
        }
    }
    
    
    
    
}
