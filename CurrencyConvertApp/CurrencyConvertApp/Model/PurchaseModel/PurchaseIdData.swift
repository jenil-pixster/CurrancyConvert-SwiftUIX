//
//  PurchaseIdData.swift
//  PurcheseModels
//
//  Created by Moksh on 18/12/23.
//

import Foundation


struct PurchaseId : Identifiable,Equatable {
    var id = UUID()
    var type : PurchaseIdType
    var displayLabel : String?
    var purchaseId : String
    var priceDefaultValue : String
    var priceDefaultValueDouble : Double
    var priceString : String?
    var priceStringWithOutSuffix : String?
    var priceDouble : Double?
    var currencySymbol : String?
    var SubPeriodString : String?
    var isSelected : Bool = false
    
    var offPercentage : String?
    var offerPriceString : String?
    var offerStringWithOutSuffix : String?
    var offerPriceDouble : Double?
    
    var needSplitPrice : Bool = false
    var splitPriceStringSuffix : String?
    var splitPriceString : String?
    var splitPriceDouble : Double?
    var splitPriceInToUnit: splitIntoType?
    
    var priority : Int = 0
    
    var subString : String?
    
    var isIncludeVerifySubscription : Bool = true
    
    
    //set
    mutating func setPrice(stringValue : String?,doubleValue : Double,withOutSuffix : String?){
        self.priceString = stringValue
        self.priceDouble = doubleValue
        self.priceStringWithOutSuffix = withOutSuffix
        
        switch type {
        case .weekly:
            priority = 3
        case .monthly:
            priority = 1
        case .yearly:
            priority = 0
        case .lifeTime:
            priority = 2
        }
    }
    
    mutating func setSubPeriodString(stringValue : String?){
        self.SubPeriodString = stringValue
    }
    
    mutating func setOfferPrice(stringValue : String?,doubleValue : Double, stringValueWithOutSuffix : String?, offerPer: Int){
        self.offerPriceString = stringValue
        self.offerPriceDouble = doubleValue
        self.offerStringWithOutSuffix = stringValueWithOutSuffix
        self.offPercentage = "\(offerPer)%"
    }
    
    mutating func setSplitPrice(stringValue : String?, doubleSplitValue: Double, suffix: String?){
        self.splitPriceString = stringValue
        self.splitPriceDouble = doubleSplitValue
        self.splitPriceStringSuffix = suffix
    }
    
    mutating func setSubString(stringValue : String?){
        self.subString = stringValue
    }
    
    mutating func setDisplayLabel(value : String) {
        self.displayLabel = value
    }
    
    mutating func setOffPercentage(_ value : String?){
        self.offPercentage = value
    }
    
    mutating func setCurrencySymbol(_ value : String?) {
        self.currencySymbol = value
    }
    
    //get
    func getPriceString(withOutPostFix : Bool = false ) -> String {
        
        var priceToReturn = self.priceDefaultValue
        
        if let priceString{
            priceToReturn = priceString
        } else if let UserDefault = UserDefaults.standard.value(forKey: "\(self.purchaseId)\(UserdefaultPriceType.NormalString.rawValue)") as? String {
            priceToReturn = UserDefault
        }
        
        if withOutPostFix {
            if let priceStringWithOutSuffix {
                priceToReturn = priceStringWithOutSuffix
            }else if let UserDefault = UserDefaults.standard.value(forKey: "\(self.purchaseId)\(UserdefaultPriceType._NormalStringWithOutSuffix.rawValue)") as? String {
                priceToReturn = UserDefault
            }
        }
        
        return priceToReturn
    }
    
    func getDoublePrice() -> Double? {
        if let priceDouble {
            return priceDouble
        } else {
            return UserDefaults.standard.value(forKey: "\(self.purchaseId)\(UserdefaultPriceType.NormalDouble.rawValue)") as? Double
            
        }
    }
    
    func getsplitPrice(withOutPostFix : Bool = false ) -> String {
        // Determine the base price string (without suffix)
        let base: String = {
            if let splitPriceString {
                return splitPriceString
            }
            if let userDefault = UserDefaults.standard.string(forKey: "\(self.purchaseId)\(UserdefaultPriceType.SplitPriceString.rawValue)") {
                return userDefault
            }
            return priceString ?? ""
        }()
        
        // Return early if suffix isn't requested
        guard !withOutPostFix else {
            return base
        }
        
        // Append suffix if available
        if let splitPriceStringSuffix, !splitPriceStringSuffix.isEmpty {
            return "\(base)\(splitPriceStringSuffix)"
        }
        return base
    }
    
    func getDisplayLabel() -> String {
        return displayLabel ?? type.rawValue
    }
    
    func getSubHeading() -> String {
        if let subString {
            return subString
        }
        
        switch type {
        case .weekly:
            return "Billed Weekly"
        case .monthly:
            return "Billed monthly"
        case .yearly:
            return "Billed yearly"
        case .lifeTime:
            return "Lifetime"
        }
    }
    
//    func getSplitePrice() -> String {
//        if PurchaseModel.shared.isReviewVersion {
//            switch type {
//            case .weekly:
//                return "Billed Weekly"
//            case .monthly:
//                return "Billed monthly"
//            case .yearly:
//                return "Billed yearly"
//            case .lifeTime:
//                return "Lifetime"
//            }
//        } else {
//            if let splitPriceString {
//                return splitPriceString
//            } else {
//                switch type {
//                case .weekly:
//                    return "Billed Weekly"
//                case .monthly:
//                    return "Billed monthly"
//                case .yearly:
//                    return "Billed yearly"
//                case .lifeTime:
//                    return "Lifetime"
//                }
//            }
//        }
//
//    }
    
    func getSubPeriodString() -> String? {
        if let SubPeriodString {
            return SubPeriodString
        } else {
            if let value = UserDefaults.standard.value(forKey: "\(self.purchaseId)\(UserdefaultPriceType.PeriodString.rawValue)") {
                return value as? String
            } else {
                return nil
            }
           
        }
    }
    
    func getCurrencySymbol() -> String {
        if let currencySymbol {
            return currencySymbol
        } else if let currencySymbol = UserDefaults.currencySymbol {
            return currencySymbol
        } else {
            return "$"
        }
    }
    
    
    
}

enum PurchaseIdType : String{
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
    case lifeTime = "Lifetime"
    
    func getPerString() -> String{
        switch self{
        case .weekly:
            return "per week"
        case .monthly:
            return "per month"
        case .yearly:
            return "per year"
        case .lifeTime:
            return "lifetime"
        }
    }
}

enum splitIntoType : String{
    case hour = "per hour"
    case day = "per day"
    case week = "per week"
    case month = "per month"
}

enum UserdefaultPriceType : String {
    case NormalString = "_NormalString"
    case _NormalStringWithOutSuffix = "_NormalStringWithOutSuffix"
    case NormalDouble = "_NormalDouble"
    case PeriodString = "_PeriodString"
    case OfferString = "_OfferString"
    case OfferDouble = "_OfferDouble"
    case SplitPriceString = "_SplitPriceString"
}
//
//extension Double{
//    func truncate(places : Int)-> Double {
//        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
//    }
//}

