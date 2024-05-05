//
//  JobsVM.swift
//  PocketML_iOS
//
//  Created by Anya Yerramilli on 5/3/24.
//

import SwiftUI
import Combine
import Foundation

// only accessing primitive jobs
class JobDashboardViewModel: ObservableObject {
    @Published var jobs: [Int: PrimitiveJob] = [:]
    @Published var currentJobs : [Int: PrimitiveJob] = [:]
    @Published var pastJobs : [Int: PrimitiveJob] = [:]
    
    init() {
        Task {
            jobs = await APIService.shared.getJobs()
            currentJobs = jobs
        }
    }
    
    func refresh() {
        Task {
            jobs = await APIService.shared.getJobs()
            currentJobs = jobs
        }
    }
}
