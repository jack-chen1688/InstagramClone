//
//  Follower.swift
//  InstagramClone
//
//  Created by Xuehua Chen on 1/29/17.
//  Copyright © 2017 Xuehua Chen. All rights reserved.
//

import Foundation
import AWSDynamoDB

class Follower: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var id = ""
    var follower = ""
    var followee = ""
    
//    override init!() {
//        super.init()
//    }
//    
//    override init(dictionary dictionaryValue: [AnyHashable : Any]!, error: ()) throws {
//        super.init()
//        id = dictionaryValue["id"] as! String
//    }
//    
//    required init!(coder: NSCoder!) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    class func dynamoDBTableName() -> String {
        return "Followers"
    }

    class func hashKeyAttribute() -> String {
        return "id"
    }
}
