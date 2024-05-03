//
//  JobsVM.swift
//  PocketML_iOS
//
//  Created by Anya Yerramilli on 5/3/24.
//

import SwiftUI
import Combine

struct Jobs: Codable {
    let name: String
    let active: Bool
    let description: String
}

class ViewModel: ObservableObject {
    @Published var jobs: [String: Jobs] = [:]
    
    // call this function on ../api/v1/jobs
    func fetchData(from url: String) {
        guard let apiUrl = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }

        URLSession.shared.dataTask(with: apiUrl) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([String: Jobs].self, from: data)
                    DispatchQueue.main.async {
                        self.jobs = decodedData
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

