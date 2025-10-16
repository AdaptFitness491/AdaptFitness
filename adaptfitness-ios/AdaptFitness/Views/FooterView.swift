//
//  FooterView.swift
//  AdaptFitness
//
//  Created by csuftitan on 9/17/25.
//
import SwiftUI

struct FooterTabBar: View {
    @Binding var selectedTab: Tab
    
    enum Tab {
        case home, browse
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: { selectedTab = .home }) {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home").font(.caption2)
                }
                .foregroundColor(selectedTab == .home ? .blue : .gray)
            }
            
            Spacer()
            
            Button(action: {}) {
                VStack {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats").font(.caption2)
                }
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: { selectedTab = .browse }) {
                VStack {
                    Image(systemName: "figure.strengthtraining.traditional")
                    Text("Browse").font(.caption2)
                }
                .foregroundColor(selectedTab == .browse ? .blue : .gray)
            }
            Spacer()
        }
    }
}
