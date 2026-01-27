import 'package:flutter/material.dart';

class FeaturedCard extends StatelessWidget {
  final String title;
  final String time;
  final String authorName;
  final String authorImage;
  final String foodImage;
  final Color backgroundColor;

  const FeaturedCard({
    super.key,
    required this.title,
    required this.time,
    required this.authorName,
    required this.authorImage,
    required this.foodImage,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
           // Circle decorations for background texture
           Positioned(
             top: -10,
             left: 20,
             child: Container(
               width: 10,
               height: 10,
               decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.6), shape: BoxShape.circle),
             )
           ),
           
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 160,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage('assets/images/user_avatar.jpg'), // Fallback needed
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 16, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    authorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Food Image on the right
           Positioned(
            right: -30,
            top: 10,
            bottom: 10,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 color: Colors.white.withValues(alpha: 0.2),
              ),
               child: const Icon(Icons.rice_bowl, color: Colors.white70, size: 60), // Placeholder for image
            ),
          )
        ],
      ),
    );
  }
}
