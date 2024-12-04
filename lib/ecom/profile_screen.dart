import 'package:bloc_app/ecom/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart' as rive;

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  final ProfileController _profileController = Get.put(ProfileController());
  // rive.SMIBool? isActive;
  late rive.SMIInput<bool> toggleInput; // SMIBool to control the toggle

  @override
  void initState() {
    super.initState();
    // Initialize animation controllers
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Trigger animations after the page loads
    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  void _onTogglePressed() {
    // Update the SMIBool value
    // toggleInput.value = !toggleInput.value;

    // Perform theme change based on the toggle state
    _profileController.toggleDarkMode(toggleInput.value);
    // Toggle the theme
    Get.changeTheme(toggleInput.value ? ThemeData.dark() : ThemeData.light());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Obx(() {
    // Toggle theme based on dark mode state
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        // backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Profile Image and Name Section with Fade and Slide Transition
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FadeTransition(
              opacity: _fadeController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.5, 0), // Slide from right
                  end: Offset.zero, // Final position
                ).animate(_slideController),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg", // Add your profile image URL here
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tushar negi", // You can replace this with dynamic name
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "negitushar@gmail.com", // You can replace this with dynamic name
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          FadeTransition(
            opacity: _fadeController,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.5, 0), // Slide from right
                end: Offset.zero, // Final position
              ).animate(_slideController),
              child: Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Dark Mode',
                          style: TextStyle(fontSize: 16),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: 80,
                            width: 100,
                            child: GestureDetector(
                              onTap: _onTogglePressed,
                              child: rive.RiveAnimation.asset(
                                'assets/rive/switch.riv',
                                stateMachines: const ['Light/Dark Mode Button'],
                                isTouchScrollEnabled: true,
                                onInit: (artboard) {
                                  final stateMachineController = rive.StateMachineController.fromArtboard(
                                    artboard,
                                    'Light/Dark Mode Button',
                                  );
                                  if (stateMachineController != null) {
                                    artboard.addController(stateMachineController);
                                    toggleInput = (stateMachineController.findInput<bool>('Toggle_Is_Pressed'))!;
                                    toggleInput.value = _profileController.isDarkMode.value;
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
          // Profile Menu List with Slide Transition
          Expanded(
            child: FadeTransition(
              opacity: _fadeController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.5, 0), // Slide from right
                  end: Offset.zero, // Final position
                ).animate(_slideController),
                child: ListView(
                  children: [
                    _buildMenuItem(
                      //icon: Icons.list,
                      title: 'My Orders',
                      onTap: () {
                        // Navigate to My Orders screen
                      },
                    ),
                    _buildMenuItem(
                      //  icon: Icons.local_offer,
                      title: 'Offers',
                      onTap: () {
                        // Navigate to Offers screen
                      },
                    ),
                    _buildMenuItem(
                      // icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        // Navigate to Settings screen
                      },
                    ),
                    _buildMenuItem(
                      // icon: Icons.settings,
                      title: 'Logout',
                      trailing: const Icon(Icons.logout),
                      onTap: () {
                        Navigator.of(context).popAndPushNamed('/login');
                        // Navigate to Settings screen
                      },
                    ),

                    // _buildMenuItem(
                    //   // icon: Icons.nightlight_round,
                    //   title: 'Dark Mode',
                    //   trailing: rive.RiveAnimation.asset(
                    //     'assets/rive/switch.riv',
                    //     stateMachines: const ['Light/Dark Mode Button'],
                    //     onInit: (artboard) {
                    //       final stateMachineController = rive.StateMachineController.fromArtboard(
                    //         artboard,
                    //         'Light/Dark Mode Button',
                    //       );
                    //       if (stateMachineController != null) {
                    //         artboard.addController(stateMachineController);

                    //         // Find active state SMIBool
                    //         isActive = stateMachineController.findSMI<rive.SMIBool>('Toggle_Is_Pressed');
                    //         if (isActive?.value ?? false) {
                    //           _profileController.toggleDarkMode(isActive!.value);
                    //           // Toggle the theme
                    //           Get.changeTheme(isActive!.value ? ThemeData.dark() : ThemeData.light());
                    //         }

                    //         if (isActive == null) {
                    //           debugPrint('SMIBool not found: $isActive');
                    //         }
                    //       } else {
                    //         debugPrint('State Machine statemachine not found in ${artboard.name}');
                    //       }
                    //       //  navItem.initialize(artboard);

                    //       // Ensure all icons start in the idle state
                    //       setActive(false);
                    //     },
                    //   ),

                    //   //  Switch(
                    //   //   value: _profileController.isDarkMode.value,
                    //   //   onChanged: (value) {
                    //   //     _profileController.toggleDarkMode(value);
                    //   //     // Toggle the theme
                    //   //     Get.changeTheme(value ? ThemeData.dark() : ThemeData.light());
                    //   //   },
                    //   // ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // );
      // }
    );
  }

  // Helper method to build each menu item
  Widget _buildMenuItem({
    //  required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      // leading: Icon(icon),
      title: Text(title),
      minVerticalPadding: 0,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
