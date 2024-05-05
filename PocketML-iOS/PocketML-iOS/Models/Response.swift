//
//  Response.swift
//  PocketML-iOS
//
//  Created by Steven Yu on 5/4/24.
//

import Foundation

struct GetJobsResponse: Codable {
    let success: Bool
    let length: Int
    let jobs: [Int: PrimitiveJob]
}

struct GetSpecificJobResponse : Codable {
    let id: Int
    let name: String
    let active: Bool
    let description: String
    let config: [String : String]
    let wandb: Bool
    let wandb_link: String
    let start_time: Int
}
