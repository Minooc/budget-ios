import Foundation

class Data: NSObject, NSCoding {
    
    struct Keys {
        // we use keys to store values
        
//        static let incomeDictionary = "IncomeDictionary"
//        static let expenseDictionary = "ExpenseDictionary"
    
        static let incomeArray = "IncomeArray"
        static let expenseArray = "ExpenseArray"
        
        static let totalIncome = "TotalIncome"
        static let totalExpense = "TotalExpense"
        static let totalBudget = "TotalBudget"
        
    }
    
    
    var data = "data"
    
    var incomeArray = [String:[budgetData]]()
    var expenseArray = [String:[budgetData]]()
    
//    var incomeDictionary = [String:[(String, String)]]()
//    var expenseDictionary = [String:[(String, String)]]()
    
    var totalIncome = [String:Double]()
    var totalExpense = [String:Double]()
    var totalBudget = [String:Double]()
    
    
    override init() {}
    
    
    // 2 functions to save and retrieve data
    
    required init?(coder aDecoder: NSCoder) {
        super.init()


        if let incomeDict = aDecoder.decodeObject(forKey: Keys.incomeArray) as? [String:[budgetData]] {
            self.incomeArray = incomeDict
        }

        if let expenseDict = aDecoder.decodeObject(forKey: Keys.expenseArray) as? [String:[budgetData]] {
            self.expenseArray = expenseDict
        }

        
        
        if let totalIncomeDict = aDecoder.decodeObject(forKey: Keys.totalIncome) as? [String: Double] {
            self.totalIncome = totalIncomeDict
        }
        
        if let totalExpenseDict = aDecoder.decodeObject(forKey: Keys.totalExpense) as? [String: Double] {
            self.totalExpense = totalExpenseDict
        }
        
        if let totalBudgetDict = aDecoder.decodeObject(forKey: Keys.totalBudget) as? [String: Double] {
            self.totalBudget = totalBudgetDict
        }
       
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.incomeArray, forKey: Keys.incomeArray)   // not working
        aCoder.encode(self.expenseArray, forKey: Keys.expenseArray) // not working
        
        aCoder.encode(self.totalIncome, forKey: Keys.totalIncome)
        aCoder.encode(self.totalExpense, forKey: Keys.totalExpense)
        aCoder.encode(self.totalBudget, forKey: Keys.totalBudget)
        
       
    }
}
