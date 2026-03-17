//
//  ContentView.swift
//  HealthTracker
//
//  Created by Fai on 16/03/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HealthViewModel()
    
    var body: some View {
        ZStack {
            // Orange Gradient Background
            LinearGradient(
                colors: [Color(red: 0.95, green: 0.55, blue: 0.2), Color(red: 0.95, green: 0.3, blue: 0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Top Refresh Toolbar
                HStack {
                    Spacer()
                    if viewModel.isAuthorized {
                        Button(action: { viewModel.fetchAllData() }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal)
                
                HeaderSectionView()
                
                // Authorization Flow or Data
                if viewModel.authStatus == "Not requested" {
                    Button("Enable Health Access") {
                        viewModel.requestAuthorization()
                    }
                    .font(.title3.bold())
                    .foregroundColor(.orange)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                } else if viewModel.authStatus == "Denied" {
                    Text("Permission denied. Enable in iOS Settings -> Privacy & Security -> Health.")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.isAuthorized {
                    // Your Custom Components
                    VStack(spacing: 20) {
                        StepCardView(steps: viewModel.steps)
                        DistanceCardView(distance: viewModel.distance)
                        ActivityStatusCard(activityStatus: viewModel.activityStatus)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 10)
        }
    }
}

#Preview {
    ContentView()
}
