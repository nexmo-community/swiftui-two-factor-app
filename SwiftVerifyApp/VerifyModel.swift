//
//  VerifyModel.swift
//  SwiftVerifyApp
//
//  Created by Abdulhakim Ajetunmobi on 09/11/2020.
//

import Foundation

final class VerifyModel: ObservableObject {
    
    enum VerificationStatus {
        case notRequested
        case requested
        case verified
    }
    
    @Published var isLoading: Bool = false
    @Published var verificationStatus: VerificationStatus = .notRequested
    
    var text: String = ""
    
    private var requestResponse: RequestResponse?
    private var checkResponse: CheckResponse?
    private let baseURL = "https://abdulajet.ngrok.io"
    
    func placeholderText() -> String {
        switch verificationStatus {
        case .notRequested:
            return "Enter your phone number to request a code"
        case .requested:
            return "Enter your code"
        default:
            return ""
        }
    }
    
    func requestFor<T: Codable>(body: T, path: String) -> URLRequest? {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "post"
        
        return request
    }
    
    func requestCode() {
        isLoading = true
        URLSession.shared.dataTask(with: requestFor(body: RequestBody(number: text), path: "request")!) { data, response, error in
            guard error == nil else { return }
            
            if let data = data {
                let decodedResponse = try! JSONDecoder().decode(RequestResponse.self, from: data)
                self.requestResponse = decodedResponse
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
                if self.requestResponse?.requestID != nil {
                    self.verificationStatus = .requested
                    self.text = ""
                }
            }
            
        }.resume()
    }
    
    func verifyCode() {
        self.isLoading = true
        URLSession.shared.dataTask(with: requestFor(body: CheckBody(requestID: requestResponse!.requestID, code: text), path: "check")!) { data, response, error in
            guard error == nil else { return }
            
            if let data = data {
                let decodedResponse = try! JSONDecoder().decode(CheckResponse.self, from: data)
                self.checkResponse = decodedResponse
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
                if self.checkResponse?.status == "0" {
                    self.verificationStatus = .verified
                    self.text = ""
                }
            }
            
        }.resume()
    }
}
