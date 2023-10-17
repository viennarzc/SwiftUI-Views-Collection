//
//  LoadingRectangle.swift
//  InstagramStory
//
//  Created by Viennarz Curtiz on 10/17/23.
//

import SwiftUI
import Combine

struct LoadingRectangle: View {
    var progress: CGFloat = 0
    
    var staticRectangleColor: Color = Color.white.opacity(0.9)
    var animatingRectangleColor: Color = Color.white.opacity(0.3)
    
    var body: some View {
        GeometryReader { geometry in
           ZStack(alignment: .leading) {
               Rectangle()
                   .foregroundColor(animatingRectangleColor)
                   .cornerRadius(5)

               Rectangle()
                   .frame(width: geometry.size.width * self.progress, height: nil, alignment: .leading)
                   .foregroundColor(staticRectangleColor)
                   .cornerRadius(5)
           }
       }
    }
}

#Preview {
    VStack {
        LoadingRectangle(progress: 0.5, staticRectangleColor: .red.opacity(0.9), animatingRectangleColor: .yellow)
            .frame(width: nil, height: 2, alignment: .leading)
        
    }
    
}

class StoryTimer: ObservableObject {
    
    @Published var progress: Double
    private var interval: TimeInterval
    private var max: Int
    private let publisher: Timer.TimerPublisher
    private var cancellable: Cancellable?
    
    
    init(items: Int, interval: TimeInterval) {
        self.max = items
        self.progress = 0
        self.interval = interval
        self.publisher = Timer.publish(every: 0.1, on: .main, in: .default)
    }
    
    func start() {
        self.cancellable = self.publisher.autoconnect().sink(receiveValue: {  _ in
            var newProgress = self.progress + (0.1 / self.interval)
            if Int(newProgress) >= self.max { newProgress = 0 }
            self.progress = newProgress
        })
    }
    
    func cancel() {
        self.cancellable?.cancel()
    }
    
    func advance(by number: Int) {
        let newProgress = Swift.max((Int(self.progress) + number) % self.max , 0)
        self.progress = Double(newProgress)
    }
}
