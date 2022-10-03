//
//  HomeView.swift
//  EyrusDemo
//
//  Created by Roro on 9/27/22.
//

import SwiftUI

struct UserInfoView: View {
    @State private var userFirstName = ""
    @State private var userLastName = ""
    @State private var userCompanyName = ""
    @State private var userTelephone = ""
    @State private var newAccessToken = ""
    @State private var newRefreshToken = ""

    var body: some View {
        Button {

            getUserInfo()
        
        } label: {
            Text("Get User Info")
        }
        .padding()
        Button {
            refreshToken()
        } label: {
            Text("refresh")
        }
        .padding()
        
        Text(userFirstName)
            .padding()
        
        Text(userLastName)
            .padding()

        Text(userCompanyName)
            .padding()

        Text(userTelephone)
            .padding()
    }
   
    func getUserInfo() {
        refreshToken()
        getUserInfoAfterRefresh()
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIrMTkwMTYzMjI1OTQiLCJpc3MiOiJleXJ1cyIsImlhdCI6MTY2NDc3MjcwNywiZXhwIjoxNjY0ODU5MTA3LCJ1c2VySWQiOiIzNzgyNiIsIm5iZiI6MTY2NDc3MjcwN30.EbISWMn5-yaYLQ0UA_7C5hQ_tvhEqhyg7J1NyJwppD0"
        
        let url = URL(string: "https://api-v2-dev.eyrus.com/v2/users/me/worker_profile")!

        var request = URLRequest(url: url)
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
                print(firstElement)
                print(firstElement.firstName!)
                userFirstName = firstElement.firstName!
                userLastName = firstElement.lastName!
                userCompanyName = firstElement.companyName!
                userTelephone = firstElement.telephone!
            }
            catch let err {
                print(err.localizedDescription)
                
                refreshToken()
                getUserInfoAfterRefresh()
               print("Failed to decode JSON")
            }
        }
        task.resume()
    }
    
    func refreshToken(){
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIrMTkwMTYzMjI1OTQiLCJpc3MiOiJleXJ1cyIsImlhdCI6MTY2NDc3MjcwNywiZXhwIjoxNjY0ODU5MTA3LCJ1c2VySWQiOiIzNzgyNiIsIm5iZiI6MTY2NDc3MjcwN30.EbISWMn5-yaYLQ0UA_7C5hQ_tvhEqhyg7J1NyJwppD0"
        
        let refreshToken = "$2a$11$cCzbWUOw1lXyXvaVnrRkju.wbkFpxXYNOiRibAjXg2NU21TiV.F1u"
        
        guard let url = URL(string: "https://api-v2-dev.eyrus.com/v2/users/refresh_token") else { return }

            let body: [String: String] = ["refreshToken": refreshToken]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            let resData = try? JSONDecoder().decode(ServerMessageRefresh.self, from: data)
            newAccessToken = resData?.jsonWebToken.accessToken ?? "No token"
            print(newAccessToken)
            newRefreshToken = resData?.jsonWebToken.refreshToken ?? "No token"
        }
        .resume()
    }
    
    func getUserInfoAfterRefresh() {
        
        let token = newAccessToken
        
        let url = URL(string: "https://api-v2-dev.eyrus.com/v2/users/me/worker_profile")!

        var request = URLRequest(url: url)
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

            print(token)
            do {
                let decodedData = try JSONDecoder().decode(UserDetails.self, from: data)
                let firstElement = decodedData.workerProjectsAttributes[0]
                print(firstElement)
                print(firstElement.firstName!)
                userFirstName = firstElement.firstName!
                userLastName = firstElement.lastName!
                userCompanyName = firstElement.companyName!
                userTelephone = firstElement.telephone!
            }
            catch let err {
                print(err.localizedDescription)
                print("Failed to decode JSON")
            }
        }
        task.resume()
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
