//
//  EnrollmentScreen.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-06-02.
//

import Foundation
import SwiftUI

struct EnrollmentEditScreen: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest(sortDescriptors: []) var courses: FetchedResults<Course>
    
    @State private var grade = "0"
    @State private var enrollmentDate = Date()
    @State private var description = ""
    @State var selectedCourse: Course?
    
    var onDismiss: (Enrollment) -> Void
    var enrollment: Enrollment?
    
    init(enrollment: Enrollment? = nil, onDismiss: @escaping (Enrollment) -> Void) {
        self.enrollment = enrollment
        self.onDismiss = onDismiss
        _grade = State(initialValue: String(enrollment?.grade ?? 0))
        _enrollmentDate = State(initialValue: enrollment?.date ?? Date())
        _selectedCourse = State(initialValue: enrollment?.course)
    }
    
    var body: some View {
        VStack {
            List {
                Section(header: Text(AppLocalization.details)) {
                    TextInputView(label: AppLocalization.enterGrade, keyboardType: .numberPad, value: $grade)
                    TextInputView(label: AppLocalization.enterDescription, keyboardType: .numberPad, value: $description)
                    DateInputView(label: AppLocalization.enterEnrollmentDate, value: $enrollmentDate)
                }
                
                Section(header: Text(AppLocalization.courses)) {
                    ForEach(courses, id: \.self) { course in
                        HStack {
                            Text(course.name ?? "").onTapGesture {
                                selectedCourse = course
                            }
                            
                            if selectedCourse == course {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedCourse == course {
                                selectedCourse = nil
                            } else {
                                selectedCourse = course
                            }
                        }
                    }
                }
            }.listStyle(.grouped)
            
            HStack {
                Spacer()
                Button(enrollment == nil ? "Submit" : "Update") {
                    let enrollment = updateEnrollment()
                    onDismiss(enrollment)
                    self.presentationMode.wrappedValue.dismiss()
                }.submitBtnStyle()
            }
        }
    }
}

extension EnrollmentEditScreen {
    
    func updateEnrollment() -> Enrollment {
        let enrollment = enrollment ?? Enrollment(context: moc)
        enrollment.course = selectedCourse
        enrollment.grade = Float(grade) ?? 0
        enrollment.date = enrollmentDate
        enrollment.desc = description
        return enrollment
    }
}
