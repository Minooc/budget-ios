import Foundation

class Data: NSObject, NSCoding {
    
    struct Keys {
        // we use keys to store values
        
        static let incomeDictionary = "IncomeDictionary"
        static let expenseDictionary = "ExpenseDictionary"
        
        
        static let totalIncome = "TotalIncome"
        static let totalExpense = "TotalExpense"
        static let totalBudget = "TotalBudget"
        
    }
    
    
    var data = "data"
    
    var incomeArray = [String:[budgetData]]()
    var expenseArray = [String:[budgetData]]()
    
    var incomeDictionary = [String:[(String, String)]]()
    var expenseDictionary = [String:[(String, String)]]()
    
    var totalIncome = [String:Double]()
    var totalExpense = [String:Double]()
    var totalBudget = [String:Double]()
    
    
    override init() {}
    
    
    // 2 functions to save and retrieve data
    
    required init?(coder aDecoder: NSCoder) {
        super.init()


        if let incomeDict = aDecoder.decodeObject(forKey: Keys.incomeDictionary) as? [String:[(String, String)]] {
            self.incomeDictionary = incomeDict
        }

        if let expenseDict = aDecoder.decodeObject(forKey: Keys.expenseDictionary) as? [String:[(String, String)]] {
            self.expenseDictionary = expenseDict
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
        
        aCoder.encode(self.incomeDictionary, forKey: Keys.incomeDictionary)   // not working
        aCoder.encode(self.expenseDictionary, forKey: Keys.expenseDictionary) // not working
        
        aCoder.encode(self.totalIncome, forKey: Keys.totalIncome)
        aCoder.encode(self.totalExpense, forKey: Keys.totalExpense)
        aCoder.encode(self.totalBudget, forKey: Keys.totalBudget)
        
       
    }
}
