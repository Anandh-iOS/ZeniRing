//
//  uitls.swift
//  CareRingApp
//
//  Created by Anandh Selvam on 22/09/23.
//

import UIKit


class utils: NSObject
{
    
    class func L(_ x: String) -> String {
        return LocalizeTool.localize(fromTables: x, tables: ["Localizable", "LocalizableTwo"])
    }
    
}

