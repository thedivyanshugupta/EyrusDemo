//
//  APICallModels.swift
//  EyrusDemo
//
//  Created by Roro on 10/4/22.
//

import Foundation
import SwiftUI

class APICallModels: ObservableObject {
    @Published var number = ""
    @Published var otp = ""
    @Published var authenticated = false
    @Published var showingUserfView = false
    @Published var showsAlert = false
    @Published var userFirstName = ""
    @Published var userLastName = ""
    @Published var userCompanyName = ""
    @Published var userTelephone = ""
    @Published var newAccessToken = ""
    @Published var newRefreshToken = ""
    
    func otpRequest() {
        let body: [String: String] = ["phoneNumber": number]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: Constants.otpRequestUrl)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error.debugDescription)
                return
            }
        }
        .resume()
    }
        
    func otpVerify() {
        let body: [String: String] = ["phoneNumber": number, "code": otp]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: Constants.otpVerifyUrl)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            let resData = try? JSONDecoder().decode(ServerMessage.self, from: data)
            print(resData?.loginStatus ?? "wrong otp")
            
            if resData?.loginStatus == 0 {
                DispatchQueue.main.async {
                    self.authenticated = true
                    self.showingUserfView = true
                }
            }
            else {
                self.showsAlert.toggle()
            }
        }
        .resume()
    }
    
    func getUserInfo(token: String) {

        var request = URLRequest(url: Constants.getUserInfoUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            _ = try? JSONSerialization.jsonObject(with: data, options: [])

            do {
                let decodedData = try JSONDecoder().decode(UserDetails.self, from: data)
                let firstElement = decodedData.workerProjectsAttributes[0]
                self.userFirstName = firstElement.firstName!
                self.userLastName = firstElement.lastName!
                self.userCompanyName = firstElement.companyName!
                self.userTelephone = firstElement.telephone!
                
            }
            catch let err {
                print(err.localizedDescription)

                self.refreshToken()
               print("Failed to decode JSON")
            }
        }
        task.resume()
    }

    func refreshToken() {

        let body: [String: String] = ["refreshToken": Constants.refreshToken]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: Constants.refreshUrl)
        request.httpMethod = "POST"
        request.httpBody = finalBody

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(Constants.refreshAuthToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }

            let resData = try? JSONDecoder().decode(ServerMessageRefresh.self, from: data)
            self.newAccessToken = resData?.jsonWebToken.accessToken ?? "No token"
            print(self.newAccessToken)
            self.newRefreshToken = resData?.jsonWebToken.refreshToken ?? "No token"
            self.getUserInfo(token: self.newAccessToken)
        }
        .resume()
    }
}
