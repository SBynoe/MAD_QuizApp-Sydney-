import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'create_flascards_screen.dart';
import 'browse_flashcards_screen.dart';
import 'quiz_mode_screen.dart';

class HomeScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out
  void signOutUser(BuildContext context) {
    FirebaseAuth.instance.signOut();
    // After signing out, navigate back to the sign-in screen
    Navigator.pushReplacementNamed(context, '/signin');
  }

  void showCreateFlashcardsDialog(BuildContext context) {
    List<String> categories = [
      'Math',
      'World History',
      'Literature',
      'Science'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedCategory;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create or Select Category'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => showAddCategoryDialog(
                          context, categories, () => setState(() {})),
                      child: const Text('Add New Category'),
                    ),
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text('Select a category'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showAddCategoryDialog(
      BuildContext context, List<String> categories, VoidCallback onUpdated) {
    final TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Category"),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(hintText: "Enter category name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                final String categoryName = categoryController.text.trim();
                if (categoryName.isNotEmpty) {
                  categories.add(categoryName);
                  onUpdated();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CreateFlashcardScreen(categoryName: categoryName),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      backgroundColor: const Color.fromARGB(255, 124, 168, 201),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Logged In As: ${user?.email ?? 'N/A'}",
                style: const TextStyle(fontSize: 18, color: Colors.black)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => showCreateFlashcardsDialog(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 77, 104, 255)),
              child: const Text('Create Flashcards',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            // Additional buttons here...
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrowseFlashcardsScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(
                    255, 77, 104, 255), // Match sign-in button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8), // Match sign-in button border radius
                ),
              ),
              child: Text(
                'Browse Flashcards',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizModeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(
                    255, 77, 104, 255), // Match sign-in button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8), // Match sign-in button border radius
                ),
              ),
              child: Text(
                'Quiz Mode',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => signOutUser(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(
                    255, 221, 46, 68), // Use consistent sign-out button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8), // Match sign-in button border radius
                ),
              ),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
