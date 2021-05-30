//
//  Constants.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/25/21.
//

import Foundation

struct ImageHelper {
    static func getURLPath(for wrapper: UIThumbnail, withSize variant: ImageConstant ) -> String {
        let url = "\(wrapper.path)/\(variant.rawValue).\(wrapper.extension)"
        return url
    }
}

enum ImageConstant: String {
    case portrait = "portrait_incredible"
    case squareMedium = "standard_xlarge"
    case squareLarge = "standard_fantastic"
    case wide = "landscape_incredible"
}
