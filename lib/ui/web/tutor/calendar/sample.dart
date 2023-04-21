import 'package:flutter/material.dart';

class ReactionButton extends StatefulWidget {
  @override
  _ReactionButtonState createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  bool _isReactionShown = false;
  String _selectedReaction = '';

  final List<String> _reactions = [    'like',    'love',    'haha',    'wow',    'sad',    'angry'  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
       children: [Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _reactions.map((reaction) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isReactionShown = true;
                      _selectedReaction = reaction;
                    });
                  },
                  child: Icon(
                    _selectedReaction == reaction
                        ? getSelectedIcon(reaction)
                        : getUnselectedIcon(reaction),
                    color: _selectedReaction == reaction
                        ? getColor(reaction)
                        : Colors.black,
                    size: 24,
                  ),
                );
              }).toList(),
            ),
          ),
          _isReactionShown
              ? Container(
                  margin: EdgeInsets.only(top: 68, right: 16),
                  width: 200,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _reactions.map((reaction) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _isReactionShown = false;
                          });
                        },
                        child: Container(
                          width: _selectedReaction == reaction ? 50 : 40,
                          height: _selectedReaction == reaction ? 50 : 40,
                          decoration: BoxDecoration(
                            color: _selectedReaction == reaction
                                ? getColor(reaction)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(
                                _selectedReaction == reaction ? 25 : 20),
                          ),
                          child: Icon(
                            getSelectedIcon(reaction),
                            color: Colors.white,
                            size: _selectedReaction == reaction ? 24 : 20,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : SizedBox.shrink(),
              Container(
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _reactions.map((reaction) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isReactionShown = true;
                      _selectedReaction = reaction;
                    });
                  },
                  child: Icon(
                    _selectedReaction == reaction
                        ? getSelectedIcon(reaction)
                        : getUnselectedIcon(reaction),
                    color: _selectedReaction == reaction
                        ? getColor(reaction)
                        : Colors.black,
                    size: 24,
                  ),
                );
              }).toList(),
            ),
          ),
          _isReactionShown
              ? Container(
                  margin: EdgeInsets.only(top: 68, right: 16),
                  width: 200,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _reactions.map((reaction) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _isReactionShown = false;
                          });
                        },
                        child: Container(
                          width: _selectedReaction == reaction ? 50 : 40,
                          height: _selectedReaction == reaction ? 50 : 40,
                          decoration: BoxDecoration(
                            color: _selectedReaction == reaction
                                ? getColor(reaction)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(
                                _selectedReaction == reaction ? 25 : 20),
                          ),
                          child: Icon(
                            getSelectedIcon(reaction),
                            color: Colors.white,
                            size: _selectedReaction == reaction ? 24 : 20,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : SizedBox.shrink(),
              Container(
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _reactions.map((reaction) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isReactionShown = true;
                      _selectedReaction = reaction;
                    });
                  },
                  child: Icon(
                    _selectedReaction == reaction
                        ? getSelectedIcon(reaction)
                        : getUnselectedIcon(reaction),
                    color: _selectedReaction == reaction
                        ? getColor(reaction)
                        : Colors.black,
                    size: 24,
                  ),
                );
              }).toList(),
            ),
          ),
          _isReactionShown
              ? Container(
                  margin: EdgeInsets.only(top: 68, right: 16),
                  width: 200,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _reactions.map((reaction) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _isReactionShown = false;
                          });
                        },
                        child: Container(
                          width: _selectedReaction == reaction ? 50 : 40,
                          height: _selectedReaction == reaction ? 50 : 40,
                          decoration: BoxDecoration(
                            color: _selectedReaction == reaction
                                ? getColor(reaction)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(
                                _selectedReaction == reaction ? 25 : 20),
                          ),
                          child: Icon(
                            getSelectedIcon(reaction),
                            color: Colors.white,
                            size: _selectedReaction == reaction ? 24 : 20,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : SizedBox.shrink(),
              Container(
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _reactions.map((reaction) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isReactionShown = true;
                      _selectedReaction = reaction;
                    });
                  },
                  child: Icon(
                    _selectedReaction == reaction
                        ? getSelectedIcon(reaction)
                        : getUnselectedIcon(reaction),
                    color: _selectedReaction == reaction
                        ? getColor(reaction)
                        : Colors.black,
                    size: 24,
                  ),
                );
              }).toList(),
            ),
          ),
          _isReactionShown
              ? Container(
                  margin: EdgeInsets.only(top: 68, right: 16),
                  width: 200,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _reactions.map((reaction) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _isReactionShown = false;
                          });
                        },
                        child: Container(
                          width: _selectedReaction == reaction ? 50 : 40,
                          height: _selectedReaction == reaction ? 50 : 40,
                          decoration: BoxDecoration(
                            color: _selectedReaction == reaction
                                ? getColor(reaction)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(
                                _selectedReaction == reaction ? 25 : 20),
                          ),
                          child: Icon(
                            getSelectedIcon(reaction),
                            color: Colors.white,
                            size: _selectedReaction == reaction ? 24 : 20,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
       ],
    );
  }

  IconData getSelectedIcon(String reaction) {
    switch (reaction) {
      case 'like':
        return Icons.thumb_up_alt;
      case 'love':
        return Icons.favorite;
      case 'haha':
        return Icons.emoji_emotions;
      case 'wow':
        return Icons.sentiment_satisfied_alt;
      case 'sad':
        return Icons.sentiment_very_dissatisfied;
      case 'angry':
        return Icons.mood_bad;
      default:
        return Icons.thumb_up_alt;
    }
  }

  IconData getUnselectedIcon(String reaction) {
    switch (reaction) {
      case 'like':
        return Icons.thumb_up_outlined;
      case 'love':
        return Icons.favorite_border;
      case 'haha':
        return Icons.emoji_emotions_outlined;
      case 'wow':
        return Icons.sentiment_satisfied_outlined;
      case 'sad':
        return Icons.sentiment_very_dissatisfied_outlined;
      case 'angry':
        return Icons.mood_bad_outlined;
      default:
        return Icons.thumb_up_outlined;
    }
  }

  Color getColor(String reaction) {
    switch (reaction) {
      case 'like':
        return Colors.blue;
      case 'love':
        return Colors.red;
      case 'haha':
        return Colors.orange;
      case 'wow':
        return Colors.yellow;
      case 'sad':
        return Colors.grey;
      case 'angry':
        return Colors.redAccent;
      default:
        return Colors.blue;
    }
  }
}
