//
//  APIService.swift
//  PocketML-iOS
//
//  Created by Steven Yu on 5/4/24.
//

import Foundation
import Alamofire

class APIService {
    let baseURL: String = "http://10.48.85.83:8000/api/v1"
    
    private let decoder: JSONDecoder
    
    static let shared = APIService()
    
    private init() {
        decoder = JSONDecoder()
    }
    
    func getJobs() async -> [Int: PrimitiveJob] {
        do {
            let headers: HTTPHeaders = [
                "email": "a@a.com",
//                "password": "password",
            ]
            
            let response: GetJobsResponse = try await AF.request(baseURL + "/jobs", headers: headers)
                .cURLDescription { description in
                    print(description)
                }
                .response(completionHandler: { data in
                    debugPrint(data)
                })
                .validate()
                .serializingDecodable(GetJobsResponse.self, decoder: decoder).value

            
            if response.success {
                print("Response was success")
                print(response.jobs.debugDescription)
                return response.jobs
            } else {
                print("Response has exception")
                return [:]
            }
            
        } catch {
            print("Error occured: \(error)")
            return [:]
        }
    }
    
    func getSpecificJob(id: Int) async -> ComplexJob? {
        do {
            let headers: HTTPHeaders = [
                "email": "a@a.com",
//                "password": "password",
            ]
            
            // response is directly a ComplexJob if code 200
            let response: GetSpecificJobResponse = try await AF.request(baseURL + "/jobs/" + String(id), headers: headers)
                .cURLDescription { description in
                    print(description)
                }
                .response(completionHandler: { data in
                    debugPrint(data)
                })
                .validate()
                .serializingDecodable(GetSpecificJobResponse.self, decoder: decoder).value

            print("Response was successful")
            print(response)
            
            let data = ComplexJob(id: response.id, name: response.name, active: response.active, description: response.description, config: response.config, wandb: response.wandb, wandb_link: response.wandb_link, start_time: Int(response.start_time) ?? 0)
            
            return data
        } catch {
            print("Error occured: \(error)")
            return nil
        }
    }

    func submitAction(_ id: Int, action: Action, updates: [String : String]) {
        let headers: HTTPHeaders = [
            "email": "a@a.com",
//                "password": "password",
        ]
        
        let params: Parameters = [
            "action": action.rawValue,
            "updates": updates
        ]
        
        AF.request(baseURL + "/jobs/" + String(id) + "/submit_action", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .validate()
    }
}
