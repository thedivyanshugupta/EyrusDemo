//
//  ContentView.swift
//  EyrusDemo
//
//  Created by Roro on 9/26/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = APICallModels()
    @State var number = "+19016322594"

    var body: some View {
        VStack {
            TextField("Enter number", text: $number)
                .padding(40)
                .keyboardType(.numberPad)
            
            Button {
                model.otpRequest()
            } label: {
                Text("send")
                    .padding(10)
            }
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())
            
            TextField("Enter otp", text: $model.otp)
                .padding(40)
                .keyboardType(.numberPad)
            
            Button {
                model.otpVerify()
            } label: {
                Text("send")
                    .padding(10)
            }
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())

        }
        .alert(isPresented: self.$model.showsAlert) {
            Alert(title: Text("Wrong otp"))
        }

        .fullScreenCover(isPresented: $model.showingUserfView) {
            UserInfoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
