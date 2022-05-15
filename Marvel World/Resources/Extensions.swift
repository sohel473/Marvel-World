//
//  Extensions.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/15/22.
//

import UIKit

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

