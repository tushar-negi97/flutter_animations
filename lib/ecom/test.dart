import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveBottomNavigation extends StatefulWidget {
  const RiveBottomNavigation({Key? key}) : super(key: key);

  @override
  _RiveBottomNavigationState createState() => _RiveBottomNavigationState();
}

class _RiveBottomNavigationState extends State<RiveBottomNavigation> {
  int _selectedIndex = 0;
  final List<RiveAsset> _navigationItems = [
    RiveAsset("assets/rive/animated_icon_set.riv", "HOME", "active", "idle"),
    RiveAsset("assets/rive/animated_icon_set.riv", "SEARCH", "active", "idle"),
    RiveAsset("assets/rive/animated_icon_set.riv", "USER", "active", "idle"),
    RiveAsset("assets/rive/animated_icon_set.riv", "SETTINGS", "active", "idle"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Selected: ${_navigationItems[_selectedIndex].label}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Play the active animation for the selected item
          _navigationItems[index].playActiveAnimation();
        },
        items: _navigationItems.map((navItem) {
          return BottomNavigationBarItem(
            icon: SizedBox(
              height: 40,
              width: 40,
              child: RiveAnimation.asset(
                navItem.asset,
                stateMachines: [navItem.stateMachine],
                onInit: (artboard) {
                  navItem.initialize(artboard);
                  if (_navigationItems.indexOf(navItem) == _selectedIndex) {
                    navItem.playActiveAnimation();
                  } else {
                    navItem.playIdleAnimation();
                  }
                },
              ),
            ),
            label: navItem.label,
          );
        }).toList(),
      ),
    );
  }
}

class RiveAsset {
  final String asset;
  final String label;
  final String stateMachine;
  final String activeState;
  final String idleState;
  late SMITrigger? activeTrigger;
  late SMITrigger? idleTrigger;

  RiveAsset(this.asset, this.label, this.activeState, this.idleState, {this.stateMachine = "State Machine 1"});

  void initialize(Artboard artboard) {
    final stateMachineController = StateMachineController.fromArtboard(
      artboard,
      stateMachine,
    );
    if (stateMachineController != null) {
      artboard.addController(stateMachineController);
      activeTrigger = stateMachineController.findSMI<SMITrigger>(activeState);
      idleTrigger = stateMachineController.findSMI<SMITrigger>(idleState);
    }
  }

  void playActiveAnimation() {
    activeTrigger?.fire();
  }

  void playIdleAnimation() {
    idleTrigger?.fire();
  }
}
