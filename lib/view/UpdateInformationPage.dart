import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fat_app/Model/UserModel.dart' as AppUser;
import 'package:fat_app/Model/districts_and_wards.dart';
import 'package:fat_app/constants/routes.dart';
import 'package:fat_app/service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateInformationPage extends StatefulWidget {
  @override
  _UpdateInformationPageState createState() => _UpdateInformationPageState();
}

class _UpdateInformationPageState extends State<UpdateInformationPage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? email = FirebaseAuth.instance.currentUser?.email;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedDistrict;
  String? _selectedWard;
  String username = '';
  final UserService _userService = UserService();

  final Map<String, List<String>> _districtsAndWards =
      DistrictsAndWards.MapDN();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userNameController.dispose();
    _classNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {

      final user = this.user;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            username = doc.get('username') as String? ?? '';
          });
          print('Logged in user: $username');
        } else {
          print('User document does not exist');
        }
      } else {
        print('No user is currently logged in');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: CircleAvatar(
            backgroundImage: AssetImage('images/students.png'),
            child: Icon(Icons.person, color: Colors.black),
          ),
          onPressed: () {},
        ),
        title: Text(
          username.isNotEmpty ? username : 'User',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Wrap form for validation
          child: Column(
            children: [
              Text(
                'Update information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _userNameController,
                hintText: 'Enter firstname',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _classNameController,
                hintText: 'Class',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your class';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildDistrictDropdown(),
              SizedBox(height: 16),
              _buildWardDropdown(),
              SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                hintText: 'Enter your street and house number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _selectedDistrict != null &&
                      _selectedWard != null) {
                    AppUser.UserModel newUser = AppUser.UserModel(
                      userName: _userNameController.text,
                      email: email!,
                      role: 'student',
                      userClass: _classNameController.text,
                      position:
                          '$_selectedWard, $_selectedDistrict, Đà Nẵng, ${_addressController.text}', // Cập nhật vị trí
                    );

                    // Get UserID from Firebase Authentication
                    String? userId = FirebaseAuth.instance.currentUser?.uid;


                    if (userId != null) {
                      bool userExists =
                          await _userService.checkUserExits(userId);
                      if (userExists) {
                        print(newUser.toString());
                        await _userService.updateUser(userId, newUser);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Information updated successfully')));
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          interactlearningpage,
                          (route) => false,
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User ID not found')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.lightBlueAccent.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDistrictDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.lightBlueAccent.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      hint: Text('Select District'),
      value: _selectedDistrict,
      isExpanded: true,
      items: _districtsAndWards.keys.map((String district) {
        return DropdownMenuItem<String>(
          value: district,
          child: Text(district),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedDistrict = newValue;
          _selectedWard = null; // Reset ward selection when district changes
        });
      },
    );
  }

  Widget _buildWardDropdown() {
    if (_selectedDistrict == null) {
      return Container(); // Không hiển thị dropdown nếu chưa chọn quận
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.lightBlueAccent.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      hint: Text('Select Ward'),
      value: _selectedWard,
      isExpanded: true,
      items: _districtsAndWards[_selectedDistrict]!.map((String ward) {
        return DropdownMenuItem<String>(
          value: ward,
          child: Text(ward),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedWard = newValue;
        });
      },
    );
  }
}
