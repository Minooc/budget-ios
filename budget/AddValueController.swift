//
//  AddValueController.swift
//  budget
//
//  Created by Minooc Choo on 8/22/17.
//  Copyright © 2017 Minooc Choo. All rights reserved.
//

import UIKit

var initialize2 = false

class AddValueController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var valueLbl: UILabel!
    
    @IBOutlet weak var desField: UITextField!
    @IBOutlet weak var valField: UITextField!
    
    var type = "Income"
    var totalIncome: [String:Double] = [:]
    var totalExpense: [String:Double] = [:]
    var totalBudget: [String:Double] = [:]
    
    var budgetArray: [Double] = []
    
    var currentMonth = "January"
    var month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var incomeArray: [String:[budgetData]] = [:]
    var expenseArray: [String:[budgetData]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (initialize2 == false) {
            initailizeData()
            initialize2 = true
        }
        valField.delegate = self
        valField.keyboardType = .numberPad
        
        valueLbl.text = "0"

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
   
    @IBAction func editValue(_ sender: Any) {
        if (type == "Income") {
            valueLbl.text = "+" + valField.text!
        }
        else if (type == "Expense") {
            valueLbl.text = "-" + valField.text!
        }
        if (valField.text == "") {
            valueLbl.text = "0"
        }
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func incomeBtnPressed(_ sender: Any) {
        bgView.backgroundColor = UIColor(red: 43/255, green: 230/255, blue: 210/255, alpha: 0.8)
        type = "Income"
        
        if (valField.text != "" && valueLbl.text?.characters.first != "+") {
            valueLbl.text = "+" + valField.text!
        }
    }

    @IBAction func expenseBtnPressed(_ sender: Any) {
        bgView.backgroundColor = UIColor(red: 255/255, green: 112/255, blue: 103/255, alpha: 0.8)
        type = "Expense"
        
        if (valField.text != "" && valueLbl.text?.characters.first != "-") {
            valueLbl.text = "-" + valField.text!
        }
    }
    
    // Do not accept any string outside 0 and 9. Source: http://stackoverflow.com/questions/26919854/how-can-i-declare-that-a-text-field-can-only-contain-an-integerd
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }

    
    @IBAction func submitPressed(_ sender: Any) {
        
        if (desField.text != "" && valField.text != "") {
            let budget = budgetData()
            
            budget.configureCell(valField: valField.text!, desField: desField.text!)
            desField.text = ""
            valField.text = ""
            
            if (type == "Income") {
                self.incomeArray[currentMonth]!.append(budget)
            } else if (type == "Expense") {
                self.expenseArray[currentMonth]!.append(budget)
            }
            
            performSegue(withIdentifier: "AddValue", sender: budget)

            
        }
        
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddValue" {
            if let detailsVC = segue.destination as? ViewController {
                if let budget = sender as? budgetData {
                    
                    detailsVC.incomeArray = self.incomeArray
                    detailsVC.expenseArray = self.expenseArray
                    detailsVC.type = self.type
                    detailsVC.currentMonth = self.currentMonth
                    
                    detailsVC.totalIncome = self.totalIncome
                    detailsVC.totalExpense = self.totalExpense
                    detailsVC.totalBudget = self.totalBudget
                    
                    budgetArray = detailsVC.calculateBudget(thisBudget: budget)
                    totalIncome[currentMonth] = budgetArray[0]
                    totalExpense[currentMonth] = budgetArray[1]
                    totalBudget[currentMonth] = budgetArray[2]
                    
                }
            }
        }
        
    }
    

}
