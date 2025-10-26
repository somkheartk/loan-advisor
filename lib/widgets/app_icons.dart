import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const AppIcon({
    Key? key,
    this.size = 24,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(size * 0.15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: size * 0.1,
            offset: Offset(0, size * 0.05),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Calculator icon
          Icon(
            Icons.calculate,
            size: size * 0.6,
            color: iconColor ?? Colors.white,
          ),
          // Money symbol overlay
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: size * 0.02,
                ),
              ),
              child: Center(
                child: Text(
                  '฿',
                  style: TextStyle(
                    fontSize: size * 0.15,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Loan type icons
class LoanTypeIcon extends StatelessWidget {
  final LoanType type;
  final double size;
  final Color? color;

  const LoanTypeIcon({
    Key? key,
    required this.type,
    this.size = 24,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor = color ?? Theme.of(context).primaryColor;

    switch (type) {
      case LoanType.house:
        iconData = Icons.home;
        iconColor = color ?? Colors.orange;
        break;
      case LoanType.car:
        iconData = Icons.directions_car;
        iconColor = color ?? Colors.blue;
        break;
      case LoanType.personal:
        iconData = Icons.person;
        iconColor = color ?? Colors.green;
        break;
      case LoanType.other:
        iconData = Icons.account_balance;
        iconColor = color ?? Colors.purple;
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Icon(
        iconData,
        size: size * 0.6,
        color: iconColor,
      ),
    );
  }
}

enum LoanType {
  house,
  car,
  personal,
  other,
}

// Calculator button with icon
class CalculatorIcon extends StatelessWidget {
  final double size;
  final Color? backgroundColor;

  const CalculatorIcon({
    Key? key,
    this.size = 24,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(size * 0.1),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Screen
          Container(
            width: size * 0.8,
            height: size * 0.2,
            margin: EdgeInsets.only(top: size * 0.1),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(size * 0.05),
            ),
            child: Center(
              child: Text(
                '฿15,000',
                style: TextStyle(
                  fontSize: size * 0.08,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Buttons grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size * 0.1),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: size * 0.02,
                crossAxisSpacing: size * 0.02,
                children: List.generate(16, (index) {
                  Color buttonColor = Colors.grey[200]!;
                  if (index % 4 == 3) {
                    buttonColor =
                        index == 15 ? Colors.green[200]! : Colors.orange[200]!;
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(size * 0.02),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
