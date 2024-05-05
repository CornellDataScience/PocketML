//
//  TabNavigatorView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//

import SwiftUI

struct TabNavigatorView: View {
    var body: some View {
        // idk why the bottom tabe is not being seperated from the displayed view
        // ok the divider is a new ios 15 feature, have to do a lot of stuff to get it idt its worth it
        NavigationView{
            TabView {
                JobDashboardView()
                    .tabItem {
                        Label("Projects", systemImage: "laptopcomputer.and.ipad")
                    }
                
//                ClustersView()
//                    .tabItem {
//                        Label("Clusters", systemImage: "apple.terminal")
//                    }
                
                ScriptsView()
                    .tabItem {
                        Label("Scripts", systemImage: "square.and.pencil")
                    }
            }
            .accentColor(Color.main)
        }.navigationBarBackButtonHidden(true)
    }
        
}

#Preview {
    TabNavigatorView()
}
