import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class ChangeAddressScreen extends StatefulWidget {
  final String? currentAddress;
  final String? currentLabel;

  const ChangeAddressScreen({
    Key? key,
    this.currentAddress,
    this.currentLabel,
  }) : super(key: key);

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();
  
  String _selectedAddressType = 'Home';
  final List<String> _addressTypes = ['Home', 'Work', 'Other'];
  bool _isLoadingLocation = false;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _labelController.text = widget.currentLabel ?? 'Home';
    _selectedAddressType = widget.currentLabel ?? 'Home';
    
    // Parse current address if provided
    if (widget.currentAddress != null) {
      _parseAddress(widget.currentAddress!);
    }
  }

  void _parseAddress(String address) {
    // Simple parsing - in production, you'd want more robust parsing
    final parts = address.split(',').map((e) => e.trim()).toList();
    if (parts.isNotEmpty) _streetController.text = parts[0];
    if (parts.length > 1) _cityController.text = parts[1];
    if (parts.length > 2) _countryController.text = parts[2];
  }

  @override
  void dispose() {
    _labelController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      // Construct full address
      final fullAddress = [
        _streetController.text,
        _cityController.text,
        if (_stateController.text.isNotEmpty) _stateController.text,
        if (_zipController.text.isNotEmpty) _zipController.text,
        _countryController.text,
      ].join(', ');

      // Return the address data with coordinates
      Navigator.of(context).pop({
        'label': _selectedAddressType,
        'address': fullAddress,
        if (_latitude != null) 'latitude': _latitude.toString(),
        if (_longitude != null) 'longitude': _longitude.toString(),
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('location_services_disabled')),
              backgroundColor: AppColors.error,
            ),
          );
        }
        setState(() => _isLoadingLocation = false);
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('location_permissions_denied')),
                backgroundColor: AppColors.error,
              ),
            );
          }
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('location_permissions_permanent')),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        setState(() => _isLoadingLocation = false);
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Store latitude and longitude
      _latitude = position.latitude;
      _longitude = position.longitude;

      // Reverse geocode to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        setState(() {
          // Populate address fields
          _streetController.text = '${place.street ?? ''}';
          _cityController.text = place.locality ?? '';
          _stateController.text = place.administrativeArea ?? '';
          _zipController.text = place.postalCode ?? '';
          _countryController.text = place.country ?? '';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('location_fetched_success')),
              backgroundColor: AppColors.primaryAccent,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.tr('error_fetching_location')}: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(context.tr('change_address_title')),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use Current Location Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                  icon: _isLoadingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                          ),
                        )
                      : const Icon(Icons.my_location, size: 20),
                  label: Text(
                    _isLoadingLocation ? context.tr('fetching_location') : context.tr('use_current_location'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryAccent,
                    side: const BorderSide(color: AppColors.primaryAccent, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),

              // Street Address
              _buildTextField(
                controller: _streetController,
                label: context.tr('street_address'),
                hint: context.tr('street_address_hint'),
                icon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr('please_enter_street_address');
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacing16),

              // City
              _buildTextField(
                controller: _cityController,
                label: context.tr('city'),
                hint: context.tr('city_hint'),
                icon: Icons.location_city,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr('please_enter_city');
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacing16),

              // State and ZIP in a row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _stateController,
                      label: context.tr('state_province'),
                      hint: context.tr('state_hint'),
                      icon: Icons.map_outlined,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: _buildTextField(
                      controller: _zipController,
                      label: context.tr('zip_code'),
                      hint: context.tr('zip_hint'),
                      icon: Icons.pin_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing16),

              // Country
              _buildTextField(
                controller: _countryController,
                label: context.tr('country'),
                hint: context.tr('country_hint'),
                icon: Icons.public,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.tr('please_enter_country');
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacing32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    context.tr('save_address_button'),
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSize16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppDimensions.fontSize14,
            fontWeight: FontWeight.w600,
            color: AppColors.black87,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primaryAccent, size: 20),
            filled: true,
            fillColor: AppColors.grey50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.spacing12),
              borderSide: BorderSide(color: AppColors.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.spacing12),
              borderSide: BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.spacing12),
              borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.spacing12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.spacing12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16, vertical: AppDimensions.fontSize14),
          ),
        ),
      ],
    );
  }
}
