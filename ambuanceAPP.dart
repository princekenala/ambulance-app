import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


void main() async {
 WidgetsFlutterBinding.ensureInitialized();
final database = openDatabase(
  join(await getDatabasesPath(), 'ambulance.db'),
  onCreate: (db, version) {
    db.execute(
      '''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        full_name TEXT,
        email TEXT,
        password TEXT
      )
      ''',
    );
    db.execute(
      '''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY,
        f_name TEXT,
        email TEXT,
        phoneNumber TEXT,
        address TEXT
      )
      ''',
    );
  },
  version: 2,
);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Future<Database> database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white, // Set the background color to white
        canvasColor: Colors.red, // Set the canvas color to blue
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black), // Set the text color to blue
        ),
      ),
      home: LoginPage(database: database),
    );
  }
}


class MainPage extends StatelessWidget {
  final Future<Database> database;

  MainPage({required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AMBULANCE SERVICES'),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return buildCard(context, index);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget buildCard(BuildContext context, int index) {
    switch (index) {
      case 0:
        return buildCardItem(
          icon: Icons.local_hospital,
          title: 'Search for nearest Hospital',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchNearestHospital()),
            );
          },
        );
      case 1:
        return buildCardItem(
          icon: Icons.bus_alert,
          title: 'Search for Nearest Ambulance',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocateAmbulancePage(),
              ),
            );
          },
        );
      case 2:
        return buildCardItem(
          icon: Icons.book,
          title: 'Book an Ambulance',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookAmbulance(database: database),
              ),
            );
          },
        );
      
      case 3:
        return buildCardItem(
          icon: Icons.report,
          title: 'Report ',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManageProfilePage()),
            );
          },
        );
       
      default:
        return SizedBox.shrink();
    }
  }

  Widget buildCardItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          size: 40,
          color: Colors.red,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        tileColor: Colors.white,
        onTap: onTap,
      ),
    );
  }
}


class SearchNearestHospital extends StatefulWidget {
  @override
  _SearchNearestHospitalState createState() => _SearchNearestHospitalState();
}

class _SearchNearestHospitalState extends State<SearchNearestHospital> {
  void openGoogleMaps() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=hospitals+and+clinics+in+Zimbambwe+in+Gweru';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';

        
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Hospitals and Clinics'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.local_hospital_sharp,
              size: 64.0,
              color: Colors.red,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text(
                'Search Nearest Hospitals and Clinics',
                style: TextStyle(fontSize: 24.0),
              ),
              onPressed: () => openGoogleMaps(),
            ),
          ],
        ),
      ),
    );
  }
}


class BookAmbulance extends StatelessWidget {
  final Future<Database> database;

  BookAmbulance({required this.database});

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _phoneNumberController = TextEditingController();
    TextEditingController _addressController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Ambulance'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                String email = _emailController.text;
                String phoneNumber = _phoneNumberController.text;
                String address = _addressController.text;

                if (name.isEmpty ||
                    email.isEmpty ||
                    phoneNumber.isEmpty ||
                    address.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please fill in all fields.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Database db = await database;
                  await db.transaction((txn) async {
                    await txn.rawInsert(
                      'INSERT INTO books ( email, phoneNumber, address) VALUES ( ?, ?, ?)',
                      [ email, phoneNumber, address],
                    );
                  });

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('Ambulance booked successfully.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Book Ambulance'),
            ),
          ],
        ),
      ),
    );
  }
}
class LocateAmbulancePage extends StatefulWidget {
  @override
  _LocateAmbulancePageState createState() => _LocateAmbulancePageState();
}

class _LocateAmbulancePageState extends State<LocateAmbulancePage> {
  List<LatLng> _randomLocations = [
    LatLng(-17.829220, 31.052960),
    LatLng(-18.923872, 29.823544),
    LatLng(-19.015438, 29.154857),
    // Add more random locations in Zimbabwe
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locate Ambulance'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _randomLocations.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                'Ambulance ${index + 1}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Latitude: ${_randomLocations[index].latitude.toString()}\n'
                'Longitude: ${_randomLocations[index].longitude.toString()}',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
  
class ManageProfilePage extends StatefulWidget {
  @override
  _ManageProfilePageState createState() => _ManageProfilePageState();
}

class _ManageProfilePageState extends State<ManageProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _reportController = TextEditingController(); // New controller for the report message
  bool _reportSubmitted = false; // Track if the report was submitted

  @override
  void dispose() {
    _passwordController.dispose();
    _nameController.dispose();
    _reportController.dispose(); // Dispose the report controller
    super.dispose();
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate()) {
    
      // Send the report to admin authorities
      String reportMessage = _reportController.text;
      sendReport(reportMessage);
    }
  }

  void sendReport(String reportMessage) {
    // Implement your logic to send the report to the admin authorities
    // For example, you can use an API request or any other communication method
    // Here, we're simply printing the report message
    print('Report Message: $reportMessage');

    // Set the flag to indicate that the report was submitted
    setState(() {
      _reportSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report to Ambulance Facilitator ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _reportController,
                maxLines: 5, // Set maxLines to make the input box larger
                decoration: InputDecoration(
                  hintText: 'Enter your report message',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your report';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => updateProfile(),
                child: Text('Submit Report'),
              ),
              SizedBox(height: 16.0),
              if (_reportSubmitted) // Show the confirmation message if the report was submitted
                Text(
                  'Your report have been send to ambulance facilitator!!!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


class LoginPage extends StatefulWidget {
  final Future<Database> database;

  LoginPage({required this.database});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 75.0,
              backgroundImage: AssetImage('assets/ambulance_avatar.png'), // Replace with the path to your ambulance avatar image
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;

                if (email.isEmpty || password.isEmpty) {
                  // Show an error message if any of the fields are empty
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter your credentials.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Check if the user exists in the database
                  Database db = await widget.database;
                  List<Map<String, dynamic>> users = await db.rawQuery(
                      "SELECT * FROM users WHERE email = '$email' AND password = '$password'");

                  // Check if the user is an admin
                  bool isAdmin = email == 'admin@gmail.com' && password == 'admin123';
                  if (isAdmin) {
                    // Navigate to the admin's home page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminHomePage(database: widget.database),
                      ),
                    );
                  } else if (users.isNotEmpty) {
                    // Navigate to the user's home page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(database: widget.database),
                      ),
                    );
                  } else {
                    // Show an error message if the credentials are incorrect
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Your are not registered or your credentials are incorrect.'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            Text('Don\'t have an account?'),
            TextButton(
              onPressed: () {
                // Navigate to the signup page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupPage(database: widget.database),
                  ),
                );
              },
              child: Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
class AdminHomePage extends StatelessWidget {
  final Future<Database> database;

  AdminHomePage({required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.local_hospital,
                  color: Colors.red,
                ),
                title: Text(
                  'View Booked Ambulances',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  // Navigate to the page to view booked ambulances
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewBookedAmbulancesPage(database: database),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.people,
                  color: Colors.red,
                ),
                title: Text(
                  'Number of Users',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  // Navigate to the page to view the number of users
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NumberOfUsersPage(database: database),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.description,
                  color: Colors.red,
                ),
                title: Text(
                  'Generate Reports',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  // Navigate to the page to generate reports
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerateReportsPage(database: database),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.manage_accounts,
                  color: Colors.red,
                ),
                title: Text(
                  'Manage Accounts',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  // Navigate to the page to manage accounts
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageAccountsPage(database: database),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewBookedAmbulancesPage extends StatefulWidget {
  final Future<Database> database;

  ViewBookedAmbulancesPage({required this.database});

  @override
  _ViewBookedAmbulancesPageState createState() => _ViewBookedAmbulancesPageState();
}

class _ViewBookedAmbulancesPageState extends State<ViewBookedAmbulancesPage> {
  List<Map<String, dynamic>> _bookedAmbulances = [];
  List<Map<String, dynamic>> _filteredAmbulances = [];

  TextEditingController _searchController = TextEditingController();
  void openGoogleMaps() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=Zimbambwe+in+Gweru';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
        
    }
  }

  @override
  void initState() {
    super.initState();
    _getBookedAmbulances();
  }

  Future<void> _getBookedAmbulances() async {
    final db = await widget.database;
    final List<Map<String, dynamic>> ambulances = await db.query('books');
    setState(() {
      _bookedAmbulances = ambulances;
      _filteredAmbulances = ambulances;
    });
  }

  void _filterAmbulances(String query) {
    setState(() {
      _filteredAmbulances = _bookedAmbulances
          .where((ambulance) =>
              ambulance['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
              ambulance['location'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Booked Ambulances'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterAmbulances(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
  itemCount: _filteredAmbulances.length,
  itemBuilder: (BuildContext context, int index) {
    final ambulance = _filteredAmbulances[index];
    return ListTile(
      title: Text(ambulance['email']),
      subtitle: Text(ambulance['address']),
      tileColor: Colors.lightBlue,
      trailing: ElevatedButton(
        onPressed: () => openGoogleMaps(),
        child: Text('View Location'),
      ),
    );
  },
)
          ),
          
        ],
        

        
      ),
      
    );
  }
}

class NumberOfUsersPage extends StatefulWidget {
  final Future<Database> database;

  NumberOfUsersPage({required this.database});

  @override
  _NumberOfUsersPageState createState() => _NumberOfUsersPageState();
}

class _NumberOfUsersPageState extends State<NumberOfUsersPage> {
  int _numberOfUsers = 0;

  @override
  void initState() {
    super.initState();
    _getNumberOfUsers();
  }

  Future<void> _getNumberOfUsers() async {
    final db = await widget.database;
    final List<Map<String, dynamic>> users = await db.query('users');
    setState(() {
      _numberOfUsers = users.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number of Users'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blue,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Number of Users',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                _numberOfUsers.toString(),
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenerateReportsPage extends StatefulWidget {
  final Future<Database> database;

  GenerateReportsPage({required this.database});

  @override
  _GenerateReportsPageState createState() => _GenerateReportsPageState();
}

class _GenerateReportsPageState extends State<GenerateReportsPage> {
  List<Map<String, dynamic>> _bookedAmbulances = [];

  @override
  void initState() {
    super.initState();
    _getBookedAmbulances();
  }

  Future<void> _getBookedAmbulances() async {
    final db = await widget.database;
    final List<Map<String, dynamic>> ambulances = await db.query('books');
    setState(() {
      _bookedAmbulances = ambulances;
    });
  }

  void _printReport() {
    // Implement the logic to print the report
    // You can use a printing library or platform-specific code to handle printing
    // For example, you can use the `flutter_blue_thermal` package for printing with Bluetooth thermal printers
    // or use the `printing` package for printing to PDF or physical printers.
    // This implementation will depend on the specific printer and requirements you have.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Reports'),
      ),
      body: ListView.builder(
        itemCount: _bookedAmbulances.length,
        itemBuilder: (BuildContext context, int index) {
          final ambulance = _bookedAmbulances[index];
          return ListTile(
            title: Text(ambulance['email']),
            subtitle: Text(ambulance['address']),
            tileColor: Colors.lightBlue,
            
            
            //subtitle: Text(ambulance['phonenumber']),
            // Add more details as needed
            // Customize the ListTile with more widgets to display additional information
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _printReport,
        child: Icon(Icons.print),
      ),
    );
  }
}


class ManageAccountsPage extends StatefulWidget {
  final Future<Database>? database;

  ManageAccountsPage({required this.database});

  @override
  _ManageAccountsPageState createState() => _ManageAccountsPageState();
}

class _ManageAccountsPageState extends State<ManageAccountsPage> {
  List<Map<String, dynamic>> _accounts = [];
  List<Map<String, dynamic>> _filteredAccounts = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAccounts();
  }

  Future<void> _getAccounts() async {
    final db = await widget.database;
    if (db != null) {
      final List<Map<String, dynamic>> accounts = await db.query('users');
      setState(() {
        _accounts = accounts;
        _filteredAccounts = accounts;
      });
    }
  }

 void _editAccount(int accountId) {
  showDialog(
    context: this.context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Account'),
        content: Text('Implement the form to edit the account here.'),
        actions: [
          TextButton(
            child: Text('Save'),
            onPressed: () {
              // Perform the save logic here
              // Update the account data in the _accounts and _filteredAccounts lists
              setState(() {
                // Update the account details in the lists
              });
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

  void _deleteAccount(int accountId) {
    // Implement the logic to delete the account
    // Show a confirmation dialog before deleting the account
  }

  void _searchAccounts(String searchText) {
    setState(() {
      _filteredAccounts = _accounts
          .where((account) =>
              account['name'] != null &&
              account['name']!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Accounts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchAccounts,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredAccounts.length,
              itemBuilder: (BuildContext context, int index) {
                final account = _filteredAccounts[index];
                final accountId = account['id'] as int?;
                final accountName = account['name'] as String?;
                final accountEmail = account['email'] as String?;
                return ListTile(
                  title: Text(accountName ?? ''),
                  subtitle: Text(accountEmail ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editAccount(accountId ?? 0),
                  ),
                  onLongPress: () => _deleteAccount(accountId ?? 0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SignupPage extends StatelessWidget {
  final Future<Database> database;

  SignupPage({required this.database});

  @override
  Widget build(BuildContext context) {
    TextEditingController _fullNameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/ambulance_avatar.png'), 
              // Replace with the path to your ambulance avatar image
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                 String fullName = _fullNameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                String confirmPassword = _confirmPasswordController.text;

                if (fullName.isEmpty ||
                    email.isEmpty ||
                    password.isEmpty ||
                    confirmPassword.isEmpty) {
                  // Show an error message if any of the fields are empty
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please fill in all fields.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (password != confirmPassword) {
                  // Show an error message if passwords do not match
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Passwords do not match.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (!email.endsWith('@gmail.com')) {
                  // Show an error message if email is not in the correct format
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Invalid email format.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Insert the user data into the database
                  Database db = await database;
                  await db.transaction((txn) async {
                    await txn.rawInsert(
                      'INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)',
                      [fullName, email, password],
                    );
                  });

                  // Show a success message
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('Successfully signed up.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }

                // Rest of the code remains unchanged
                // ...
              },
              child: Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
