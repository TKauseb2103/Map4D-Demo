// import 'dart:io';


// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/place.dart';

// class UserPlacesNotifier extends StateNotifier<List<Place>> {
//   UserPlacesNotifier() : super(const []);

//   void addPlace(String title, PlaceLocation location) async {
//     final newPlace = Place(title: title, location: location);
//     state = [newPlace, ...state];
//     /*Điều này có nghĩa là newPlace sẽ được thêm vào đầu danh sách trạng thái hiện tại.
//     Điều này giúp duy trì trạng thái không thay đổi nguyên bản của danh sách và thêm một đối tượng mới
//     vào đầu danh sách mỗi khi có đối tượng mới được thêm vào.*/
//   }
// }

// final userPlacesProvider =
//     StateNotifierProvider<UserPlacesNotifier, List<Place>>(
//   (ref) => UserPlacesNotifier(),
// );
