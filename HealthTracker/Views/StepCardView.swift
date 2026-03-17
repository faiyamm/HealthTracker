//
//  StepCardView.swift
//  HealthTracker
//
//  Created by Fai on 16/03/26.
//

import SwiftUI

struct StepCardView: View {
    let steps: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Spacer()
            
            Text("\(steps)")
                .font(.system(size: 55, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 150, alignment: .trailing)
            
            VStack(alignment: .leading, spacing: -2) {
                Text("STP")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Text("steps")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
            }
            .frame(width: 100, alignment: .leading)
            
            Spacer()
        }
    }
}

#Preview {
    ZStack { Color.orange.ignoresSafeArea(); StepCardView(steps: 8432) }
}
