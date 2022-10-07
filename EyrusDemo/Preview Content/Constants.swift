//
//  Constants.swift
//  EyrusDemo
//
//  Created by Roro on 10/4/22.
//

import Foundation
import SwiftUI

struct Constants {
        
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIrMTIwNjQ1MTI1NTkiLCJpc3MiOiJleXJ1cyIsImlhdCI6MTY2NDk5ODI5MCwiZXhwIjoxNjY1MDg0NjkwLCJ1c2VySWQiOiIzNzgyMyIsIm5iZiI6MTY2NDk5ODI5MH0.ghowDTpJxVxLjLOKZw2w_sYfs8lOfXvAi0T0g6UMECQ"
    
    static let refreshAuthToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIrMTIwNjQ1MTI1NTkiLCJpc3MiOiJleXJ1cyIsImlhdCI6MTY2NDk5ODI5MCwiZXhwIjoxNjY1MDg0NjkwLCJ1c2VySWQiOiIzNzgyMyIsIm5iZiI6MTY2NDk5ODI5MH0.ghowDTpJxVxLjLOKZw2w_sYfs8lOfXvAi0T0g6UMECQ"
    
    static let otpRequestUrl = URL(string: "https://api-v2-dev.eyrus.com/v2/users/otp_request")!
    
    static let otpVerifyUrl = URL(string: "https://api-v2-dev.eyrus.com/v2/users/otp_verify")!
    
    static let getUserInfoUrl = URL(string: "https://api-v2-dev.eyrus.com/v2/users/me/worker_profile")!
    
    static let refreshToken = "$2a$11$cCzbWUOw1lXyXvaVnrRkju.wbkFpxXYNOiRibAjXg2NU21TiV.F1u"
    
    static let refreshUrl = URL(string: "https://api-v2-dev.eyrus.com/v2/users/refresh_token")!
}
