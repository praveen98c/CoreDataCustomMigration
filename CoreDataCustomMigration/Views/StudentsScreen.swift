//
//  HomeScreen.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-05-16.
//

import Foundation
import SwiftUI
import CoreData

struct StudentsScreen: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
    
    var body: some View {
        NavigationStack {
            VStack {
                List(students) { student in
                    NavigationLink(destination: StudentEditScreen(student: student)) {
                        Text(student.name ?? AppLocalization.unknown)
                    }
                }
                .navigationBarItems(trailing:
                                        NavigationLink(value: "1", label: {
                    Image(systemName: "plus")
                })
                )
            }.navigationDestination(for: String.self) { value in
                StudentEditScreen()
            }
            .navigationBarTitle(AppLocalization.students, displayMode: .inline)
        }
    }
}

struct StudentEditScreen: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Data
    @State private var name = ""
    @State private var age = ""
    @State private var email = ""
    @State private var birthDate = Date()
    @State private var studentId = ""
    @State private var student: Student?
    
    // UI Functionality
    @State private var showAddEnrollmentScreen = false
    
    init(student: Student) {
        _student = State(initialValue: student)
        _name = State(initialValue: student.name ?? "")
        _age = State(initialValue: String(student.age))
        _email = State(initialValue: student.email ?? "")
        _birthDate = State(initialValue: student.dateOfBirth ?? Date())
        _studentId = State(initialValue: student.objectID.uriRepresentation().absoluteString)
    }
    
    init() {}
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text(AppLocalization.details)) {
                        if !studentId.isEmpty {
                            TextInputView(label: AppLocalization.studentId, value: $studentId)
                                .disabled(true)
                        }
                        
                        TextInputView(label: AppLocalization.enterName, value: $name)
                        TextInputView(label: AppLocalization.enterAge, keyboardType: .numberPad, value: $age)
                        TextInputView(label: AppLocalization.enterEmail, keyboardType: .emailAddress, value: $email)
                        DateInputView(label: AppLocalization.enterDOB, value: $birthDate)
                    }
                    
                    Section(header: Text(AppLocalization.enrollments)) {
                        if let student = student {
                            EnrollmentList(student: student)
                        }
                        Text(AppLocalization.addEnrollment)
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                showAddEnrollmentScreen = true
                            }
                    }
                }.listStyle(.grouped)
                    .navigationDestination(isPresented: $showAddEnrollmentScreen) {
                        EnrollmentEditScreen() { enrollment in
                            updateStudent(enrollment: enrollment)
                        }
                    }
                
                Button(student != nil ? AppLocalization.update : AppLocalization.submit) {
                    updateStudent()
                    self.presentationMode.wrappedValue.dismiss()
                }
                .submitBtnStyle()
            }
        }
    }
    
    private func updateStudent(enrollment: Enrollment? = nil) {
        let student = student ?? Student(context: moc)
        student.name = name
        student.email = email
        student.age = Int16(age) ?? 0
        student.dateOfBirth = birthDate
        enrollment?.student = student
        self.student = student
    }
}


struct EnrollmentList: View {
    @FetchRequest var enrollments: FetchedResults<Enrollment>
    
    init(student: Student) {
        _enrollments = FetchRequest<Enrollment>(sortDescriptors: [], predicate: NSPredicate(format: "student == %@", student))
    }
    
    var body: some View {
        ForEach(enrollments, id: \.self) { enrollment in
            NavigationLink(destination: EnrollmentEditScreen(enrollment: enrollment) { _ in
            }) {
                Text(enrollment.course?.name ?? "")
            }
        }
    }
}

extension Date {
    
    var str: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
}
