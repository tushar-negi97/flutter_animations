// ignore_for_file: file_names

import 'package:bloc_app/ecom/controller/controller.dart';
import 'package:bloc_app/ecom/homescreen.dart';
import 'package:bloc_app/ecom/notification-screen.dart';
import 'package:bloc_app/ecom/profile_screen.dart';
import 'package:bloc_app/ecom/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  ProfileController controller = Get.put(ProfileController(), permanent: true);
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SearchScreen(),
    const NotificationScreen(),
    // const Text('Home Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    //Text('Profile Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    ProfileScreen()
  ];
  final List<RiveAsset> _navigationItemsLight = [
    RiveAsset("assets/rive/home1.riv", "HOME", "active", "idle", stateMachine: 'HOME_interactivity'),
    RiveAsset("assets/rive/home2.riv", "SEARCH", "active", "idle", stateMachine: 'SEARCH_Interactivity'),
    RiveAsset("assets/rive/search.riv", "BELL", "active", "idle", stateMachine: 'BELL_Interactivity'),
    RiveAsset("assets/rive/bell.riv", "USER", "active", "idle", stateMachine: 'USER_Interactivity'),
  ];
  final List<RiveAsset> _navigationItemsDark = [
    RiveAsset("assets/rive/home_black2.riv", "HOME", "active", "idle", stateMachine: 'HOME_interactivity'),
    RiveAsset("assets/rive/search_black.riv", "SEARCH", "active", "idle", stateMachine: 'SEARCH_Interactivity'),
    RiveAsset("assets/rive/bell_black.riv", "BELL", "active", "idle", stateMachine: 'BELL_Interactivity'),
    RiveAsset("assets/rive/user_black.riv", "USER", "active", "idle", stateMachine: 'USER_Interactivity'),
  ];
  List _navigationItems = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Obx(() {
        // _navigationItems.clear();
        _navigationItems = controller.isDarkMode.value ? _navigationItemsLight : _navigationItemsDark;
        //  _navigationItems[_selectedIndex].setActive(false);

        return BottomNavigationBar(
          iconSize: 15,
          // fixedColor: Colors.purple,
          unselectedFontSize: 0,
          selectedFontSize: 0,
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index != _selectedIndex) {
              // Set the previous icon to idle
              _navigationItems[_selectedIndex].setActive(false);
            }

            // Set the new icon to active and reset to idle after a delay
            _navigationItems[index].setActive(true);
            Future.delayed(const Duration(seconds: 1), () {
              _navigationItems[index].setActive(false);
            });

            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navigationItems.map((navItem) {
            return BottomNavigationBarItem(
              // key: ValueKey(navItem.asset),
              //  backgroundColor: Colors.deepPurple,
              icon: SizedBox(
                height: 35,
                width: 35,
                child: RiveAnimation.asset(
                  navItem.asset,
                  stateMachines: [navItem.stateMachine],
                  onInit: (artboard) {
                    navItem.initialize(artboard);

                    // Ensure all icons start in the idle state
                    navItem.setActive(false);
                  },
                ),
              ),
              label: navItem.label,
            );
          }).toList(),
          unselectedItemColor: Colors.white.withOpacity(0.6),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.shifting,
        );
      }),
    );
  }
}

class RiveAsset {
  final String asset;
  final String label;
  final String stateMachine;
  final String activeState;
  final String idleState;
  SMIBool? isActive;

  RiveAsset(
    this.asset,
    this.label,
    this.activeState,
    this.idleState, {
    this.stateMachine = "State Machine 1",
  });

  void initialize(Artboard artboard) {
    final stateMachineController = StateMachineController.fromArtboard(
      artboard,
      stateMachine,
    );
    if (stateMachineController != null) {
      artboard.addController(stateMachineController);

      // Find active state SMIBool
      isActive = stateMachineController.findSMI<SMIBool>(activeState);
      print('bottonNavbar object === > ${isActive?.value ?? false}');

      if (isActive == null) {
        debugPrint('SMIBool not found: $activeState');
      }
    } else {
      debugPrint('State Machine $stateMachine not found in ${artboard.name}');
    }
  }

  void setActive(bool active) {
    if (isActive != null) {
      isActive!.value = active;
    } else {
      debugPrint('isActive SMIBool not initialized');
    }
  }
}
