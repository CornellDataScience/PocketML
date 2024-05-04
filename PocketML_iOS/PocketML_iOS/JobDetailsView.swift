//
//  JobDetailsView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//

import SwiftUI

struct JobDetailsView: View {
    @State private var isActive = true
    @StateObject private var viewModel = JobInfoViewModel()
    
    var selectedJob : Job
    
    var body: some View {
        VStack{
            ScrollView{
                VStack(spacing:20){
                    
                    JobTitle(selectedJob.jobTitle)
//                    Text("Status")
//                        .font(.title)
//                        .padding(.bottom, -20)
//                        .monospaced()
//                        .foregroundStyle(Color.main)
                    StatusDisplay(viewModel)
                        
                       
                        
//                        ScriptWidget("<Script Title>")
                    WandbWidget(viewModel)
                   HyperparamConfig(viewModel)
                    // temporary points for graph
                    // will have to make a binding or attribute of a job
//                    let _ : [CGFloat] = [0.92424, 0.82897, 0.67572894, 0.4280957984, 0.2438574, 0.188435794, 0.1348573, 0.067584938, 0.04423, 0.01423]
//                    GraphWidget(data:dataPoints)
//                        .padding(.leading)
//                        .padding(.trailing)
//                    MilestonesWidget()

                }
            }
            ActionsWidget()
            Divider().background(Color.background)
        }.modifier(MainVStackModifier())
    }
}


func JobTitle(_ text:String) -> some View {
    Text(text)
        .foregroundStyle(Color.background2)
        .padding(EdgeInsets(top:10,leading:100, bottom:10, trailing: 100 ))
        .background(Color.main)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.top, 10)
        .monospaced()
        .font(.largeTitle)
}


func StatusDisplay(_ viewModel: JobInfoViewModel) -> some View {
    var active = viewModel.jobDetails?.active ?? true
    
    return HStack{
        
        Button("Active"){
            //TODO: Change view model state to inactive
        }
        .foregroundStyle(active == true ? Color.main: Color.background2)
        .monospaced()
        .font(active == true ? .title2.bold() : .title2)
        
        Button("Inactive"){
            //TODO: Change view model state to active
        }
        .font(.title2)
        .monospaced()
        .foregroundStyle(active == false ? Color.main: Color.background2)
        .font(active == false ? .title2.bold() : .title2)
    }
}

func WandbWidget(_ viewModel: JobInfoViewModel) -> some View {
    let wandbLink = viewModel.jobDetails?.wandb.link ?? "Failed"

    return ZStack(alignment: .center) {
        Link("View on WandB", destination: URL(string: wandbLink)!)
            .font(.title3)
            .frame(width: 300, height: 50)
            .foregroundColor(Color.main)
            .background(RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.background2))
    }
    .padding(.trailing)
}

func HyperparamRow(_ key: String, _ value: String) -> some View{
    // TODO: Add modifiers for color + font
    HStack{
        Text(key + ": ")
        TextField("", text: .constant(value))
    }
}

func HyperparamConfig(_ viewModel: JobInfoViewModel) -> some View {
    // var output = ""
    let hyperparameters = viewModel.jobDetails?.hyperparameters ?? [:]
    
    return VStack{
        Text("Model Parameters")
            .modifier(Title2Modifier())
            .bold()
        ForEach(hyperparameters.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
            HyperparamRow(key, value)
        }
    }
}
    
    
    // TODO: Integrate these widgets after MVP to incorporate connection between jobs/scripts/kernels
    
    func ScriptWidget(_ script: String) -> some View {
        ZStack {
            VStack{
                Text(script)
                    .modifier(TextModifier())
                Text("<description>")
                    .modifier(SubheadlineModifier())
            }
            .frame(width: 200, height: 100)
            .background(RoundedRectangle(cornerRadius: 25)
                .fill(Color.background2))
        }
    }
    
    
    func Graph(dataPoints: [CGFloat]) -> some View {
        // have to figure out how to customize graph more
        // adding axis labels + dealing with scale...
        GeometryReader { geometry in
            Path { path in
                let xScale = geometry.size.width / CGFloat(dataPoints.count - 1)
                let yScale = geometry.size.height / CGFloat(dataPoints.max() ?? 1)
                
                path.move(to: CGPoint(x: 0, y: dataPoints[0] * yScale))
                
                for index in 1..<dataPoints.count {
                    let x = CGFloat(index) * xScale
                    let y =  (dataPoints[index] * yScale)
                    print(y)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(Color.purple, lineWidth: 3)
            .background(Color.white)
        }
        .frame(width: 320, height: 200)
    }
    
    func GraphWidget(data: [CGFloat]) -> some View {
        Section() {
            VStack{
                Text("Training Loss")
                    .modifier(SectionTitleModifier())
                Graph(dataPoints: data)
            }
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.background2))
        .scrollContentBackground(.hidden)
    }
    
    func MilestoneTable() -> some View{
        Text("<Milestone Table>")
        // something like this, take input of milestone data
        //    var body: some View {
        //            Table(people) {
        //                TableColumn("Name", value: \.name)
        //                TableColumn("Last Name", value: \.lastName)
        //                TableColumn("Ranking") {
        //                    people in
        //                    Text(String(people.ranking))
        //                }
        //            }
    }
    
    func MilestonesWidget() -> some View {
        Section() {
            VStack{
                Text("Milestones")
                    .modifier(SectionTitleModifier())
                MilestoneTable()
            }
            .frame(width: 320)
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.background2))
        .padding(.leading)
        .padding(.trailing)
        .scrollContentBackground(.hidden)
        
    }
    
    func ActionButton(action:String) -> some View{
        ZStack{
            
            Text(action)
                .foregroundColor(Color.main)
                .frame(width: 100, height: 50)
                .background(RoundedRectangle(cornerRadius: 25)
                    .fill(Color.background))
                .padding()
        }
    }
    
    func ActionsWidget() -> some View{
        Section(){
            VStack{
                Text("Actions")
                    .modifier(TitleModifier())
                    .padding(.bottom, -25)
                HStack(spacing:1){
                    ActionButton(action:"Start")
                        .padding(.leading)
                    ActionButton(action:"Stop")
                    ActionButton(action:"Pause")
                        .padding(.trailing)
                    
                }
                
            }
        }
        .background(Color.background2)
    }
    
    #Preview {
        JobDetailsView(selectedJob: Job(jobTitle: "Job 1", completedEpochs: 1.25, totalEpochs: 5.0, jobID: "", isActive: true))
    }

