//
//  AppDelegate.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit
import FacebookCore
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //TODO: - Device
    var isIPad = false
    
    var isIPhoneX = false
    var isIPhonePlus = false
    var isIPhone = false
    var isIPhone5 = false
    
    //TODO: - IAP
    var isPremium = false
    
    ///Truy cập 2 lần vào 'PhotoDetailVC' thì hiển thị Interstitial
    var adCount = 0
    
    ///Khi truy cập vào PhotoDetailVC
    lazy var photoResultDict: [String: PhotoResult] = [:]
    
    //Ngôn ngữ đã chọn ở hiện tại
    var currentLanguage = LocalizeModel(name: "English".localized(), code: "en")
    
    //Hình ảnh chia sẻ App
    var shareImage: UIImage?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //TODO: - Device
        setupDevices()
        
        //TODO: - Language
        updateLanguage()
        
        //TODO: - Appearance
        setupAppeatance()
        
        //TODO: - FontName
        //UIFont.familyNames.forEach({ print(UIFont.fontNames(forFamilyName: $0)) })
        
        //TODO: - Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //TODO: - IAP
        ProductID.store.postReceiptData()
        
        //TODO: - Coin
        if KeyManager.shared.getCoin() == nil {
            /*
             - Khởi chạy App lần đầu
             - Tặng 10 Coin
             */
            
            KeyManager.shared.setCoin(coin: 10)
        }
        
        //TODO: - Admob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //TODO: - Share Logo
        if let imageURL = Bundle.main.url(forResource: "shareLogo.png", withExtension: nil),
           let data = try? Data(contentsOf: imageURL)
        {
            shareImage = UIImage(data: data)
        }
        
        //TODO: - Daily Rewards
        CoreDataStack.saveAllDailyRewards()
        KeyManager.shared.setSpin(spin: 3)
        
        getCoreDataPath()
        
        //TODO: - Network
        NetworkMonitor.shared.startMonitoring()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

//MARK: - Setups

extension AppDelegate {
    
    private func setupDevices() {
        //TODO: - UIDevice
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: isIPad = true
            break
            
        case .phone:
            switch UIScreen.current.nativeBounds.height {
            case 2688, 1792, 2436: isIPhoneX = true; break
            case 2208, 1920: isIPhonePlus = true; break
            case 1334: isIPhone = true; break
            case 1136: isIPhone5 = true; break
            default: isIPhoneX = true; break
            }
            
        default:
            break
        }
    }
    
    private func setupAppeatance() {
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().isTranslucent = false
    }
    
    private func updateLanguage() {
        //Nếu khởi chạy App lần đầu
        if getLanguageCode() == nil {
            //Nếu là VN thì thiết lập (mặc định là 'vi')
            if Locale.preferredLanguages.first == "vi-VN" {
                currentLanguage = LocalizeModel(name: "Vietnamese".localized(), code: "vi")
            }
            
            setLanguageCode(code: currentLanguage.code)
            
        } else {
            //Lấy 'code' đã lưu để thiết lập ngôn ngữ
            let code = getLanguageCode() ?? "en"
            if let language = LocalizeModel.shared().first(where: {
                $0.code == code
            }) {
                currentLanguage = language
            }
        }
    }
}

//MARK: - Make Root

extension AppDelegate {
    
    func makeRootView() {
//        let story = UIStoryboard(name: "Main", bundle: nil)
//        let tabBar = story.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//        
//        sceneDL.window?.rootViewController = tabBar
//        sceneDL.window?.makeKeyAndVisible()
    }
}
