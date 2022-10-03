//
//  ContentView.swift
//  EyrusDemo
//
//  Created by Roro on 9/26/22.
//

import SwiftUI

struct ContentView: View {
    @State private var number = "+19016322594"
    @State private var otp = ""
    @State private var url = "https://api-v2-dev.eyrus.com/v2/users/otp_request"
    @State var authenticated = false
    @State private var showingUserfView = false
    @State var showsAlert = false

    var body: some View {
        VStack {
            TextField("Enter number", text: $number)
                .padding(40)
                .keyboardType(.numberPad)
            
            Button {
                otpRequest()
            } label: {
                Text("send")
                    .padding(10)
            }
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())
            
            TextField("Enter otp", text: $otp)
                .padding(40)
                .keyboardType(.numberPad)
            
            Button {
                otpVerify()
            } label: {
                Text("send")
                    .padding(10)
            }
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())

        }
        .alert(isPresented: self.$showsAlert) {
            Alert(title: Text("Wrong otp"))
        }

        .fullScreenCover(isPresented: $showingUserfView) {
            UserInfoView()
        }
    }
        
    func otpRequest() {
        
        guard let url = URL(string: "https://api-v2-dev.eyrus.com/v2/users/otp_request") else { return }

        let body: [String: String] = ["phoneNumber": number]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
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
        
        guard let url = URL(string: "https://api-v2-dev.eyrus.com/v2/users/otp_verify") else { return }

        let body: [String: String] = ["phoneNumber": number, "code": otp]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
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
                    showingUserfView = true
                }
            }
            else {
                self.showsAlert.toggle()

            }
        }
        .resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
