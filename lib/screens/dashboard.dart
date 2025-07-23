import 'package:flutter/material.dart';

// To use custom colors, you might want to define them here
// const Color primaryColor = Color(0xFF6B58E9);
// const Color secondaryColor = Color(0xFFE8F0FF);

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The main layout uses a Scaffold with a light gray background
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- Section 1: Top Header ---
                _buildHeader(),
                const SizedBox(height: 20),

                // --- Section 2: Health Metric Cards ---
                _buildHealthMetricCards(),
                const SizedBox(height: 20),

                // --- Section 3: Today's Progress ---
                _buildProgressSection(),
                const SizedBox(height: 20),

                // --- Section 4: Quick Actions ---
                _buildQuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget for the top header section ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good Morning, Alex!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Today • March 15, 2024',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        // The profile picture placeholder
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF6B58E9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Text(
              'A',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Widget for the two metric cards at the top ---
  Widget _buildHealthMetricCards() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildMetricCard(
            icon: Icons.water_drop,
            value: '6/8',
            unit: 'Glasses today',
            iconColor: const Color(0xFF6B58E9),
            cardColor: const Color(0xFFE8F0FF),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildMetricCard(
            icon: Icons.directions_run,
            value: '7,234',
            unit: 'Steps today',
            iconColor: const Color(0xFF6B58E9),
            cardColor: const Color(0xFFE8F0FF),
          ),
        ),
      ],
    );
  }

  // --- Helper widget for a single metric card ---
  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String unit,
    required Color iconColor,
    required Color cardColor,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: iconColor, size: 30),
            ),
            const SizedBox(height: 15),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget for the "Today's Progress" section ---
  Widget _buildProgressSection() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Today's Progress",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildProgressItem(
              icon: Icons.water_drop,
              label: 'Water Intake',
              progress: 0.75,
              progressText: '75%',
            ),
            const SizedBox(height: 15),
            _buildProgressItem(
              icon: Icons.accessibility,
              label: 'Exercise',
              progress: 1.0,
              progressText: 'Done',
            ),
            const SizedBox(height: 15),
            _buildProgressItem(
              icon: Icons.fastfood,
              label: 'Meals',
              progress: 0.66,
              progressText: '2/3',
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper widget for a single progress item with a bar ---
  Widget _buildProgressItem({
    required IconData icon,
    required String label,
    required double progress,
    required String progressText,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6B58E9)),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              const SizedBox(height: 5),
              SizedBox(
                height: 8,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFE8F0FF),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF6B58E9),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Text(progressText),
      ],
    );
  }

  // --- Widget for the "Quick Actions" section ---
  Widget _buildQuickActions() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            // The grid for the buttons
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true, // Important to allow GridView inside Column
              physics: const NeverScrollableScrollPhysics(), // Disables scrolling for the grid
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 2.5, // Adjusts the height of the buttons
              children: <Widget>[
                _buildActionButton(label: 'Log Water'),
                _buildActionButton(label: 'Add Meal'),
                _buildActionButton(label: 'Track Mood'),
                _buildActionButton(label: 'Log Exercise'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper widget for a single quick action button ---
  Widget _buildActionButton({required String label}) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Add action logic here (e.g., navigate to a new page)
        print('Button pressed: $label');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFF6B58E9),
        backgroundColor: const Color(0xFFE8F0FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Text(label),
    );
  }
}