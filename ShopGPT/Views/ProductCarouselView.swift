//
//  ProductCarouselView.swift
//  ShopGPT
//
//  Created by Pranav Iyer on 5/27/24.
//

import SwiftUI

struct ProductCarouselView: View {
    let products: [Product]
    @State private var currentIndex: Int = 0
    @State private var screenWidth: CGFloat = 0
    @State private var cardHeight: CGFloat = 0
    let widthScale = 0.75
    let cardAspectRatio = 1.5
    @State var dragOffset: CGFloat = 0
    @State var activeCardIndex = 0
    let cardColors: [Color] = [.pink, .cyan, .orange, .gray, .teal, .yellow]
    
    var body: some View {
        
        VStack{
            
            Text("Products")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            GeometryReader{reader in
                ZStack{
                    
                    ForEach(products.indices, id: \.self){index in
                        VStack {
                            
                            Text("\(products[index].name)").font(.system(size:20, weight: .semibold))
                            
                            Spacer()
                            HStack{
                                Text(products[index].website)
                                    .font(.callout)
                                    .padding()
                                    .background(.white.opacity(0.5))
                                    .clipShape(Capsule())
                                
                                if let logoURL = products[index].logo, let url = URL(string: logoURL) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 100, height: 100)
                                                .background(Circle().fill(Color.gray))
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        case .failure:
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 100, height: 100)
                                                .overlay(Text("Error").foregroundColor(.white))
                                        @unknown default:
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 100, height: 100)
                                        }
                                    }
                                    .padding(.horizontal)
                                    
                                    
                                } else {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 100, height: 100)
                                        .overlay(Text(products[index].website.prefix(1))
                                            .foregroundColor(.gray)
                                            .font(.largeTitle))
                                        .padding(.horizontal)
                                }
                            }
                            Spacer()
                            HStack{
                                Text("\(products[index].price)")
                                    .font(.system(size: 24, weight: .semibold))
                                
                                Spacer()
                                
                                Button{
                                    if let searchQuery = products[index].search_query, let url = URL(string: searchQuery) {
                                        UIApplication.shared.open(url)
                                    } else if let url = URL(string: products[index].link) {
                                        UIApplication.shared.open(url)
                                    }
                                } label:{
                                    Image(systemName: "basket")
                                        .imageScale(.large)
                                        .padding()
                                        .background(.white)
                                        .clipShape(Capsule())
                                    
                                }
                            }
                            .padding(.leading)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(.white.opacity(0.5))
                            .clipShape(Capsule())
                            
                        }
                        .padding(30)
                        .frame(width: screenWidth*widthScale, height: cardHeight)
                        .background(cardColors[index%cardColors.count])
                        .overlay(Color.white.opacity(1-cardScale(for: index, propotion: 0.4)))
                        .cornerRadius(20)
                        .shadow(radius: 12)
                        .offset(x: cardOffset(for: index))
                        .scaleEffect(x: cardScale(for: index), y: cardScale(for: index))
                        .zIndex(-Double(index))
                        .gesture(DragGesture().onChanged{value in
                            self.dragOffset = value.translation.width
                        }.onEnded{value in
                            let threshold = screenWidth*0.2
                            withAnimation{
                                if value.translation.width <
                                    -threshold{
                                    activeCardIndex = min(activeCardIndex+1, products.count-1)
                                }else if value.translation.width > threshold{
                                    activeCardIndex = max(activeCardIndex-1, 0)
                                }
                            }
                            
                            withAnimation{
                                dragOffset = 0
                            }
                            
                        })
                    }
                }
                .onAppear{
                    screenWidth = reader.size.width
                    cardHeight = screenWidth*widthScale*cardAspectRatio
                }
                .offset(x: 16, y: 70)
            }
            
        }
    }
    
    func cardOffset(for index: Int)-> CGFloat{
        
        let adjustedIndex = index - activeCardIndex
        let cardSpacing: CGFloat = 60/cardScale(for: index)
        let initialOffset = cardSpacing*CGFloat(adjustedIndex)
        let maxCardMovement = cardSpacing
        if adjustedIndex<0{
            if dragOffset>0&&index == activeCardIndex-1{
                let progress = min(abs(dragOffset)/(screenWidth/2), 1)
                let distanceToMove = (initialOffset+screenWidth)*progress
                return -screenWidth + distanceToMove
            }else{
                return -screenWidth
            }
        }else if index>activeCardIndex{
            let progress = min(abs(dragOffset)/(screenWidth/2), 1)
            let distanceToMove = progress*maxCardMovement
            return initialOffset - (dragOffset < 0 ? distanceToMove : -distanceToMove)
        }else{
            if dragOffset<0{
                return dragOffset
            }else{
                let progress = min(abs(dragOffset)/(screenWidth/2), 1)
                let distanceToMove = maxCardMovement*progress
                return initialOffset - (dragOffset < 0 ? distanceToMove : -distanceToMove)
            }
        }
    }
    
    func cardScale(for index: Int, propotion: CGFloat=0.2)-> CGFloat{
        
        let adjustedIndex = index - activeCardIndex
        if index >= activeCardIndex{
            let progress = min(abs(dragOffset)/(screenWidth/2), 1)
            return 1 - propotion * CGFloat(adjustedIndex) +
            (dragOffset < 0 ? propotion*progress: -propotion*progress)
        }
        return 1
    }
    
}




#Preview {
    ProductCarouselView(products: [
        Product(link: "https://www.amazon.com/X-ACTO-School-Classroom-Electric-Sharpener/dp/B00006IEI4",
                logo: "https://shopgptbrandlogo.s3.amazonaws.com/aa79f4a3-932e-4bb3-988f-e135616d84ca.jpg",
                name: "X-ACTO School Pro Classroom Electric Pencil Sharpener",
                price: "$24.99",
                search_query: "https://www.amazon.com/s?k=X-ACTO School Pro Classroom Electric Pencil Sharpener",
                website: "Amazon"),
        Product(link: "https://www.walmart.com/ip/Bostitch-Personal-Electric-Pencil-Sharpener-Blue/20640160",
                logo: "https://shopgptbrandlogo.s3.amazonaws.com/44d3f5b8-2461-4ef0-8906-304ca14ea403.jpg",
                name: "Bostitch Personal Electric Pencil Sharpener",
                price: "$14.97",
                search_query: "https://www.walmart.com/search/?query=Bostitch Personal Electric Pencil Sharpener",
                website: "Walmart"),
        Product(link: "https://www.staples.com/Staedtler-Manual-Pencil-Sharpener-2-Hole-Metal-511-63/product_51163",
                logo: nil,
                name: "Staedtler Manual Pencil Sharpener",
                price: "$4.29",
                search_query: nil,
                website: "Staples")
    ])
}
