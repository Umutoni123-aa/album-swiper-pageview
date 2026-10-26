import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(const AlbumApp());

class AlbumApp extends StatelessWidget {
  const AlbumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      // Show the album demo as the first screen.
      home: const FeaturedAlbums(),
    );
  }
}

// Store the made-up album information in one simple list.
final List<Map<String, dynamic>> albums = [
  {'name': 'Midnight Drive', 'artist': 'Luna Ray', 'color': Colors.deepPurple},
  {'name': 'Golden Hour', 'artist': 'The Sunsets', 'color': Colors.orange},
  {'name': 'Ocean Eyes', 'artist': 'Kai Waves', 'color': Colors.teal},
  {'name': 'Velvet Sky', 'artist': 'Nova', 'color': Colors.pink},
  {'name': 'Green Light', 'artist': 'Echo Park', 'color': Colors.green},
];

// Use a StatefulWidget because the three controls change the screen live.
class FeaturedAlbums extends StatefulWidget {
  const FeaturedAlbums({super.key});

  @override
  State<FeaturedAlbums> createState() => _FeaturedAlbumsState();
}

// Keep the PageView settings and current page in state.
class _FeaturedAlbumsState extends State<FeaturedAlbums> {
  // Start with the PageView defaults used in the presentation.
  Axis _scrollDirection = Axis.horizontal;
  double _viewportFraction = 1.0;
  bool _pageSnapping = true;
  int _currentPage = 0;

  // Let the PageView know which page is currently visible.
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Create a controller with the starting viewport fraction.
    _pageController = PageController(viewportFraction: _viewportFraction);
    // Listen for swipes so the dot indicators can update.
    _pageController.addListener(_updateCurrentPage);
  }

  // Read the controller's page and redraw the indicators when it changes.
  void _updateCurrentPage() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage && mounted) {
      setState(() => _currentPage = page);
    }
  }

  // Rebuild the controller because viewportFraction is set when it is created.
  void _changeViewportFraction(double fraction) {
    final page = _pageController.page?.round() ?? _currentPage;
    _pageController.removeListener(_updateCurrentPage);
    _pageController.dispose();
    _viewportFraction = fraction;
    _currentPage = page;
    _pageController = PageController(
      initialPage: page,
      viewportFraction: fraction,
    );
    _pageController.addListener(_updateCurrentPage);
    setState(() {});
  }

  @override
  void dispose() {
    // Release the controller when the screen is removed.
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Featured Albums'),
      ),
      // Keep the PageView and its controls together in one column.
      body: Column(
        children: [
          // Give the PageView the main space on the screen.
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              // Change between left-to-right and top-to-bottom scrolling.
              scrollDirection: _scrollDirection,
              // Allow either a full page snap or free scrolling.
              pageSnapping: _pageSnapping,
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                // Draw one made-up album cover.
                return Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: album['color'] as Color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.music_note, size: 80, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        album['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        album['artist'] as String,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Show one small dot for every album and highlight the current one.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                albums.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPage ? Colors.white : Colors.white38,
                  ),
                ),
              ),
            ),
          ),
          // Put the three live PageView controls below the dots.
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                // Change the direction used by the PageView.
                _ControlRow(
                  label: 'Direction',
                  options: [
                    _ControlOption(
                      label: 'Horizontal',
                      selected: _scrollDirection == Axis.horizontal,
                      onPressed: () => setState(
                        () => _scrollDirection = Axis.horizontal,
                      ),
                    ),
                    _ControlOption(
                      label: 'Vertical',
                      selected: _scrollDirection == Axis.vertical,
                      onPressed: () => setState(
                        () => _scrollDirection = Axis.vertical,
                      ),
                    ),
                  ],
                ),
                // Change how much of the next page is visible.
                _ControlRow(
                  label: 'Width',
                  options: [
                    _ControlOption(
                      label: '1.0',
                      selected: _viewportFraction == 1.0,
                      onPressed: () => _changeViewportFraction(1.0),
                    ),
                    _ControlOption(
                      label: '0.8',
                      selected: _viewportFraction == 0.8,
                      onPressed: () => _changeViewportFraction(0.8),
                    ),
                  ],
                ),
                // Choose whether scrolling stops exactly on a page.
                _ControlRow(
                  label: 'Snapping',
                  options: [
                    _ControlOption(
                      label: 'On',
                      selected: _pageSnapping,
                      onPressed: () => setState(() => _pageSnapping = true),
                    ),
                    _ControlOption(
                      label: 'Off',
                      selected: !_pageSnapping,
                      onPressed: () => setState(() => _pageSnapping = false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Describe one button in a control row.
class _ControlOption {
  const _ControlOption({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
}

// Keep each group of related controls small and easy to explain.
class _ControlRow extends StatelessWidget {
  const _ControlRow({required this.label, required this.options});

  final String label;
  final List<_ControlOption> options;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 82,
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
        ...options.map(
          (option) => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(option.label),
              selected: option.selected,
              onSelected: (_) => option.onPressed(),
            ),
          ),
        ),
      ],
    );
  }
}
