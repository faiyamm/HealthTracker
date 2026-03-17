//
//  ActivityStatusCard.swift
//  HealthTracker
//
//  Created by Fai on 16/03/26.
//

import SwiftUI

struct ActivityStatusCard: View {
    let activityStatus: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Spacer()
            
            Text(activityStatus == "Not Active" ? "N/A" : "ACT")
                .font(.system(size: 55, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 150, alignment: .trailing)
            
            VStack(alignment: .leading, spacing: -2) {
                Text("LVL")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                // Scales the text down slightly so longer statuses like "Moderately Active" fit
                Text(activityStatus)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .frame(width: 100, alignment: .leading)
            
            Spacer()
        }
    }
}

#Preview {
    ZStack { Color.orange.ignoresSafeArea(); ActivityStatusCard(activityStatus: "Moderately Active") }
}
