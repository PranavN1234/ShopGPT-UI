//
//  LoginView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginData = LoginViewModel()
    var body: some View {
        
        VStack{
            VStack{
                Text("Continue with Phone")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.black)
                    .padding()
                
                Image(systemName: "phone")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                Text("You'll receive a 6 digit code\n to verify text")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack{
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Enter Your Phone Number")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("+\(loginData.getCountryCode()) \(loginData.phoneNumber)")
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.black)
                    }
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                    
                    Button(action:{
                        loginData.sendOTP{success in
                            if success{
                                
                            }
                        }
                    }){
                        Text("Continue")
                            .foregroundColor(.black)
                            .padding(.vertical, 18)
                            .padding(.horizontal, 38)
                            .background(Color.yellow)
                            .cornerRadius(15)
                    }
                    .disabled(loginData.phoneNumber == "" ? true: false)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
            }
            .frame(height: UIScreen.main.bounds.height/1.8)
            .background(Color.white)
            .cornerRadius(20)
            
            //            custom pad
            
            NumberPad(value: $loginData.phoneNumber, isVerify: false)
            
            
        }
        .background(Color.white.ignoresSafeArea(.all, edges: .bottom))
        .alert(isPresented: $loginData.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(loginData.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .background(
            NavigationLink(destination: VerificationView(loginData: loginData), isActive: $loginData.otpSent) {
                EmptyView()
            }
        )
        
    }
}


#Preview {
    LoginView()
}
