//
//  HeaderSectionView.swift
//  HealthTracker
//
//  Created by Fai on 16/03/26.
//

import SwiftUI

struct HeaderSectionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Health Card")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            // EKG Line
            Image(systemName: "waveform.path.ecg")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 80)
                .foregroundColor(.white)
                .padding(.top, 10)
        }
    }
}

#Preview {
    ZStack { Color.orange.ignoresSafeArea(); HeaderSectionView() }
}
