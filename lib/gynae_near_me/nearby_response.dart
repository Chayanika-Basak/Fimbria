class Places {
  List<Results>? results;
  Context? context;

  Places({this.results, this.context});

  Places.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      print("Results");
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
    context =
        (json['context'] != null ? Context.fromJson(json['context']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    if (this.context != null) {
      data['context'] = this.context!.toJson();
    }
    return data;
  }
}

class Results {
  String? fsqId;
  List<Categories>? categories;
  List<dynamic>? chains;
  String? closedBucket;
  int? distance;
  Geocodes? geocodes;
  String? link;
  Location? location;
  String? name;
  RelatedPlaces? relatedPlaces;

  Results(
      {this.fsqId,
      this.categories,
      this.chains,
      this.closedBucket,
      this.distance,
      this.geocodes,
      this.link,
      this.location,
      this.name,
      this.relatedPlaces});

  Results.fromJson(Map<String, dynamic> json) {
    fsqId = json['fsq_id'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['chains'] != null) {
      chains = json['chains'];
    }
    closedBucket = json['closed_bucket'];
    distance = json['distance'];
    geocodes = json['geocodes'] != null
        ? new Geocodes.fromJson(json['geocodes'])
        : null;
    link = json['link'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    name = json['name'];
    relatedPlaces = json['related_places'] != null
        ? new RelatedPlaces.fromJson(json['related_places'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fsq_id'] = this.fsqId;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.chains != null) {
      data['chains'] = this.chains!.map((v) => v.toJson()).toList();
    }
    data['closed_bucket'] = this.closedBucket;
    data['distance'] = this.distance;
    if (this.geocodes != null) {
      data['geocodes'] = this.geocodes!.toJson();
    }
    data['link'] = this.link;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['name'] = this.name;
    if (this.relatedPlaces != null) {
      data['related_places'] = this.relatedPlaces!.toJson();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? shortName;
  String? pluralName;
  CustomIcon? icon;

  Categories({this.id, this.name, this.shortName, this.pluralName, this.icon});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    pluralName = json['plural_name'];
    icon = json['icon'] != null ? new CustomIcon.fromJson(json['icon']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['plural_name'] = this.pluralName;
    if (this.icon != null) {
      data['icon'] = this.icon!.toJson();
    }
    return data;
  }
}

class CustomIcon {
  String? prefix;
  String? suffix;

  CustomIcon({this.prefix, this.suffix});

  CustomIcon.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    suffix = json['suffix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prefix'] = this.prefix;
    data['suffix'] = this.suffix;
    return data;
  }
}

class Geocodes {
  Main? main;

  Geocodes({this.main});

  Geocodes.fromJson(Map<String, dynamic> json) {
    main = json['main'] != null ? new Main.fromJson(json['main']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.main != null) {
      data['main'] = this.main!.toJson();
    }
    return data;
  }
}

class Main {
  double? latitude;
  double? longitude;

  Main({this.latitude, this.longitude});

  Main.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Location {
  String? address;
  String? addressExtended;
  String? country;
  String? formattedAddress;
  String? locality;
  String? postcode;
  String? region;

  Location(
      {this.address,
      this.addressExtended,
      this.country,
      this.formattedAddress,
      this.locality,
      this.postcode,
      this.region});

  Location.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    addressExtended = json['address_extended'];
    country = json['country'];
    formattedAddress = json['formatted_address'];
    locality = json['locality'];
    postcode = json['postcode'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['address_extended'] = this.addressExtended;
    data['country'] = this.country;
    data['formatted_address'] = this.formattedAddress;
    data['locality'] = this.locality;
    data['postcode'] = this.postcode;
    data['region'] = this.region;
    return data;
  }
}

class RelatedPlaces {
  RelatedPlaces({dynamic});

  RelatedPlaces.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Context {
  GeoBounds? geoBounds;

  Context({this.geoBounds});

  Context.fromJson(Map<String, dynamic> json) {
    geoBounds = json['geo_bounds'] != null
        ? new GeoBounds.fromJson(json['geo_bounds'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geoBounds != null) {
      data['geo_bounds'] = this.geoBounds!.toJson();
    }
    return data;
  }
}

class GeoBounds {
  Circle? circle;

  GeoBounds({this.circle});

  GeoBounds.fromJson(Map<String, dynamic> json) {
    circle =
        json['circle'] != null ? new Circle.fromJson(json['circle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.circle != null) {
      data['circle'] = this.circle!.toJson();
    }
    return data;
  }
}

class Circle {
  Main? center;
  int? radius;

  Circle({this.center, this.radius});

  Circle.fromJson(Map<String, dynamic> json) {
    center = json['center'] != null ? new Main.fromJson(json['center']) : null;
    radius = json['radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.center != null) {
      data['center'] = this.center!.toJson();
    }
    data['radius'] = this.radius;
    return data;
  }
}
