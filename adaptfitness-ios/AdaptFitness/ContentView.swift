//
//  ContentView.swift
//  AdaptFitness
//
//  Created by csuftitan on 9/15/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: FooterTabBar.Tab = .home
    @State private var isLoggedIn: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content area
            ZStack {
                switch selectedTab {
                case .home:
                    HomePageView(isLoggedIn: $isLoggedIn, user: .exampleUser)
//                case .stats:
//
//                case .calendar:
//                    
                case .browse:
                    BrowseWorkoutsView() // Your workout browser
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
//            Spacer()
            // Footer tab bar
            FooterTabBar(selectedTab: $selectedTab)
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
        }
    }
}

#Preview {
    ContentView()
}
