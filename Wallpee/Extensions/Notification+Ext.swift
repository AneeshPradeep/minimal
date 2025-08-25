//
//  Notification+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

extension Notification.Name {
    
    static let keyboardWillShowKey = UIResponder.keyboardWillShowNotification
    static let keyboardWillHideKey = UIResponder.keyboardWillHideNotification
    static let keyboardWillChangeFrameKey = UIResponder.keyboardWillChangeFrameNotification
    
    static let didEnterBackgroundKey = UIApplication.didEnterBackgroundNotification
    static let willResignActiveKey = UIApplication.willResignActiveNotification
    static let didBecomeActiveKey = UIApplication.didBecomeActiveNotification
    static let willTerminateKey = UIApplication.willTerminateNotification
    
    ///Khi mua hàng thành công
    static let IAPHelperNotification = Notification.Name("IAPHelperNotification")
    
    ///Đẩy một Notification khi 'FCMToken' được tạo
    static let fcmToken = Notification.Name("FCMToken")
    
    ///Chạm 2 lần TabBar
    static let doubleTapKey = Notification.Name("DoubleTapKey")
    
    ///Khi vuốt để Pop. Sử dụng trong SharedTransitionAnimator
    static let popToKey = Notification.Name("PopToKey")
    
    ///Khi nhấn vào một Photo trong More
    static let changePhotoKey = Notification.Name("ChangePhotoKey")
    
    ///Cho MoreVC. Ko cần tải lại nếu truy cập MoreVC thêm lần nữa
    static let newPhotoResultKey = Notification.Name("NewPhotoResultKey")
    
    ///Khi lưu mới Photo vào CoreData
    static let newPhotoKey = Notification.Name("NewPhotoKey")
    
    ///Khi thay đổi Ngôn Ngữ
    static let changeLanguageKey = Notification.Name("ChangeLanguageKey")
    
    ///Cập nhật Menu Icon ko có biểu tượng đỏ
    static let updateMenuIconKey = Notification.Name("UpdateMenuIconKey")
    
    ///Quan sát kết nối Internet
    static let networkKey = Notification.Name("NetworkKey")
}
