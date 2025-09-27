import 'package:flutter/material.dart';

class AddHabitBottomSheet extends StatefulWidget {
  final List<IconData> availableIcons;
  final List<Color> availableColors;
  final Function(String, String, IconData, Color) onAddHabit;

  const AddHabitBottomSheet({
    Key? key,
    required this.availableIcons,
    required this.availableColors,
    required this.onAddHabit,
  }) : super(key: key);

  @override
  State<AddHabitBottomSheet> createState() => _AddHabitBottomSheetState();
}

class _AddHabitBottomSheetState extends State<AddHabitBottomSheet>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  IconData _selectedIcon = Icons.fitness_center;
  Color _selectedColor = const Color(0xFF6366F1);

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.availableIcons.first;
    _selectedColor = widget.availableColors.first;

    // Animation controllers
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Animations
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  void _showColorPickerModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildColorPicker(),
    );
  }

  Widget _buildColorPicker() {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F23),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Text(
            "Choose Color",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 32),

          // Color grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: widget.availableColors.length,
                itemBuilder: (context, index) {
                  final color = widget.availableColors[index];
                  final isSelected = color == _selectedColor;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.5),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveHabit() {
    if (_titleController.text.trim().isEmpty) {
      _showErrorMessage("Please enter a habit name");
      return;
    }

    String subtitle = _subtitleController.text.trim();
    if (subtitle.isEmpty) subtitle = "Daily";

    widget.onAddHabit(
      _titleController.text.trim(),
      subtitle,
      _selectedIcon,
      _selectedColor,
    );

    Navigator.of(context).pop();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.6),
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.88,
              margin: const EdgeInsets.only(top: 60),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F0F23),
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                  ],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  // Floating handle with glow
                  Container(
                    width: 48,
                    height: 5,
                    margin: const EdgeInsets.only(top: 16, bottom: 32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _selectedColor,
                          _selectedColor.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: _selectedColor.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with gradient text
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.8),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              "Create New Habit",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            "Build something amazing, one day at a time",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Floating input card for habit name
                          _buildFloatingInputCard(
                            label: "Habit Name",
                            controller: _titleController,
                            hint: "e.g. Morning meditation",
                            icon: Icons.lightbulb_outline_rounded,
                          ),

                          const SizedBox(height: 24),

                          // Floating input card for frequency
                          _buildFloatingInputCard(
                            label: "Frequency",
                            controller: _subtitleController,
                            hint: "Daily",
                            icon: Icons.repeat_rounded,
                          ),

                          const SizedBox(height: 32),

                          // Icon selection with floating cards
                          Text(
                            "Choose Icon",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: -0.2,
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            height: 68,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.availableIcons.length,
                              itemBuilder: (context, index) {
                                final icon = widget.availableIcons[index];
                                final isSelected = icon == _selectedIcon;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIcon = icon;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: 64,
                                    height: 64,
                                    margin: const EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: [
                                                _selectedColor,
                                                _selectedColor.withOpacity(0.8),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.1),
                                                Colors.white.withOpacity(0.05),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.white.withOpacity(0.1),
                                        width: 1.5,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: _selectedColor
                                                    .withOpacity(0.3),
                                                blurRadius: 12,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Icon(
                                      icon,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.7),
                                      size: 26,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Color selection
                          Text(
                            "Color Theme",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: -0.2,
                            ),
                          ),

                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: _showColorPickerModal,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: _selectedColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _selectedColor.withOpacity(0.4),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.palette_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Live preview card
                          if (_titleController.text.isNotEmpty) ...[
                            Text(
                              "Preview",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: -0.2,
                              ),
                            ),

                            const SizedBox(height: 16),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    _selectedColor,
                                    _selectedColor.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: _selectedColor.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      _selectedIcon,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _titleController.text,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _subtitleController.text.isEmpty
                                              ? "Daily"
                                              : _subtitleController.text,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Bottom action buttons with glassmorphism
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            text: "Cancel",
                            onPressed: () => Navigator.of(context).pop(),
                            isPrimary: false,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: _buildActionButton(
                            text: "Create Habit",
                            onPressed: _saveHabit,
                            isPrimary: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingInputCard({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
          ),
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(0.6),
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? _selectedColor : Colors.transparent,
          foregroundColor: Colors.white,
          elevation: isPrimary ? 8 : 0,
          shadowColor: isPrimary ? _selectedColor.withOpacity(0.4) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
