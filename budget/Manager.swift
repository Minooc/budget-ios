import Foundation

class Manager {
    
     var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    static let instance = Manager()
    private init() {}
    
    var data: Data?

    func initializeData() {
        
        if !FileManager.default.fileExists(atPath: getFilePath() as String) {
            // set up our game with initial values
            data = Data()
            
            for i in 0...months.count-1 {
//                data?.incomeDictionary[months[i]] = []
//                data?.expenseDictionary[months[i]] = []
                data?.incomeArray[months[i]] = []
                data?.expenseArray[months[i]] = []
                data?.totalIncome[months[i]] = 0.0
                data?.totalExpense[months[i]] = 0.0
                data?.totalBudget[months[i]] = 0.0
            }
            
            print("good")
            
            
            saveData()
        }

        loadData()
    }
    
    func loadData() {
        data = NSKeyedUnarchiver.unarchiveObject(withFile: getFilePath() as String) as? Data
        
    }
    
    func saveData() {
        if data != nil {
            NSKeyedArchiver.archiveRootObject(data!, toFile: getFilePath() as String)
        }
    }
    
    // where we want to save file
    private func getFilePath() -> String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        return url!.appendingPathComponent("Manager").path
    }
    

    func setTotalIncome(totalIncome: Double, currentMonth: String) {
        self.data?.totalIncome[currentMonth] = totalIncome
    }
    
    func getTotalIncome(currentMonth: String) -> Double {
        if let totalIncome = self.data?.totalIncome[currentMonth]! {
            return totalIncome
        } else {
            return 0.0
        }
    }
    
    func setTotalExpense(totalExpense: Double, currentMonth: String) {
        self.data?.totalExpense[currentMonth] = totalExpense
    }
    
    func getTotalExpense(currentMonth: String) -> Double {
        if let totalExpense = self.data?.totalExpense[currentMonth]! {
            return totalExpense
        } else {
            return 0.0
        }
    }
    
    func setTotalBudget(totalBudget: Double, currentMonth: String) {
        self.data?.totalBudget[currentMonth] = totalBudget
    }
    
    func getTotalBudget(currentMonth: String) -> Double{
        if let totalBudget = self.data?.totalBudget[currentMonth]! {
            return totalBudget
        } else {
            return 0.0
        }
    }
    
    
    
    
    
    func getIncomeArray(currentMonth: String) -> [budgetData] {
        if let incomeArray = self.data?.incomeArray[currentMonth]! {
            return incomeArray
        } else {
            return []
        }
    }
    
    func getExpenseArray(currentMonth: String) -> [budgetData] {
        if let expenseArray = self.data?.expenseArray[currentMonth]! {
            return expenseArray
        } else {
            return []
        }
    }
    
    func addIncome(currentMonth: String, income: budgetData) {

        self.data?.incomeArray[currentMonth]!.append(income)

    }
    
    func addExpense(currentMonth: String, expense: budgetData) {
        
        self.data?.expenseArray[currentMonth]!.append(expense)
        
    }
    
    func removeIncome(currentMonth: String, indexPath: IndexPath) {
        self.data?.incomeArray[currentMonth]?.remove(at: indexPath.item)
    }
    
    func removeExpense(currentMonth: String, indexPath: IndexPath) {
        self.data?.expenseArray[currentMonth]?.remove(at: indexPath.item)
    }
    
    
    
    
//    func getIncome() -> [String:[budgetData]] {
//        // this is only called when program is loaded.
//
//        var budgets = [String:[budgetData]]()
//
//        for month in months {
//
//            budgets[month] = []
//
//            let storedBudgetList = (self.data?.incomeDictionary[month]!)!
//
//            if (storedBudgetList.count > 0) {
//            for i in 0...storedBudgetList.count-1 {
//
//                let budget = budgetData()
//                budget._desField = storedBudgetList[i].0
//                budget._valField = storedBudgetList[i].1
//                budgets[month]?.append(budget)
//            }
//            }
//        }
//
//        return budgets
//    }
//
//    func addIncome(month: String, income: budgetData) {
//        let desField = income._desField
//        let valField = income._valField
//        let stringsToStore = (desField, valField)
//        print(stringsToStore)
//        print((self.data?.incomeDictionary[month]!)!)
//
//        self.data?.incomeDictionary[month]!.append(stringsToStore)
//       // print(self.data?.incomeDictionary[])
//
//    }
//
//    func getExpense() -> [String:[budgetData]] {
//        // this is only called when program is loaded.
//
//        var budgets = [String:[budgetData]]()
//
//
//        for month in months {
//
//            budgets[month] = []
//
//            let storedBudgetList = (self.data?.expenseDictionary[month]!)!
//
//            if (storedBudgetList.count > 0) {
//            for i in 0...storedBudgetList.count-1 {
//                let budget = budgetData()
//                budget._desField = storedBudgetList[i].0
//                budget._valField = storedBudgetList[i].1
//                budgets[month]?.append(budget)
//            }
//            }
//        }
//
//        return budgets
//    }
//
//    func addExpense(month: String, income: budgetData) {
//        let desField = income._desField
//        let valField = income._valField
//        let stringsToStore = (desField, valField)
//        self.data?.expenseDictionary[month]!.append(stringsToStore)
//    }
    
    
    
}
