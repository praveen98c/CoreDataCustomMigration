//
//  DateInput.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-06-05.
//

import Foundation
import SwiftUI

struct DateInputView: View {
    
    var label: String
    @Binding var value: Date
    @State private var showDatePicker = false
    
    init(label: String, value: Binding<Date>) {
        self.label = label
        _value = value
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .nameStyle()
            Button(action: {
                self.showDatePicker = !self.showDatePicker
            }) {
                TextField(label, text: .constant(value.str))
                    .inputStyle()
                    .disabled(true)
            }
        }
        
        if showDatePicker {
            DatePicker("", selection: $value, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
        }
    }
}
