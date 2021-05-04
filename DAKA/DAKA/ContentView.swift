//
//  ContentView.swift
//  DAKA
//
//  Created by Zhiyue Gao on 3/19/21.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @ObservedObject var gs: Model = Model()
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<Goal>
    var body: some View {
        NavigationView {
            TabView {
                // Home page View
                IndexView()
                    .tabItem {
                        Image(systemName: "calendar.badge.clock")
                        Text("Today")
                    }
                // Goal page View
                GoalView()
                    .tabItem {
                        Image(systemName: "arrowshape.zigzag.right")
                        Text("Goals")
                    }
            }
            .navigationTitle("DAKA")
            .toolbar(content: {
                NavigationLink(destination: AddView()) {
                    Image(systemName: "folder.badge.plus")
                }
            })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
