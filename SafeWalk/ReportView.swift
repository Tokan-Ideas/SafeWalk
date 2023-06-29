//
//  ReportView.swift
//  SafeWalk
//
//  Created by Rahqi T. Sarsour on 6/28/23.
//

import SwiftUI

struct ReportView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .center, content: {
            Spacer()
            HStack(content: {
                Button("Police") {
                    print("Police")
                }
                Spacer()
                Button("No Lights") {
                    print("No Lights")
                }
                Spacer()
                Button("Construction") {
                    print("Construction")
                }
            })
            Spacer()
            HStack(alignment: .bottom, content: {
                Button("Close") {
                    dismiss()
                }
            })
            .padding()
            
        })
        .padding()
    }
}

//#Preview {
//    ReportView()
//}
