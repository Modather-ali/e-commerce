import 'package:dmazcofresh/screens/widgets/super_text_field.dart';
import 'package:dmazcofresh/screens/widgets/theme_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../services/firebase_database.dart';
import '../widgets/snack_bar.dart';
import 'bottom_nav_view.dart';
import 'shopping.dart';

class DeliveryDetails extends StatefulWidget {
  const DeliveryDetails({Key? key}) : super(key: key);

  @override
  State<DeliveryDetails> createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _completeAddress = TextEditingController();
  final TextEditingController _place = TextEditingController();

  final FirebaseDatabase _database = FirebaseDatabase();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _suggestedPlaces = ["Home", "Work", "Hotel", "Other"];

  late CameraPosition _cameraPosition;
  bool _showCompleteAddress = false;
  Map<String, dynamic>? _userData;
  List<Placemark> _placemark = [];
  String _phoneText = '';
  int _stepNumber = 1;
  int _placeIndex = 0;
  var _position;

  bool _isloading = false;
  _getCurrentPosition() async {
    _position = await Geolocator.getCurrentPosition();

    _placemark =
        await placemarkFromCoordinates(_position.latitude, _position.longitude);
    _cameraPosition = CameraPosition(
      target: LatLng(_position.latitude, _position.longitude),
      zoom: 14,
    );
    setState(() {});
    // setState(() {
    //   _completeAddress.text =
    //       "${_placemark[0].country}, ${_placemark[0].locality}, ${_placemark[0].street}";
    // });
  }

  Future _checkPermission() async {
    await Permission.location.request();

    // bool serviceEnabled;
    LocationPermission permission;

    bool _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      await Permission.location.request();
      ScaffoldMessenger.of(context).showSnackBar(snackBar(
          message: "Please active location service", color: Colors.red));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Permission.location.request();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar(
            message: "Please active location service", color: Colors.red));
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar(
          message: "Please active location service", color: Colors.red));
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  // _getUserData() async {
  //   _userData = await _database.getUserData();
  // setState(() {
  //   _location.text = _userData!["location"];
  // });
  // }

  @override
  void initState() {
    _getCurrentPosition();
    _checkPermission();
    // _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, value, child) {
      _name.text = value.userData["username"];
      _phone.text = value.userData["contact"];
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Add delivery details"),
        ),
        body: _stepNumber == 1 ? _personalDetails() : _locationDetails(value),
      );
    });
  }

  Widget _personalDetails() {
    return Form(
      child: ListView(
        key: _formKey,
        children: [
          const Text(
            "Add Your Personal Details",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SuperTextField(
              fieldName: "Name",
              controller: _name,
              textInputType: TextInputType.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SuperTextField(
              fieldName: "Phone Number",
              controller: _phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return "This Phone Number is required";
                }

                return null;
              },
              textInputType: TextInputType.phone,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ThemeButton(
                title: "Continue",
                onPressed: () async {
                  // if (_formKey.currentState!.validate()) {
                  //   _formKey.currentState!.save();
                  LocationPermission permission;

                  bool _serviceEnabled =
                      await Geolocator.isLocationServiceEnabled();
                  if (!_serviceEnabled) {
                    await Permission.location.request();
                    ScaffoldMessenger.of(context).showSnackBar(snackBar(
                        message: "Please active location service",
                        color: Colors.red));
                  } else {
                    await _getCurrentPosition();
                    setState(() {
                      _phoneText = _phone.text;
                      _stepNumber = 2;
                    });
                  }
                  // } else {}
                }),
          )
        ],
      ),
    );
  }

  Widget _locationDetails(ProductProvider productProvider) {
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("Land"),
        position: LatLng(_position.latitude, _position.longitude),
        draggable: true,
        infoWindow: const InfoWindow(title: "Touch and hold to move"),
        onDragEnd: (LatLng latLng) async {
          _placemark =
              await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
          _cameraPosition = CameraPosition(
              target: LatLng(latLng.latitude, latLng.longitude), zoom: 20);
          setState(() {});
        },
      ),
    };
    if (_position == null) {
      return LoadingAnimationWidget.inkDrop(
        color: Colors.orange,
        size: 50,
      );
    } else {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: _cameraPosition,
              markers: markers,
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                setState(() {
                  _isloading = true;
                });
                LocationPermission permission;

                bool _serviceEnabled =
                    await Geolocator.isLocationServiceEnabled();
                if (!_serviceEnabled) {
                  await Permission.location.request();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar(
                      message: "Please active location service",
                      color: Colors.red));
                } else {
                  await _getCurrentPosition();
                  markers = {
                    Marker(
                      markerId: const MarkerId("Land"),
                      position: LatLng(_position.latitude, _position.longitude),
                      draggable: true,
                      infoWindow:
                          const InfoWindow(title: "Touch and hold to move"),
                      onDragEnd: (LatLng latLng) async {
                        _placemark = await placemarkFromCoordinates(
                            latLng.latitude, latLng.longitude);
                        _cameraPosition = CameraPosition(
                            target: LatLng(latLng.latitude, latLng.longitude),
                            zoom: 20);
                      },
                    ),
                  };
                  setState(() {
                    _isloading = false;
                  });
                }
              },
              child: const Icon(
                Icons.location_searching,
                color: Colors.deepOrange,
              ),
              backgroundColor: Colors.white,
            ),
          ),
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  title: Text(
                    "${_placemark[0].locality}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    "${_placemark[0].country}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: double.maxFinite,
                  ),
                  child: MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Enter complete address",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    color: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      setState(() {
                        _showCompleteAddress = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          _showCompleteAddress
              ? Container(
                  // height: 140,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Enter complete address",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showCompleteAddress = false;
                              });
                            },
                            icon: const Icon(Icons.keyboard_arrow_down_sharp),
                          ),
                        ],
                      ),
                      const Divider(),
                      _placeIndex != 3
                          ? Row(
                              children: [
                                _selectButton(0),
                                _selectButton(1),
                                _selectButton(2),
                                _selectButton(3),
                              ],
                            )
                          : SuperTextField(
                              fieldName: "Your current place",
                              controller: _place,
                              textInputType: TextInputType.text,
                              prefixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _placeIndex = 0;
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                      SuperTextField(
                        fieldName: "Complete address",
                        controller: _completeAddress,
                        textInputType: TextInputType.text,
                      ),
                      const Divider(),
                      Consumer<ProductProvider>(
                          builder: (context, value, child) {
                        return ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: double.maxFinite,
                          ),
                          child: MaterialButton(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: const Text(
                              "Save address",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            color: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () async {
                              // setState(() {
                              //   _isloading = true;
                              // });
                              await _database.updateUserLocation(
                                phone: _phoneText,
                                location: _completeAddress.text +
                                    ", ${_placemark[0].country}, ${_placemark[0].locality}",
                                currentPlace: _placeIndex != 3
                                    ? _suggestedPlaces[_placeIndex]
                                    : _place.text,
                                lat: _position.latitude,
                                lng: _position.longitude,
                              );
                              _userData = await _database.getUserData();
                              if (_userData != null) {
                                // value.userData = _userData!;
                              }
                              // value.userData["location"] =
                              //     _userData!["location"];
                              value.updateUserData(newUserData: _userData!);
                              // Navigator.of(context).pop();
                              // setState(() {
                              //   _isloading = false;
                              // });
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavView()),
                                ModalRoute.withName(''),
                              );
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ShoppingCart()));
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                )
              : const SizedBox(),
          _isloading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange,
                  ),
                )
              : const SizedBox()
        ],
      );
    }
  }

  Widget _selectButton(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _placeIndex = index;
        });
      },
      child: Container(
        height: 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: _placeIndex == index
              ? Colors.orangeAccent.withOpacity(0.3)
              : null,
          border: _placeIndex == index
              ? Border.all(color: Colors.deepOrange, width: 2)
              : Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _suggestedPlaces[index],
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
