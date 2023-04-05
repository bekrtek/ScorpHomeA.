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
    
    func debugStartOfRequest(initialRequest: Bool, fetchResponse: FetchResponse?, people: [Person]) {
        print("""
              -----------Sending Request-------------
              İnitialReuest: \(initialRequest)
              Current People Count: \(people.count)
              Respons Count: \(String(describing: fetchResponse?.people.count))
              """)
    }
    
    func debugEndOfAdding(people: [Person]) {
        print("""
              -----------
              Result of Adding
              Current People Count: \(people.count)
              ------------------------
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
