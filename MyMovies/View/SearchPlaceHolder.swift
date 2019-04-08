//
//  SearchPlaceHolder.swift
//  MyMovies
//
//  Created by MAC Consultant on 4/5/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class SearchPlaceHolder: UIView {
    
    
    static func instanceFromNib() -> SearchPlaceHolder {
        return UINib(nibName: "SearchPlaceHolder", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! SearchPlaceHolder
    }
    
}

