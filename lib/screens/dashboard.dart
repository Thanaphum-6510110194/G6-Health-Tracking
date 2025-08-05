import 'package:flutter/material.dart';
import 'package:health_tracking/screens/daily_habits.dart';
import 'meal_logging.dart';

const Color primaryColor = Color(0xFF0ABAB5);
const Color secondaryColor = Color(0xFF56DFCF);

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                _buildQuickActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good Morning, Alex!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Today • March 15, 2024',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        // The profile picture placeholder
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: primaryColor,
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

  Widget _buildHealthMetricCards() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildMetricCard(
            icon: Icons.water_drop,
            value: '6/8',
            unit: 'Glasses today',
            iconColor: primaryColor,
            cardColor: secondaryColor.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildMetricCard(
            icon: Icons.directions_run,
            value: '7,234',
            unit: 'Steps today',
            iconColor: primaryColor,
            cardColor: secondaryColor.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String unit,
    required Color iconColor,
    required Color cardColor,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              unit,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Today's Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildProgressItem({
    required IconData icon,
    required String label,
    required double progress,
    required String progressText,
  }) {
    return Row(
      children: [
        Icon(icon, color: primaryColor),
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
                  backgroundColor: secondaryColor.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
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

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            // The grid for the buttons
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true, // Important to allow GridView inside Column
              physics:
                  const NeverScrollableScrollPhysics(), // Disables scrolling for the grid
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 2.5, // Adjusts the height of the buttons
              children: <Widget>[
                _buildActionButton(label: 'Log Water', context: context),
                _buildActionButton(label: 'Add Meal', context: context),
                _buildActionButton(label: 'Track Mood', context: context),
                _buildActionButton(label: 'Log Exercise', context: context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required String label, required BuildContext context}) {
    return ElevatedButton(
      onPressed: () {
        Widget? screenToNavigate;

        if (label == 'Log Water') {
          screenToNavigate = HabitTrackerApp();
          
        } else if (label == 'Add Meal') {
          screenToNavigate = MealLoggingScreen();
        } else if (label == 'Track Mood') {
          // screenToNavigate = TrackMoodScreen();
        } else if (label == 'Log Exercise') {
          screenToNavigate = HabitTrackerApp(); // Placeholder for future screen
          // screenToNavigate = LogExerciseScreen();
        } else {
          screenToNavigate = null;
        }

        if (screenToNavigate != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screenToNavigate!),
          );
        } else {
          print('No specific screen found for: $label');
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryColor,
        backgroundColor: secondaryColor.withValues(alpha: 0.2),
        overlayColor: secondaryColor,
        
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      
      child: Text(label),
    );
  }
}
