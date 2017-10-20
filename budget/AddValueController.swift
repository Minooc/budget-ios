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
    
    var hasDot = false;
    var type = "Income"
    
    var currentMonth = "January"
    var month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        valField.delegate = self
        valField.keyboardType = .decimalPad
        
        valueLbl.text = "0"
        
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
        
        var availableCharacters = "0123456789"
        if (valField.text != "" && hasDot == false) {
            availableCharacters += "."
        }
        if (valField.text?.characters.contains("."))! {
            hasDot = false
            availableCharacters = "0123456789"
        }
        
        let invalidCharacters = CharacterSet(charactersIn: availableCharacters).inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        
        if (desField.text != "" && valField.text != "") {
            let budget = budgetData(des: "", val: "")
            
            budget.configureCell(valField: valField.text!, desField: desField.text!)
            desField.text = ""
            valField.text = ""
            
            if (type == "Income") {
                Manager.instance.addIncome(currentMonth: currentMonth, income: budget)
                
            } else if (type == "Expense") {
                Manager.instance.addExpense(currentMonth: currentMonth, expense: budget)
            }
            
            Manager.instance.saveData()
            
            performSegue(withIdentifier: "AddValue", sender: budget)
            
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddValue" {
            if let detailsVC = segue.destination as? ViewController {
                if let budget = sender as? budgetData {
                    
                      detailsVC.type = self.type
                      detailsVC.currentMonth = self.currentMonth

                      detailsVC.calculateBudget(thisBudget: budget)
                    
                }
            }
        }
        
    }
    
    
}
