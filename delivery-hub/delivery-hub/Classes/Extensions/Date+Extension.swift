//
//  Data+Extension.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import Foundation

extension Date {
    
    func formate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy, hh:mm"
        return formatter.string(from: self)
    }
    
}
