//
//  VerificationView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

struct VerificationView: View {
    @ObservedObject var loginData: LoginViewModel
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Button(action: {present.wrappedValue.dismiss()}){
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                        
                    }
                    Spacer()
                    Text("Verify Phone")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                
                Text("Code is sent to \(loginData.phoneNumber)")
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                HStack(spacing: 15){
                    ForEach(0..<6, id: \.self){index in
                        CodeView(code: getCodeAtIndex(index: index))
                    }
                }
                .padding()
                .padding(.horizontal, 20)
                Spacer(minLength: 0)
                
                HStack(spacing: 6){
                    Text("Didn't receive code? ")
                        .foregroundColor(.gray)
                    
                    Button(action: {}){
                        Text("Resend Code")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.black)
                    }
                }
                
                Button(action: {
                    loginData.verifyOTP{success in
                        if success{
                            
                        }
                    }
                }){
                    Text("Verify and use ShopGPT")
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width-30)
                        .background(Color.yellow)
                        .cornerRadius(15)
                }
                
                
            }
            .frame(height: UIScreen.main.bounds.height/1.8)
            .background(Color.white)
            .cornerRadius(20)
            
            NumberPad(value: $loginData.code, isVerify: true)
        }
        .background(Color.white.ignoresSafeArea(.all, edges: .bottom))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $loginData.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(loginData.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .background(
            NavigationLink(destination: ImageSelectionView(loginData: loginData), isActive: $loginData.isLoggedIn) {
                EmptyView()
            }
        )
    }
    
    func getCodeAtIndex(index: Int)->String{
        if loginData.code.count>index{
            let start = loginData.code.startIndex
            let current = loginData.code.index(start, offsetBy: index)
            return String(loginData.code[current])
        }
        
        return ""
    }
}

struct CodeView: View{
    var code: String
    var body: some View{
        VStack(spacing: 10){
            Text(code)
                .foregroundColor(.black)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.title2)
                .frame(height: 45)
            
            Capsule().fill(Color.gray.opacity(0.5))
                .frame(height: 4)
        }
    }
}
#Preview {
    VerificationView(loginData: LoginViewModel())
}
