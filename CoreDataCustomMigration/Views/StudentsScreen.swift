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
    @FetchRequest(sortDescriptors: []) var courses: FetchedResults<Course>
    
    @State private var name = ""
    @State private var age = ""
    @State private var email = ""
    @State private var birthDate = Date()
    @State private var selectedCourses: Set<Course> = []
    @State private var studentId = ""
    private var student: Student?
    
    @State private var showDatePicker = false
    @State private var date = Date()
    
    init(student: Student) {
        self.student = student
        _name = State(initialValue: student.name ?? "")
        _age = State(initialValue: String(student.age))
        _email = State(initialValue: student.email ?? "")
        _birthDate = State(initialValue: student.dateOfBirth ?? Date())
        _selectedCourses = State(initialValue: student.courses as! Set<Course>)
        _studentId = State(initialValue: student.objectID.uriRepresentation().absoluteString)
    }
    
    init() {}
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if !studentId.isEmpty {
                    InputView(label: AppLocalization.studentId, value: $studentId)
                        .disabled(true)
                }
                
                InputView(label: AppLocalization.enterName, value: $name)
                InputView(label: AppLocalization.enterAge, keyboardType: .numberPad, value: $age)
                InputView(label: AppLocalization.enterEmail, keyboardType: .emailAddress, value: $email)
            
                Text(AppLocalization.enterDOB)
                    .nameStyle()
                Button(action: {
                    self.showDatePicker = !self.showDatePicker
                }) {
                    TextField(AppLocalization.enterDOB, text: .constant(date.str))
                        .inputStyle()
                        .disabled(true)
                }
                
                if showDatePicker {
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                }
                
                Text(AppLocalization.selectCourses)
                    .nameStyle()
                ForEach(courses, id: \.self) { item in
                    HStack {
                        Text(item.name ?? "")
                        Spacer()
                        if selectedCourses.contains(item) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedCourses.contains(item) {
                            selectedCourses.remove(item)
                        } else {
                            selectedCourses.insert(item)
                        }
                    }
                }
                .listStyle(InsetListStyle())
                
                Button(student != nil ? AppLocalization.update : AppLocalization.submit) {
                    updateStudent()
                    self.presentationMode.wrappedValue.dismiss()
                }
                .submitBtnStyle()
            }
        }
        .padding()
    }
    
    private func updateStudent() {
        let student = student ?? Student(context: moc)
        student.name = name
        student.email = email
        student.age = Int16(age) ?? 0
        student.dateOfBirth = birthDate
        student.courses = Set(selectedCourses) as NSSet
    }
}

extension Date {
    
    var str: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
}
