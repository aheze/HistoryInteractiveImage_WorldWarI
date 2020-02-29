//
//  TokenModel.swift
//  HistoryInteractiveImage_WorldWarI
//
//  Created by Zheng on 2/27/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation
import RealmSwift

class TokenModel: Object {
    @objc dynamic var x = Float(0)
    @objc dynamic var y = Float(0)
    @objc dynamic var text = ""
//    @objc dynamic var indexP = 0
}

//class TokenWrapper: Object {
//    let tokens = List<TokenModel>()
//}
