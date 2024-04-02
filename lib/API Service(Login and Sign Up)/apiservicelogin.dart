import 'package:http/http.dart';
import 'dart:convert';

import '../API Models(Login and Sign Up)/loginmodels.dart';

class APIService{
  Future<LoginResponseModel> login(LoginRequestmodel loginRequestmodel) async {
    String url = "https://secrets-api.fly.dev/api/v1/auth/login";

    final client = Client();

    final Response = await client.post(url as Uri,body : loginRequestmodel.toJSON());
    if(Response.statusCode == 200 || Response.statusCode == 400) {
      return LoginResponseModel.fromJson(json.decode(Response.body));
    }else{
      throw Exception("Failed to Load Data");
    }
  }
}