import SwiftUI

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    StatCard(
                        title: "Total Entries",
                        value: "\(viewModel.totalEntries)",
                        icon: "book.fill",
                        color: .blue
                    )
                    
                    StatCard(
                        title: "This Week",
                        value: "\(viewModel.thisWeekEntries)",
                        icon: "calendar",
                        color: .green
                    )
                    
                    StatCard(
                        title: "Most Common Mood",
                        value: viewModel.mostCommonMood,
                        icon: "heart.fill",
                        color: .pink
                    )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About Your Journey")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Text("Your mental landscape is unique and ever-changing. Each entry you create adds to the map of your inner world, helping you understand patterns and find peace.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Insights")
            .onAppear {
                viewModel.loadInsights()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(color.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

