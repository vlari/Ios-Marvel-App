//
//  DividerView.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/28/21.
//

import UIKit

class DividerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.Theme.primary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 6
    }
}
