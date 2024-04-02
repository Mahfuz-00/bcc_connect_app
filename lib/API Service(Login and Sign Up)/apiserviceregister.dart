import 'package:http/http.dart';
import 'dart:convert';

import '../API Models(Login and Sign Up)/registermodels.dart';

class APIService{
  Future<RegisterResponseModel> register(RegisterRequestmodel registerRequestModel) async {
    String url = "https://mp06c6f39607fb1740ca.free.beeceptor.com";

    final client = Client();

    final Response = await client.post(
        //url as Uri,  if Link is available
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body : registerRequestModel.toJSON()
    );
    if(Response.statusCode == 200) {
      return RegisterResponseModel.fromJson(json.decode(await Response.body));
    }else{
      throw Exception("Failed to Register Data!");
    }
  }
}