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
                    .modifier(MainTitleModifier())
                Spacer()
                JobListSection("Current Jobs", jobs: currentJobs)
                JobListSection("Past Jobs", jobs: pastJobs)
                Divider().background(Color.background)
            
            }
            .modifier(MainVStackModifier())
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
        .modifier(ListVStackModifier())
    }
}

func JobSectionTitle(_ text: String) -> some View {
    Text(text)
        .modifier(Title2Modifier())
        .bold()
        .padding(.bottom,-40)
}

private func JobInfoRow(job : Job) -> some View {
    HStack{
        VStack(alignment:.leading){
            Text(job.jobTitle)
                .modifier(Title3Modifier())
            
            let compEpoch = String(format: "%.2f", job.completedEpochs)
            let totEpoch = String(format: "%.2f", job.totalEpochs)
            let percent = String(format: "%.1f", (job.completedEpochs * 100 / job.totalEpochs))
            ProgressView(value: job.completedEpochs, total: job.totalEpochs){
                HStack{
                    Text("\(compEpoch) epochs \\ \(totEpoch)")
                        .modifier(SubheadlineModifier())
                    Spacer()
                    Text("\(percent)%")
                        .modifier(SubheadlineModifier())
                        .bold()
                }
            }
            .accentColor(Color.main)
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
        .listRowBackground(Color.background)
        .scrollContentBackground(.hidden)
        
    }
}

#Preview {
    JobDashboardView()
}
