import 'common_constants.dart';

class CrispHelper {
  String crispEmbedUrl({
    required String websiteId,
    required String locale,
    String? userToken,
  }) {
    String url = '$CRISP_BASE_URL/chat/embed/?website_id=$websiteId';

    url += '&locale=$locale';
    if (userToken != null) url += '&token_id=$userToken';

    return url;
  }
}
