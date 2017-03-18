//
//  Post.swift
//  InstagramClone
//
//  Created by Xuehua Chen on 3/17/17.
//  Copyright © 2017 Xuehua Chen. All rights reserved.
//

import Foundation

import AWSDynamoDB

class Post : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var id: String = ""
    var message: String? = nil
    var userId: String = ""
    var bucket: String = ""
    var filename: String = ""
    
    
    class func dynamoDBTableName() -> String {
        return "Posts"
    }
    
    class func hashKeyAttribute() -> String {
        return "id"
    }
}
