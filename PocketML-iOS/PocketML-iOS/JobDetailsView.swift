//
//  JobDetailsView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//

import SwiftUI

struct JobDetailsView: View {
    @StateObject private var vm: JobDetailsViewModel
    
    init(id: Int) {
        self._vm = StateObject(wrappedValue: JobDetailsViewModel(id: id))
    }
    
    var body: some View {
        VStack{
            ScrollView{
                VStack(spacing:20){
                    
                    if let job = vm.job {
                        JobTitle(job)
                        StatusDisplay(vm)
                        WandbWidget(job)
                        Config(job)
                    } else {
                        Text("Job doesn't exist")
                    }
                    
//                    Text("Status")
//                        .font(.title)
//                        .padding(.bottom, -20)
//                        .monospaced()
//                        .foregroundStyle(Color.main)
                        
//                        ScriptWidget("<Script Title>")
                    // temporary points for graph
                    // will have to make a binding or attribute of a job
//                    let _ : [CGFloat] = [0.92424, 0.82897, 0.67572894, 0.4280957984, 0.2438574, 0.188435794, 0.1348573, 0.067584938, 0.04423, 0.01423]
//                    GraphWidget(data:dataPoints)
//                        .padding(.leading)
//                        .padding(.trailing)
//                    MilestonesWidget()

                }
                .onAppear {
                    vm.refresh()
                }
            }
            ActionsWidget(vm: vm)
            Divider().background(Color.background)
        }.modifier(MainVStackModifier())
    }
}


func JobTitle(_ job: ComplexJob) -> some View {
    Text(job.name)
        .foregroundStyle(Color.background2)
//        .padding(EdgeInsets(top:10,leading:100, bottom:10, trailing: 100 ))
        .background(Color.main)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.top, 10)
        .monospaced()
        .font(.title)
}


struct StatusDisplay: View {
    @ObservedObject private var vm: JobDetailsViewModel
    
    // mocking active for frontend only, doesn't actually update backend
    @State private var active: Bool
    
    init(_ vm: JobDetailsViewModel) {
        self._vm = ObservedObject(wrappedValue: vm)
        active = vm.job?.active ?? true
    }
    
    var body: some View {
        
        HStack{
            Button("Active"){
                active.toggle()
            }
            .foregroundStyle(active == true ? Color.main: Color.background2)
            .monospaced()
            .font(active == true ? .title2.bold() : .title2)
            
            Button("Inactive"){
                active.toggle()
            }
            .font(.title2)
            .monospaced()
            .foregroundStyle(active == false ? Color.main: Color.background2)
            .font(active == false ? .title2.bold() : .title2)
        }
        .refreshable {
            Task {
                vm.refresh()
            }
        }
    }
}

func WandbWidget(_ job: ComplexJob) -> some View {
    return ZStack(alignment: .center) {
        Link("View on WandB", destination: URL(string: job.wandb_link)!)
            .font(.title3)
            .frame(width: 300, height: 50)
            .foregroundColor(Color.main)
            .background(RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.background2))
    }
    .padding(.trailing)
}

func ConfigRow(_ key: String, _ value: String) -> some View{
    HStack(alignment : .center){
        Text(key + ":")
            .modifier(TextModifier())
        TextField("", text: .constant(value))
            .modifier(TextModifier())
    }
    .padding(.leading, 75)
}

func Config(_ job: ComplexJob) -> some View {
    // var output = ""
    let config = job.config
    
    return VStack(alignment : .center){
        Text("Model Parameters")
            .modifier(Title2Modifier())
            .bold()
        ForEach(config.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
            ConfigRow(key, value)
        }
    }
    .background(RoundedRectangle(cornerRadius: 10.0)
    .fill(Color.background2))
    .padding(.leading)
    .padding(.trailing)
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
    
func ActionButton(_ vm: JobDetailsViewModel, action: Action) -> some View {
    Button {
        vm.action(action: action)
    } label: {
        Text(action.rawValue)
            .foregroundColor(Color.main)
            .frame(width: 100, height: 50)
            .background(RoundedRectangle(cornerRadius: 25)
                .fill(Color.background))
            .padding()
    }
}

func ActionsWidget(vm: JobDetailsViewModel) -> some View{
        Section(){
            VStack{
                Text("Actions")
                    .modifier(TitleModifier())
                    .padding(.bottom, -25)
                HStack(spacing:1){
                    ActionButton(vm, action: .start)
                        .padding(.leading)
                    
                    Spacer()
                    
                    ActionButton(vm, action: .stop)
                        .padding(.trailing)
                    
//                    ActionButton(action:"Pause")
                    
                }
                
            }
        }
        .background(Color.background2)
    }
//
//    #Preview {
//        JobDetailsView(selectedJob: Job(jobTitle: "Job 1", completedEpochs: 1.25, totalEpochs: 5.0, jobID: "", isActive: true))
//    }

