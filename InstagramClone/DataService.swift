//
//  DataService.swift
//  InstagramClone
//
//  Created by Xuehua Chen on 3/13/17.
//  Copyright © 2017 Xuehua Chen. All rights reserved.
//

import Foundation
import AWSDynamoDB

class DataService
{
    func findFollowings(follower: String, map: AWSDynamoDBObjectMapper) -> AWSTask<AnyObject>!
    {
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "follower = :val"
        scanExpression.expressionAttributeValues = [":val":follower]
        
    
        return map.scan(Follower.self, expression: scanExpression).continue({ (task: AWSTask) -> Any? in
            if (task.error != nil) {
                print(task.error as Any)
            }
            
            if (task.exception != nil) {
                print(task.exception as Any)
            }
            
            if (task.result != nil) {
                return task.result!.items as! [Follower]
            }
            return nil
        })
    }
    
    func findFollowee(follower: String, followee: String, map: AWSDynamoDBObjectMapper) -> AWSTask<AnyObject>!
    {
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "follower = :follower AND followee = :followee"
        scanExpression.expressionAttributeValues = [":follower":follower, ":followee":followee]
        
        return map.scan(Follower.self, expression: scanExpression).continue({ (task: AWSTask) -> Any? in
            if (task.error != nil) {
                print(task.error as Any)
            }
            
            if (task.exception != nil) {
                print(task.exception as Any)
            }
            
            if (task.result != nil) {
                return task.result!.items as! [Follower]
            }
            return nil
        })

    }
    
    
    
}
