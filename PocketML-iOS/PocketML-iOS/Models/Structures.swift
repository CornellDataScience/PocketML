//
//  Structures.swift
//  PocketML_iOS
//
//  Created by Ella Schneyer on 4/4/24.
//

import Foundation
import SwiftUI

// Job Structures
struct Job: Codable, Identifiable {
    var id = UUID()
    let jobTitle : String
    let completedEpochs : Double
    let totalEpochs : Double
    let jobID : String
    let isActive : Bool
//    let milestones : [Milestone]
    // TODO: let trainLoss : Double
}

struct Milestone : Codable, Identifiable {
    var id = UUID()
    let type : String
    let targetValue : Double
    let accomplished : Bool
}

// Script Structures
struct Script: Codable, Identifiable {
    var id = UUID()
    let scriptTitle : String
    let modelType : String
    let c : Double
    let kernel : String
    let maxiter : Int
    
    //TODO more parameters, dropdown types, cluster deployments
}

struct ScriptGroup : Codable, Identifiable {
    var id = UUID()
    let groupName : String
    var scripts : [Script]
}

// Cluster Structures
struct ClusterData: Codable, Identifiable {
    var id = UUID()
    var name: String = ""
    var port: Int = 0
    var publicKey: String = ""
}

