//
//  UIDevice+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 19/6/24.
//

import UIKit

internal extension UIDevice {
    
    var modelName: String {
        var modelCode: String?
        
#if targetEnvironment(simulator)
        modelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]
#else
        var systemInfo = utsname()
        uname(&systemInfo)
        
        modelCode = withUnsafePointer(to: &systemInfo.machine) { pointer in
            pointer.withMemoryRebound(to: CChar.self, capacity: 1) { pointer in
                String(validatingUTF8: pointer)
            }
        }
        
#endif
        
        return modelCode ?? ""
    }
}
