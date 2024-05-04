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
    @StateObject private var viewModel = JobsViewModel()
    @State private var currentJobs: [Job] = []
    @State private var pastJobs: [Job] = []
    
    func classifyJobs(allJobs: [String: Jobs]){
        
        for (jobId, job) in allJobs{
            
            let j = Job(jobTitle: job.name, completedEpochs: 1.0, totalEpochs: 5.0, jobID: jobId, isActive: job.active )
            
            if job.active{
                currentJobs.append(j)
            } else {
                pastJobs.append(j)
            }
        }
    }
    

    var body: some View {
        NavigationStack{
            VStack{
                Text("Your Projects")
                    .modifier(MainTitleModifier())
                Spacer()
                
                JobListSection("Current Projects", jobs: currentJobs)
                JobListSection("Past Projects", jobs: pastJobs)
                Divider().background(Color.background)
            
            }
            .modifier(MainVStackModifier())
        }.onAppear(){
            viewModel.fetchData(url:"") // TODO: add actual url route to /jobs endpoint
            let allJobs = viewModel.jobs
            classifyJobs(allJobs: allJobs)
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
