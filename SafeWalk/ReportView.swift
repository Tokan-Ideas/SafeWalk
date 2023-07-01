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
                Spacer()
                Button {
                    print("Police")
                } label: {
                    Image("ReportView_Police")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                Spacer()
                Button {
                    print("No Lights")
                } label: {
                    Image("ReportView_NoLights")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                Spacer()
                
            })
            .padding(.top, 20)
            Spacer()
            HStack(content: {
                Spacer()
                Button {
                    print("No Sidewalk")
                } label: {
                    Image("ReportView_NoSidewalk")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                Spacer()
                Button {
                    print("Construction")
                } label: {
                    Image("ReportView_Construction")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                Spacer()
            })
            Spacer()
            HStack(content: {
                Spacer()
                Button {
                    print("Busy Area")
                } label: {
                    Image("ReportView_Crowded")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                Spacer()
    
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
