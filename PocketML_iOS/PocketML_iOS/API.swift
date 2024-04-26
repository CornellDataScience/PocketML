//import UIKit
//
//import Foundation
//
//struct Job :Codable{
//    let name: String
//    let active: Bool
//    let description: String
//}
//
//struct JobsResponse: Codable{
//    let jobs: [String:Job]
//}
//
//func processJSON(from url: String) {
//    guard let url = URL(string: url) else {
//        print("Error: Invalid URL")
//        return
//    }
//
//    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//        if let error = error {
//            print("Error fetching data: \(error.localizedDescription)")
//            return
//        }
//
//        guard let data = data else {
//            print("Error: No data received.")
//            return
//        }
//
//        do {
//            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                  let success = json["success"] as? Bool,
//                  let length = json["length"] as? Int,
//                  let jobsData = json["jobs"] as? [String: Any] else {
//                print("Error: Invalid JSON format")
//                return
//            }
//
//            // Assuming jobsData contains job IDs as keys and job details as values
//            let jobs = jobsData.compactMap { (key, value) -> Job? in
//                guard let jobData = value as? [String: Any],
//                      let name = jobData["name"] as? String,
//                      let active = jobData["active"] as? Bool,
//                      let description = jobData["description"] as? String else {
//                    return nil
//                }
//                return Job(name: name, active: active, description: description)
//            }
//
//            print("Success: \(success)")
//            print("Length: \(length)")
//            print("Jobs:")
//            for job in jobs {
//                print("Name: \(job.name), Active: \(job.active), Description: \(job.description)")
//            }
//        } catch {
//            print("Error parsing JSON: \(error.localizedDescription)")
//        }
//    }
//
//    task.resume()
//}
//
//// Example usage:
//let apiUrl = "http://127.0.0.1:8000/api/v1/jobs"
//processJSON(from: apiUrl)
//

import Foundation

// Define structs to represent the JSON structure
struct Job: Codable {
    let name: String
    let active: Bool
    let description: String
}

struct JobsResponse: Codable {
    let success: Bool
    let length: Int
    let jobs: [String: Job]
}

// Function to parse the JSON response
func parseJSON(data: Data) -> JobsResponse? {
    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(JobsResponse.self, from: data)
        return response
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

// Function to make the GET request and handle the response
func fetchData() {
    guard let url = URL(string: "http://127.0.0.1:8000/api/v1/jobs") else {
        print("Invalid URL")
        return
    }

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error fetching data: \(error)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200,
              let jsonData = data else {
//            print(httpResponse.statusCode)
            print("Invalid response")
            
            return
        }

        if let response = parseJSON(data: jsonData) {
            // Process the parsed JSON response
            print("Success: \(response.success)")
            print("Length: \(response.length)")
            print("Jobs:")
            for (jobID, jobInfo) in response.jobs {
                print("Job ID: \(jobID)")
                print("Name: \(jobInfo.name)")
                print("Active: \(jobInfo.active)")
                print("Description: \(jobInfo.description)")
            }
        } else {
            print("Failed to parse JSON response")
        }
    }

    task.resume()
}

// Call the function to fetch and process data
//fetchData()



