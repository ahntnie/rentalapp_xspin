class API {
//STATUS - CODE
  static const int CODE = 200;
//HOST API
  static const String HOST_API = 'https://apithuedo.luckydraw.vn';
  static const String HOST_IMAGE = 'https://thuethietbisukien.com/';
  // static const String HOST_IMAGE_LIST = 'https://thuethietbisukien.com/';

  static const List<String> HOST_SLIDE = [
    'https://thuethietbisukien.com/images/s1.png',
    'https://thuethietbisukien.com/images/s2.png',
    'https://thuethietbisukien.com/images/s3.png',
    // 'https://thuethietbisukien.com/images/s4.png',
    // 'https://thuethietbisukien.com/images/s5.png'
  ];
  static const String HOST_IMAGE_USER =
      'https://thuethietbisukien.com/images/s4.png';
// PRODUCTS
  static const String PRODUCT = '/getSanPham';
// CATEGORY
  static const String CATEGORY = '/getDanhMuc';
// PRODUCTS BY CATEGORY
  static const String PRODUCT_BY_CATEGORY = '/getSanPhamCha';
// products by category child
  static const String PRODUCT_BY_CATEGORY_CHILD = '/getSanPhamDM';

// CATEGORY BY ID
  static const String CATEGORY_BY_ID = '/getDM';
// LOCATION
  static const String LOCATION = '/getTinh';
  static const String FILTER_PRODUCT_LOCATION = '/getSanPhamTinh';

//FILTER
  static const String FILTER_PRODUCT = '/getSanPhamTT';
//POST
  static const String POST_MESSAGE = "/postTuVan";
//version app
  static const String VERSION_APP = '1.0.0';
}
