//
//  Created by Pranav Iyer on 5/26/24.
//

import Foundation

struct Product: Identifiable, Codable {
    var id = UUID()
    let link: String
    let logo: String?
    let name: String
    let price: String
    let search_query: String?
    let website: String

    private enum CodingKeys: String, CodingKey {
        case link, logo, name, price, search_query, website
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.link = try container.decode(String.self, forKey: .link)
        self.logo = try container.decodeIfPresent(String.self, forKey: .logo)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(String.self, forKey: .price)
        self.search_query = try container.decodeIfPresent(String.self, forKey: .search_query)
        self.website = try container.decode(String.self, forKey: .website)
    }
}
