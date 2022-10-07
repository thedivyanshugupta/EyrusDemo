//
//  HomeView.swift
//  EyrusDemo
//
//  Created by Roro on 9/27/22.
//

import SwiftUI

struct UserInfoView: View {

    @StateObject var model = APICallModels()
    var body: some View {
        VStack {
            Button {
                model.getUserInfo(token: Constants.token)
            } label: {
                Text("Get User Info")
            }
            .padding()
            
            Text(model.userFirstName)
                .padding()
            
            Text(model.userLastName)
                .padding()

            Text(model.userCompanyName)
                .padding()

            Text(model.userTelephone)
                .padding()
        }
    }
}
