import 'package:flutter/material.dart';
import 'package:fortuna/core/services/formatters.dart';
import 'package:fortuna/core/theme/colors.dart';

class ContactInfoWidget extends StatelessWidget {
  final String phoneNumber;
  final String email;
  const ContactInfoWidget({
    super.key,
    required this.phoneNumber,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 165,
      decoration: BoxDecoration(
        color: MyColors.grey2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact info', style: Theme.of(context).textTheme.bodyMedium),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.grey3,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Image.asset('assets/images/squad/phone.png'),
                      ),
                      Text(formatPhone(phoneNumber),overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.grey3,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Image.asset('assets/images/squad/mail.png'),
                      ),
                      Text(email,overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
