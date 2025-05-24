class SearchPlaceModel {

  List<SearchPlace> places=[];

  SearchPlaceModel();
  SearchPlaceModel.fromJson(map){

    for(var item in map){
      places.add(SearchPlace.fromMap(item));
    }
  }

}

class SearchPlace {

  String? description;
  String? placeId;

   SearchPlace.fromMap(map) {
     description=map['description'];
     placeId=map['place_id'];
  }

}

class PlaceModel {

  double? lat;
  double? lng;
  String? name;
  PlaceModel();
  PlaceModel.fromJson(map){
    lat=map['geometry']['location']['lat'];
    lng=map['geometry']['location']['lng'];
    name=map['formatted_address'];
  }
}


class Distance{
  String? distance;
  String? duration;

  Distance(map){
    distance=map["distance"]["text"];
    duration=map["duration"]["text"];

  }
}