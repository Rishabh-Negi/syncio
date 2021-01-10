class User {
  final String country;
  final String displayName;
  final String email;

  final ExplicitContent explicitContent;
  final ExternalUrl externalUrl;
  final Followers followers;

  final String href;
  final String id;
  var images;
  final String product;
  final String type;
  final String uri;

  User._({
    this.country,
    this.displayName,
    this.email,
    this.explicitContent,
    this.externalUrl,
    this.followers,
    this.href,
    this.id,
    this.product,
    this.type,
    this.uri,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User._(
      country: json['country'],
      displayName: json['display_name'],
      email: json['email'],
      href: json['href'],
      id: json['id'],
      product: json['product'],
      type: json['type'],
      uri: json['uri'],
      explicitContent: ExplicitContent.fromMap(json['explicit_content']),
      externalUrl: ExternalUrl.fromMap(json['external_urls']),
      followers: Followers.fromMap(json['followers']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': this.country,
      'display_name': this.displayName,
      'email': this.email,
      'href': this.href,
      'id': this.id,
      'product': this.product,
      'type': this.type,
      'uri': this.uri,
      'explicit_content': this.explicitContent,
      'external_urls': this.externalUrl,
      'followers': this.followers,
    };
  }
}

class ExplicitContent {
  final bool filterEnabled;
  final bool filterLocked;

  ExplicitContent._({
    this.filterEnabled,
    this.filterLocked,
  });
  factory ExplicitContent.fromMap(Map<String, dynamic> json) {
    return ExplicitContent._(
        filterEnabled: json['filter_enabled'],
        filterLocked: json['filter_locked']);
  }
}

class ExternalUrl {
  final String spotify;

  ExternalUrl._({this.spotify});
  factory ExternalUrl.fromMap(Map<String, dynamic> json) {
    return ExternalUrl._(
      spotify: json['spotify'],
    );
  }
}

class Followers {
  final String href;
  final int total;

  Followers._({
    this.href,
    this.total,
  });
  factory Followers.fromMap(Map<String, dynamic> json) {
    return Followers._(
      href: json['href'],
      total: json['total'],
    );
  }
}
