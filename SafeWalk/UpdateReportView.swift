//
//  UpdateReportView.swift
//  SafeWalk
//
//  Created by Rahqi Sarsour on 9/3/23.
//

import SwiftUI
import CoreLocation
import Amplify

struct UpdateReportView: View {
    @Environment(\.dismiss) var dismiss
    let reportType: String
    let reportId: String
    let coordinates: CLLocationCoordinate2D
    let report: Report?
    
    var body: some View {
        
        VStack(alignment: .center)  {
            Image(getReportImage(reportType: reportType))
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 125, height: 125, alignment: .top)
                  .padding(.top, 15)
            Text(getReportType(reportType:reportType))
                .font(.headline)
//            Text("Don't let anything fall on you")
//                .fontWeight(.light)
//                .foregroundColor(.gray)
            Spacer()
            HStack {
                Text("Last Updated")
                Text(report?.updatedAt?.foundationDate.formatted(date: .abbreviated, time: .shortened) ?? "No Clue")
            }
            Spacer()
            Spacer()
            Text("Is this report still here?")
                .foregroundColor(.gray)
            HStack(alignment: .bottom) {
                Button {
                    print("STILL HAPPENING")
                    updateTypeStillHere(report: report!)
                    dismiss()
                } label: {
                    Text("Still Here")
                        .controlSize(.large)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                }
                .border(.blue)
                .tint(.white)
                .controlSize(.large)
                .padding()
                .frame(maxWidth: .infinity)
                Button{
                    print("Gone")
                    updateTypeGone(report: report!)
                    dismiss()
                } label: {
                    Text("Gone")
                        .controlSize(.large)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.primary)
                }
                .tint(.red)
                .controlSize(.large)
                .padding()
                .frame(maxWidth: .infinity)
                
            }
            Spacer()
        }
    }
}
//
//struct UpdateReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateReportView(reportType: "NoLights", reportId: "1", coordinates: CLLocationCoordinate2D(latitude: CLLocationDegrees(37.785852), longitude: CLLocationDegrees(-122.406599)), report: nil)
//    }
//}

private func getReportType(reportType: String) -> String {
    var ret: String = ""
    
    switch reportType {
    case "Police":
        ret = "Police in the Area"
        break;
    case "FootTraffic":
        ret = "Crowded"
        break;
    case "Construction":
        ret = "Construction or Closed Sidewalk"
        break;
    case "SuspiciousActivity":
        ret = "Suspicious Activity"
        break;
    case "NoLights":
        ret = "Broken or no Lights Nearby"
        break;
        
    default: break;
    }
    
    return ret
}

private func updateTypeStillHere(report: Report) {
    var report = report
    report.lastUpdatedByPhoneId = UIDevice.current.identifierForVendor!.uuidString
    report.negatedCounter = 0
    let rep = report
    let saveSink = Amplify.Publisher.create {
        try await Amplify.DataStore.save(rep)
    }.sink {
        if case let .failure(error) = $0 {
            print("Error updating post - \(error)")
        }
    }
    receiveValue: {
        print("Updated the existing post: \($0)")
    }
}

private func updateTypeGone(report: Report) {
    var report = report;
    report.lastUpdatedByPhoneId = UIDevice.current.identifierForVendor!.uuidString
    report.negatedCounter!+=1
    let rep = report
    let saveSink = Amplify.Publisher.create {
        try await Amplify.DataStore.save(rep)
    }.sink {
        if case let .failure(error) = $0 {
            print("Error updating post - \(error)")
        }
    }
    receiveValue: {
        print("Updated the existing post: \($0)")
    }
}

private func getReportImage(reportType: String) -> String {
    var ret: String = ""
    
    switch reportType {
    case "Police":
        ret = "ReportView_Police"
        break;
    case "FootTraffic":
        ret = "ReportView_Crowded"
        break;
    case "Construction":
        ret = "ReportView_Construction"
        break;
    case "SuspiciousActivity":
        ret = "ReportView_Suspicious"
        break;
    case "NoLights":
        ret = "ReportView_NoLights"
        break;
        
    default: break;
    }
    
    return ret
}
