//
//  Structures.swift
//  PocketML_iOS
//
//  Created by Ella Schneyer on 4/4/24.
//

import Foundation
import SwiftUI

struct Script: Identifiable {
    var id = UUID()
    let scriptTitle : String
    let modelType : String
    let c : Double
    let kernel : String
    let maxiter : Int
    
    //TODO more parameters, dropdown types, cluster deployments
}

struct ScriptGroup : Identifiable {
    var id = UUID()
    let groupName : String
    var scripts : [Script]
}
