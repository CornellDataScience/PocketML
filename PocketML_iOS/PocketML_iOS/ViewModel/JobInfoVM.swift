//
//  JobInfoVM.swift
//  PocketML_iOS
//
//  Created by Anya Yerramilli on 5/3/24.
//

import SwiftUI
import Combine


//struct Hyperparameters: Codable {
//    let name: String
//}

struct WandbInfo: Codable {
    let in_use: Bool
    let link: String
}

struct JobDetails: Codable {
    let name: String
    let active: Bool
    let description: String
    let hyperparameters: [String: String] // Dictionary of hyperparameters
    let wandb: WandbInfo
    let start_time: String // Assuming it's a string in datetime format
}

class JobInfoViewModel: ObservableObject {
    @Published var jobDetails: JobDetails?
    
    // call this function on ../api/v1/jobs/<job_id>
    func fetchData(url: String) {
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
                        print("Success - Job Info!")
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
