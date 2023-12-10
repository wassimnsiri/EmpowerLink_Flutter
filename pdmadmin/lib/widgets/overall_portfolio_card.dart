  import '../../utils/colors.dart';
  import '../../utils/media_query_values.dart';
  import 'package:flutter/material.dart';

  import 'custom_button.dart';
  import 'outline_button.dart';
  import 'total_widget.dart';

 class OverallPortfolioCard extends StatelessWidget {
  const OverallPortfolioCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0, -90, 0),
      width: context.width * 0.65,
      height: context.height * 0.24,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
      decoration: BoxDecoration(
        color: lightBlack.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'EmpowerLink',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              CustomOutlineButton(
                width: context.width * 0.08,
                title: 'Withdraw',
              ),
              SizedBox(
                width: context.width * 0.015,
              ),
              CustomButton(
                width: context.width * 0.08,
                title: 'ADD',
                isIconButton: true,
              ),
            ],
          ),
          const SizedBox(height: 8.0), // Add some space between the rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // You can replace the following with your actual user list
              UserInfoWidget(username: 'User1'),
              UserInfoWidget(username: 'User2'),
              UserInfoWidget(username: 'User3'),
              // Add more UserInfoWidget as needed
            ],
          ),
        ],
      ),
    );
  }
}

// Create a simple widget to represent user information
class UserInfoWidget extends StatelessWidget {
  final String username;

  const UserInfoWidget({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(username),
    );
  }
}
