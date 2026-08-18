import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:madinaty_app_ieee_2026/core/services/location_service.dart';

class LocationPermissionScreen extends StatefulWidget {
  final LocationService locationService;
  final VoidCallback onPermissionGranted;
  final VoidCallback? onChooseManually;

  const LocationPermissionScreen({
    super.key,
    required this.locationService,
    required this.onPermissionGranted,
    this.onChooseManually,
  });

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool isLoading = false;

  Future<void> requestLocation() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final serviceEnabled = await widget.locationService
          .isLocationServiceEnabled();

      if (!serviceEnabled) {
        await widget.locationService.openLocationSettings();

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        return;
      }

      var permission = await widget.locationService.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await widget.locationService.requestPermission();
      }

      if (!mounted) return;

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        widget.onPermissionGranted();
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          isLoading = false;
        });

        await showDeniedForeverDialog();
        return;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء تحديد الموقع')));
    }
  }

  Future<void> showDeniedForeverDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('السماح بالموقع', textAlign: TextAlign.right),
          content: Text(
            'تم رفض صلاحية الموقع نهائيًا. يمكنك السماح بها من إعدادات الجهاز.',
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                await widget.locationService.openAppSettings();
              },
              child: Text('فتح الإعدادات'),
            ),
          ],
        );
      },
    );

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF8F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  ),
                ),

                SizedBox(height: 15),

                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFEBD8CC), width: 2),
                  ),
                  child: Image.asset('assets/images/location image.png'),
                ),

                SizedBox(height: 40),

                Text(
                  'خلي مدينتي أقرب ليك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF24150F),
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'استخدم موقعك عشان نساعدك تلاقي\nأماكن قريبة منك.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.6,
                  ),
                ),

                SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : requestLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF170D09),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'السماح بالموقع',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.navigation, size: 18),
                            ],
                          ),
                  ),
                ),

                SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: widget.onChooseManually,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF9B6F58),
                      side: BorderSide(color: Color(0xFFD7B8A4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'اختيار المنطقة يدوياً',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
