import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

enum VehicleSize { small, medium, large }

/// Menampilkan foto kendaraan yang di-upload user, atau kotak instruksi "Upload foto kendaraan" jika belum di-upload.
class AnimatedVehicleIllustration extends StatelessWidget {
  final VehicleSize sizeCategory;
  final String colorName;
  final Uint8List? photoBytes;
  final double width;
  final double height;
  final bool isLargeCard;

  const AnimatedVehicleIllustration({
    super.key,
    this.sizeCategory = VehicleSize.large,
    this.colorName = 'Putih',
    this.photoBytes,
    this.width = 84,
    this.height = 46,
    this.isLargeCard = false,
  });

  @override
  Widget build(BuildContext context) {
    if (photoBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(isLargeCard ? 14 : 9),
        child: Image.memory(
          photoBytes!,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: isLargeCard ? 16 : 6,
        vertical: isLargeCard ? 12 : 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(isLargeCard ? 14 : 9),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_outlined,
            color: AppColors.navActive,
            size: isLargeCard ? 26 : 16,
          ),
          SizedBox(height: isLargeCard ? 6 : 2),
          Text(
            isLargeCard ? 'Wajib upload foto kendaraan' : 'Upload foto',
            textAlign: TextAlign.center,
            maxLines: isLargeCard ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.navActive,
              fontSize: isLargeCard ? 12.0 : 9.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isLargeCard) ...[
            const SizedBox(height: 2),
            Text(
              'Agar petugas mengenali ciri unik mobil Anda',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
