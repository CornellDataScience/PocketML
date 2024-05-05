//
//  JobsVM.swift
//  PocketML_iOS
//
//  Created by Anya Yerramilli on 5/3/24.
//

import SwiftUI
import Combine
import Foundation

struct Jobs: Codable {
    let success: Bool
    let length: Int
    let jobs: [String: JobInfo]
}

struct JobInfo: Codable, Hashable {
    let name: String
    let active: Bool
    let description: String
    let total_steps: Int
    let current_step: Int
}

class JobsViewModel: ObservableObject {
    static let shared = JobsViewModel()
    @Published var jobList: [String: JobInfo] = [:]
    @Published var currentJobs : [String: JobInfo] = [:]
    @Published var pastJobs : [String: JobInfo] = [:]
    
    
    // call this function on ../api/v1/jobs
    func fetchData(url: String) {
        guard let apiUrl = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }
        
        // TODO: Make custom request type to add headers 
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
           
        // Add headers to the request
        request.setValue("email", forHTTPHeaderField: "a@a.com")
        request.setValue("password", forHTTPHeaderField: "abcdef")

        let task = URLSession.shared.dataTask(with: request ) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let data = data {
                do {
                    
                    let decodedData = try JSONDecoder().decode(Jobs.self, from: data)
                    DispatchQueue.main.async {
                        self.jobList = decodedData.jobs
                        
                        for (id, job) in self.jobList{
                            
                            if job.active {
                                self.currentJobs[id] = job
//                                self.currentJobs.append(job)
                            } else {
                                self.pastJobs[id] = job
//                                self.pastJobs.append(job)
                            }
                        }
                        print("Success - Jobs")
                        
                    }
                    print(self.jobList)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
}
