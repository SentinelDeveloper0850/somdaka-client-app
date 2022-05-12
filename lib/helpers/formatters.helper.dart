class FormatterHelper{

  dynamic formatHttpAuthHeader(String token){

    return {
      'Authorization': 'Bearer $token'
    };

  }

  dynamic formatHttpHeader(String key, String value){

    return {
      key : value
    };

  }

}