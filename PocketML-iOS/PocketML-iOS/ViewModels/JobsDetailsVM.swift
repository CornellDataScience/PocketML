//
//  JobInfoVM.swift
//  PocketML_iOS
//
//  Created by Anya Yerramilli on 5/3/24.
//

import SwiftUI
import Combine

class JobDetailsViewModel: ObservableObject {
    let id: Int
    @Published var job: ComplexJob?
    
    init(id: Int) {
        self.id = id
        
        Task {
            job = await APIService.shared.getSpecificJob(id: id)
        }
    }
    
    @MainActor
    func refresh() {
        Task {
                self.job = await APIService.shared.getSpecificJob(id: id)
        }
    }
    
    func action(action: Action) {
        APIService.shared.submitAction(id, action: action, updates: job?.config ?? [:])
    }
}
