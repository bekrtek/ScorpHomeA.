//
//  DebugManager.swift
//  ScorpHomeA.
//
//  Created by BEKIR TEK on 5.04.2023.
//

import Foundation

final class DebugManager {
    
    static let shared = DebugManager()
    private init() {}
    
    func debugStartOfRequest(initialRequest: Bool, next: String?, fetchResponse: FetchResponse?, people: [Person]) {
        let fetchResponsePeopleCount: String = String(fetchResponse?.people.count ?? 0)
        let nextString = String(next ?? "nil")
        let requestStatus = (fetchResponse == nil) ? "Failed" : "Successful"
        print("""
              ----------- Sending Request -> \(requestStatus) -------------
              İnitialReuest: \(initialRequest)
              Next String: \(nextString)
              Current People Count: \(people.count)
              Response Count: \(fetchResponsePeopleCount)
              """)
    }
    
    func debugEndOfAdding(people: [Person]) {
        print("""
              People Count After Added Unique People: \(people.count)
              ----------- Result of Adding -------------
              """)
    }
    
    func debugScrollView(position: CGFloat, tableViewHeight: CGFloat, scroolHeight: CGFloat) {
        print("""
              -----Check Scroll View-----
              position: \(position)
              tableViewHeight: \(tableViewHeight)
              scroolHeight: \(scroolHeight)
              -----------------------------
              """)
    }
    
    
    func log(_ message: String, signatureImage: String = "", repeatCount: Int = 4) {
        var debugString = String()
        for index in 0...repeatCount {
            if Int(repeatCount/2) == index {
                debugString += message
            } else {
                debugString.append(signatureImage)
            }
            debugString.append("\t\t")
        }
        print("\(debugString)")
    }

}
