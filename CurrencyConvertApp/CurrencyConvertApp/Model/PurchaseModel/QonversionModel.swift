//
//  Qonversion.swift
//  PurcheseModels
//
//  Created by Moksh on 07/12/23.
//


#if canImport(Qonversion)
import Foundation
import Qonversion


enum QonversionLaunchMode {
    case subscriptionManagement
    case analytics
}

class QonversionModel  {
    
    static var shared = QonversionModel()
    
    private init() {
        ///Please add AdSupport and iAd frameworks in your target then remove this lines and build you project
        
//        #error("Please add AdSupport framework in your target")
//        #error("Please add iAd framework in your target")
    }
    
    func configure(projectKey : String, launchMode : QonversionLaunchMode,userID : String? = nil) {
        let config1 = Qonversion.Configuration(projectKey: projectKey, launchMode: launchMode == .analytics ? .analytics : .subscriptionManagement)
        Qonversion.initWithConfig(config1)
        
        if let userID {
            Qonversion.shared().setUserProperty(.userID, value: userID)
        }
        
        Qonversion.shared().collectAppleSearchAdsAttribution()
//        self.getRemoteConfig()
    }
    
    func reportPurchase() {
        QonversionSwift.shared.syncStoreKit2Purchases()
    }
    
//    func detachUser(handler : @escaping voidHandler) {
//        Qonversion.shared().detachUser(fromExperiment: "id here", completion: {_,_ in
//            UserDefaults.lastDetachUserCountQonversion = UserDefaults.detachUserCountQonversion
//            handler()
//        })
//    }
//    
//    
//    func getRemoteConfig(){
//        Thread.OnBackGroudThread {
//           
//            if UserDefaults.lastDetachUserCountQonversion != UserDefaults.detachUserCountQonversion {
//                self.detachUser {
//                    self.getRemoteConfig()
//                }
//            } else {
//                Qonversion.shared().remoteConfig(contextKey: "ProScreenTest_12_June_24") { remoteConfig, error in
//                    if let dict = remoteConfig?.payload as? [String: Any]{
//                        if let proID = dict.getString("ScreenID") {
//                            Log.success("ScreenID : \(proID)")
//                            UserDefaults.currentAssignedProScreen = proID
//                        }
//                        
//                        
//#if(DEBUG)
//                        Swifty_UIX.showDrop(title: "Qonversion seted", subtitle: "ScreenID : \(dict.getString("ScreenID") ?? "")",icon: UIImage(systemName: "q.circle.fill"), haptic: feedbackType.light)
//#endif
//                        NSNotification.QonversionDidUpdated.fire()
//                        
//                    }
//                }
//            }
//           
//            
//
//        }
//       
//       
//    }
    
}


#endif
