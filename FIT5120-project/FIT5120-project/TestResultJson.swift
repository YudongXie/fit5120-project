//
//  TestResultJson.swift
//  FIT5120-project
//
//  Created by Simon Xie on 20/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import Foundation
import UIKit

struct TestResultJson: Codable{
    var comment: String
    var rating: Int

    private enum CodingKeys:String, CodingKey{
        case comment
        case rating
    }
}
