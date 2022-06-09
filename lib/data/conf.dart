class Conf {
  static get isProduction => true;
  static String uri = Conf.isProduction ? "https://blobrain.com/api/" : "https://dev.blobrain.com/api/";
  static String url = Conf.isProduction ? "https://blobrain.com/" : "https://dev.blobrain.com/";
}