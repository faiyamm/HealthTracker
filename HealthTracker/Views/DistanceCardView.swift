//
//  DistanceCardView.swift
//  HealthTracker
//
//  Created by Fai on 16/03/26.
//

import SwiftUI

struct DistanceCardView: View {
    let distance: Double
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Spacer()
            
            Text(String(format: "%.2f", distance))
                .font(.system(size: 55, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 150, alignment: .trailing)
            
            VStack(alignment: .leading, spacing: -2) {
                Text("DST")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text("km")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            .frame(width: 100, alignment: .leading)
            
            Spacer()
        }
    }
}

#Preview {
    ZStack { Color.orange.ignoresSafeArea(); DistanceCardView(distance: 4.52) }
}
