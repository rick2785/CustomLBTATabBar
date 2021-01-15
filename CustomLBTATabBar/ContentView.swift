//
//  ContentView.swift
//  CustomLBTATabBar
//
//  Created by RJ Hrabowskie on 1/11/21.
//

import SwiftUI

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
}

struct CoursesView: View {
    struct Course: Hashable {
        let name, imageName: String
        let numLessons: Int
        let totalTime: Float
    }
    
    let courses: [Course] = [
        .init(name: "SwiftUI Mastery", imageName: "course1", numLessons: 35, totalTime: 10.35),
        .init(name: "FullStack Social", imageName: "course2", numLessons: 50, totalTime: 20.5),
        .init(name: "Maps UIKit SwiftUI", imageName: "course3", numLessons: 44, totalTime: 16.3)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(courses, id: \.self) { course in
                        Image(course.imageName)
                            .resizable()
                            .scaledToFill()
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(course.name)
                                    .font(.system(size: 16, weight: .bold))
                                Text("\(course.numLessons) lessons")
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "deskclock")
                                    .font(.system(size: 14, weight: .bold))
                                Text(course.totalTime.description + " hrs")
                                    .font(.system(size: 15, weight: .semibold))
                            }.foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.blue)
                            .cornerRadius(16)
                        }.padding(.top, 8)
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                }
            }.navigationTitle("Courses")
        }
    }
}

struct TasksView: View {
    @State var tasks: [Int] = Array(0..<20)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tasks, id: \.self) { num in
                    Text("Task \(num)")
                }
                .onDelete(perform: { indexSet in
                    tasks.remove(at: indexSet.first ?? 0)
                })
            }
            .navigationTitle("Tasks")
        }
    }
}

import SwiftUIX

struct ContentView: View {
    init() {
//        UITabBar.appearance().barTintColor = .systemBackground
//        UINavigationBar.appearance().barTintColor = .systemBackground
        UINavigationBar.appearance().barTintColor = .white
    }
    
    @State var selectedTabIndex = 0
//    @State var shouldShowModal = false
    private let tabBarImageNames = ["pencil", "lasso", "plus.app.fill", "person.fill", "trash"]
    
    @State var imageData: Data?
    @State var shouldShowImagePicker = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Spacer()
                    .fullScreenCover(isPresented: $shouldShowImagePicker, content: {
                        ImagePicker(data: $imageData, encoding: .png)
                    })
                
                VStack(spacing: 0) {
                    switch selectedTabIndex {
                    case 0:
                        CoursesView()
                    case 1:
                        TasksView()
                    default:
                        NavigationView {
                            VStack {
                                Text("\(tabBarImageNames[selectedTabIndex])")
                                Spacer()
                            }
                            .navigationTitle("\(tabBarImageNames[selectedTabIndex])")
                        }
                    }
                    
                    Divider()
                    HStack {
                        ForEach(0..<5, id: \.self) { num in
                            HStack {
                                Button(action: {
                                    if num == 2 {
                                        shouldShowImagePicker.toggle()
                                        return
                                    }
                                    self.selectedTabIndex = num
                                }, label: {
                                    Spacer()
                                    if num == 2 {
                                        Image(systemName: tabBarImageNames[num])
                                            .foregroundColor(Color.red)
                                            .font(.system(size: 44, weight: .semibold))
                                    } else {
                                        Image(systemName: tabBarImageNames[num])
                                            .foregroundColor(selectedTabIndex == num ? .black : .init(white: 0.7))
                                    }
                                    
                                    Spacer()
                                })
                            }.font(.system(size: 24, weight: .semibold))
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                    .padding(.bottom, proxy.safeAreaInsets.bottom)
                }.edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
