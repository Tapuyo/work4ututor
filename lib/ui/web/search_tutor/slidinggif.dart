// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomGifPageView extends StatefulWidget {
  final List<String> gifUrls;

  const CustomGifPageView({super.key, required this.gifUrls});

  @override
  _CustomGifPageViewState createState() => _CustomGifPageViewState();
}

class _CustomGifPageViewState extends State<CustomGifPageView> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  List<String> gifUrls = [
    'https://media.giphy.com/media/3o7qE0GkUwXGfHwlwo/giphy.gif', // Dancing Cat
    'https://media.giphy.com/media/5ftsmLIqktHQA/giphy.gif', // Happy Dance
    'https://media.giphy.com/media/3oz8xLd9DJq2l2VFtu/giphy.gif', // Excited Dog
    'https://media.giphy.com/media/l4FGI8l7Q6iXz8bIc/giphy.gif', // Baby Yoda
    'https://media.giphy.com/media/26BRv0ThflsHCj3k4/giphy.gif', // Excited Kid
    // Add more valid URLs as needed
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust the height as needed
      child: PageView.custom(
        controller: _pageController,
        physics: BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              width: 200, // Adjust the width as needed
              padding: const EdgeInsets.all(8),
              child: Image.network(
                widget.gifUrls[index],
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error);
                },
                fit: BoxFit.cover,
              ),
            );
          },
          childCount: gifUrls.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
