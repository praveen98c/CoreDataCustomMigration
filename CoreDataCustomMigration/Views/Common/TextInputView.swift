//
//  InputView.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-06-05.
//

import Foundation
import SwiftUI

struct TextInputView: View {
    
    var label: String
    var keyboardType: UIKeyboardType
    @Binding var value: String
    
    init(label: String, keyboardType: UIKeyboardType = .default, value: Binding<String>) {
        self.label = label
        self.keyboardType = keyboardType
        _value = value
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .nameStyle()
            TextField(label, text: $value)
                .inputStyle()
                .keyboardType(keyboardType)
        }
    }
}
