//
//  Job.swift
//  PocketML-iOS
//
//  Created by Steven Yu on 5/4/24.
//

import Foundation

// from list of jobs, simplified view
struct PrimitiveJob: Codable {
    let name: String
    let active: Bool
    let description: String
//    let start_time: Int
    let total_steps: Int
    let current_step: Int
}

// specific job in specific view
struct ComplexJob: Identifiable, Codable {
    let id: Int
    let name: String
    let active: Bool
    let description: String
    let config: [String : String]
    let wandb: Bool
    let wandb_link: String
    let start_time: Int
}

enum Action: String, Codable {
    case start
//    case pause
    case stop
}
