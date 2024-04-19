//
//  JobDashboardView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//

import SwiftUI

struct JobDashboardView: View {
//    @State private var isPopoverPresented = false
//    @State private var clusterData = ClusterData(name: "", port: "", publicKey: "")
    @State private var currentJobs: [Job] = [
        Job(jobTitle: "Job 1", completedEpochs: 1.25, totalEpochs: 5.0),
        Job(jobTitle: "Job 2", completedEpochs: 1.05, totalEpochs: 3.0),
        Job(jobTitle: "Job 6", completedEpochs: 2.05, totalEpochs: 6.0),
        Job(jobTitle: "Job 8", completedEpochs: 2.0, totalEpochs: 10.0)
    ]
    @State private var pastJobs: [Job] = [
        Job(jobTitle: "Job 3", completedEpochs: 5.0, totalEpochs: 5.0),
        Job(jobTitle: "Job 4", completedEpochs: 10.0, totalEpochs: 10.0),
        Job(jobTitle: "Job 5", completedEpochs: 1.0, totalEpochs: 1.0),
        Job(jobTitle: "Job 7", completedEpochs: 2.0, totalEpochs: 2.0)
    ]

    var body: some View {
        NavigationStack{
            VStack{
                Text("Your Jobs")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.leading)
                    .monospaced()
                    .foregroundStyle(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                Spacer()
                JobListSection("Current Jobs", jobs: currentJobs)
                JobListSection("Past Jobs", jobs: pastJobs)
                Divider().background(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
            
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
        }
    }
}

func JobListSection(_ sectionTitle: String, jobs: [Job]) -> some View {
    VStack{
        Section() {
            VStack{
                JobSectionTitle(sectionTitle)
                JobsList(jobsList: jobs)
            }
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941)))
        .padding(.leading)
        .padding(.trailing)
        .scrollContentBackground(.hidden)
    }
}

func JobSectionTitle(_ text: String) -> some View {
    Text(text)
        .monospaced()
        .padding(.top)
        .padding(.bottom, -30)
        .font(.title2)
        .bold()
        .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
}

private func JobInfoRow(job : Job) -> some View {
    HStack{
        VStack(alignment:.leading){
            Text(job.jobTitle)
                .monospaced()
                .font(.title3)
                .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
            
            let compEpoch = String(format: "%.2f", job.completedEpochs)
            let totEpoch = String(format: "%.2f", job.totalEpochs)
            let percent = String(format: "%.1f", (job.completedEpochs * 100 / job.totalEpochs))
            ProgressView(value: job.completedEpochs, total: job.totalEpochs){
                HStack{
                    Text("\(compEpoch) epochs \\ \(totEpoch)")
                        .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                        .font(.subheadline)
                    Spacer()
                    Text("\(percent)%")
                        .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                        .font(.subheadline)
                        .bold()
                }
            }
            .accentColor((Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647)))
        }
    }
}

private func JobsList(jobsList : [Job]) -> some View {
    List
    {
        ForEach(jobsList) {
            job in
            NavigationLink {
                JobDetailsView(selectedJob: job)
            } label: {
                JobInfoRow(job:job)
            }
        }
        .listRowBackground(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
        .scrollContentBackground(.hidden)
        
    }
}

#Preview {
    JobDashboardView()
}
