//
//  NumberPad.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/28/24.
//

import SwiftUI

struct NumberPad: View {
    @Binding var value: String
    var isVerify: Bool
    var rows = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "delete.left"]
    var body: some View {
        GeometryReader{reader in
            VStack{
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 15){
                    ForEach(rows, id: \.self){value in
                        Button(action:{buttonAction(value: value)}){
                            ZStack{
                                if value == "delete.left"{
                                    Image(systemName: value)
                                        .font(.title)
                                        .foregroundColor(.black)
                                }else{
                                    Text(value)
                                        .font(.title2)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(width: getWidth(frame: reader.frame(in: .global)), height: getHeight(frame: reader.frame(in: .global)))
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .disabled(value == "" ? true: false)
                    }
                }
            }
        }
        .padding()
    }
    func getWidth(frame: CGRect) -> CGFloat {
        let width = frame.width
        let actualWidth = width - 40
        let safeWidth = max(actualWidth / 3, 0)
        return safeWidth
    }
    
    func getHeight(frame: CGRect) -> CGFloat {
        let height = frame.height
        let actualHeight = height - 30
        let safeHeight = max(actualHeight / 4, 0)
        
        return safeHeight
    }
    
    func buttonAction(value: String){
        if value == "delete.left" && self.value != ""{
            self.value.removeLast()
        }
        
        if value != "delete.left"{
            if isVerify{
                if self.value.count<6{
                    self.value.append(value)
                }
            }else{
                self.value.append(value)
            }
        }
    }
}


