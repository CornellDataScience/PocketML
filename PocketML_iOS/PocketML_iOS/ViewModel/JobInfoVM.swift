//
//  JobInfoVM.swift
//  PocketML_iOS
//
//  Created by Anya Yerramilli on 5/3/24.
//

import SwiftUI
import Combine

struct Hyperparameters: Codable {
    let name: String
    let newValue: String
}

struct WandbInfo: Codable {
    let inUse: Bool
    let link: String
}

struct JobDetails: Codable {
    let name: String
    let active: Bool
    let description: String
    let hyperparameters: [String: String] // Dictionary of hyperparameters
    let wandb: WandbInfo
    let startTime: String // Assuming it's a string in datetime format
}

class JobViewModel: ObservableObject {
    @Published var jobDetails: JobDetails?
    
    // call this function on ../api/v1/jobs/<job_id>
    func fetchData(from url: String) {
        guard let apiUrl = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }

        URLSession.shared.dataTask(with: apiUrl) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(JobDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.jobDetails = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
    }
}
