import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import '../../models/user.dart';
import '../emergency_page/emergency_page.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false;
  bool isEditing = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for editing fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  
  @override
  void initState() {
    super.initState();
    final user = Provider.of<Auth>(context, listen: false).user;
    if (user != null) {
      nameController = TextEditingController(text: user.name);
      emailController = TextEditingController(text: user.email);
      phoneController = TextEditingController(text: user.phone ?? '');
    } else {
      nameController = TextEditingController();
      emailController = TextEditingController();
      phoneController = TextEditingController();
    }
  }
  
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
  
  // Handle error display with snackbar
  void _handleErrorDisplay(BuildContext context, Auth authProvider) {
    // Only show error if there's an unshown error
    if (authProvider.hasUnshownError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(authProvider.editError!),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        
        // Mark error as shown
        authProvider.markErrorAsShown();
      });
    }
  }
  
  void toggleEditMode() async {
    final authProvider = Provider.of<Auth>(context, listen: false);
    
    if (isEditing) {
      // Validate form before saving
      if (!_formKey.currentState!.validate()) {
        return;
      }
      
      // Save changes
      setState(() {
        isLoading = true;
      });
      
      final currentUser = authProvider.user;
      if (currentUser != null) {
        final updatedUser = User(
          id: currentUser.id,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
          imageUrl: currentUser.imageUrl,
          emergencyContacts: currentUser.emergencyContacts,
        );
        
        final success = await authProvider.editProfile(updatedUser);
        
        setState(() {
          isLoading = false;
          if (success) {
            isEditing = false;
            // Show success snackbar
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isEditing = true;
        nameController.text = authProvider.user?.name ?? '';
        emailController.text = authProvider.user?.email ?? '';
        phoneController.text = authProvider.user?.phone ?? '';
      });
    }
  }
  
  void cancelEdit() {
    final user = Provider.of<Auth>(context, listen: false).user;
    setState(() {
      if (user != null) {
        nameController.text = user.name;
        emailController.text = user.email;
        phoneController.text = user.phone ?? '';
      }
      isEditing = false;
    });
  }
  
  void handleLogout() {
    final authProvider = Provider.of<Auth>(context, listen: false);
    authProvider.logout();
    // Navigate to login page or welcome page
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  // Email validation
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }
  
  // Phone validation (optional field)
  bool isValidPhone(String phone) {
    if (phone.isEmpty) return true; // Phone is optional
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegExp.hasMatch(phone);
  }

  Widget _buildAvatar() {
    final user = Provider.of<Auth>(context).user;
    if (user == null) return CircleAvatar(radius: 50);
    
    if (user.imageUrl != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage(user.imageUrl!),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    final user = authProvider.user;
    
    // Handle error display
    _handleErrorDisplay(context, authProvider);
    
    if (user == null) {
      // Handle case where user is not logged in
      return Scaffold(
        body: Center(
          child: Text('Please log in'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${isEditing ? 'Edit' : 'My'} Profile',
         style: Theme.of(context).textTheme.titleLarge),
        elevation: 0,
        leading: isEditing ? IconButton(
          icon: Icon(Icons.close),
          onPressed: cancelEdit,
        ) : null,
        actions: [
          if (isEditing)
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: isLoading 
                ? CircularProgressIndicator(color: Colors.white)
                : ElevatedButton.icon(
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: toggleEditMode,
                ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: toggleEditMode,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 255, 98, 0).withOpacity(0.4),
                          ),
                        ),
                        _buildAvatar(),
                      ],
                    ),
                    SizedBox(height: isEditing ? 30 : 20),
                    // Personal information section
                    _buildPersonalInfoSection(),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.security, color: Theme.of(context).colorScheme.primary),
                        title: Text("Safety Settings"),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EmergencyContactPage()),
                          );
                        },
                      ),
                      Divider(),
                      SwitchListTile(
                        secondary: Icon(Icons.dark_mode_outlined, color: Theme.of(context).colorScheme.primary),
                        title: Text("Dark Mode"),
                        value: isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            isDarkMode = value;
                          });
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
                        title: Text("Logout", style: TextStyle(color: Colors.red)),
                        onTap: handleLogout,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentindex: 4),
    );
  }
  
  Widget _buildPersonalInfoSection() {
    if (isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!isValidEmail(value.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone (Optional)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
                
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty && !isValidPhone(value.trim())) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );
    } else {
      final user = Provider.of<Auth>(context).user;
      if (user == null) return SizedBox.shrink();
      
      return Column(
        children: [
          Text(
            user.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 4),
          Text(
            user.phone ?? 'No phone number',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }
  }
}