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
        HStack(alignment: .center) {
            Text("Update Map").font(.title).fontWeight(.heavy)
        }
        VStack(alignment: .center, content: {
            Spacer()
            HStack(content: {
                Spacer()
                Button {
                    print("Police")
                } label: {
                    VStack() {
                        Image("ReportView_Police")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("Police")
                            .font(.subheadline)
                    }
                }
                Spacer()
                Button {
                    print("No Lights")
                } label: {
                    VStack {
                        Image("ReportView_NoLights")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("No Street Lights")
                            .font(.subheadline)
                    }
                }
                Spacer()
                
            })
            .padding(.top, 20)
            Spacer()
            HStack(content: {
                Spacer()
                Button {
                    print("Suspicious Activity")
                } label: {
                    VStack {
                        Image("ReportView_Suspicious")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("Suspicious Activity")
                            .font(.subheadline)
                    }
                }
                Spacer()
                Button {
                    print("Construction")
                } label: {
                    VStack {
                        Image("ReportView_Construction")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("Construction")
                            .font(.subheadline)
                    }
                }
                Spacer()
            })
            Spacer()
            HStack(content: {
                Spacer()
                Button {
                    print("Busy Area")
                } label: {
                    VStack {
                        Image("ReportView_Crowded")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text("High Foot Traffic")
                    }
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
