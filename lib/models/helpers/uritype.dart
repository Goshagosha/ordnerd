enum URItype { email, http }

extension ProtocolFromURItype on URItype {
  String protocol() {
    switch (this) {
      case URItype.email:
        return 'mailto:';
      case URItype.http:
        return 'https://';
    }
  }
}

extension StripProtocols on String {
  static Set toStrip = {"https://", "http://", "mailto:"};

  String stripProtocols() {
    String r = this;
    for (String prefix in toStrip) {
      r = r.replaceAll(prefix, '');
    }
    return r;
  }
}
