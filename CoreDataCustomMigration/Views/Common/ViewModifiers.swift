//
//  SubmitButton.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-05-17.
//

import Foundation
import SwiftUI

extension Button {
    func submitBtnStyle() -> some View {
        self  
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

extension TextField {
    
    func inputStyle() -> some View {
        self
            .padding()
            .border(Color.gray, width: 0.5)
    }
}

extension Text {
    
    func nameStyle() -> some View {
        self
            .foregroundColor(.gray)
            .font(.system(size: 12))
    }
}
