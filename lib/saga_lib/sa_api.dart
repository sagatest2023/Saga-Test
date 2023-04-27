import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiDefaults {
  static String baseURL = '';
  static Duration connectTimeout = const Duration(seconds: 30);
  static Duration receiveTimeout = const Duration(seconds: 30); // 30s

  // mostrar o progresso...
  static void Function({String message})? showProgress;
  static void Function()? hideProgress;
}

ValueNotifier<List<InfoLog>> logsList = ValueNotifier([]);
String? baseURL;

class SAApi {
  /// [baseURL] Request base url, it can contain sub path, like: "https://www.google.com/api/".
  ///
  /// [connectTimeout] Timeout in milliseconds for opening url.
  /// [Dio] will throw the [DioError] with [DioErrorType.CONNECT_TIMEOUT] type
  ///  when time out.
  ///
  /// [receiveTimeout] Timeout in milliseconds for receiving data.
  /// [Dio] will throw the [DioError] with [DioErrorType.RECEIVE_TIMEOUT] type
  /// when time out.
  ///
  /// [0] meanings no timeout limit.
  SAApi({
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    dio.options.baseUrl = baseURL ?? ApiDefaults.baseURL;
    dio.options.connectTimeout = connectTimeout ?? ApiDefaults.connectTimeout;
    dio.options.receiveTimeout = receiveTimeout ?? ApiDefaults.receiveTimeout;

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) {
        onRequest(request);
        handler.next(request);
      },
      onResponse: (response, handler) {
        onResponse(response);
        handler.next(response);
      },
      onError: (error, handler) {
        onError(error);
        handler.next(error);
      },
    ));
  }

  final dio = Dio();

  var showRequests = true;
  var showProgress = true;
  var waitProgress = 0;

  final timer = Timer();
  final log = InfoLog();

  void logRequest(RequestOptions request) {
    final parameters =
        request.method == 'GET' ? request.queryParameters : request.data;

    final pathSeparado = request.path.split("/");
    final ipSeparado = pathSeparado[2].split(":");

    log.method = request.method;
    log.ip = ipSeparado.first;
    log.porta = ipSeparado.last;
    log.controller = pathSeparado[4];
    log.nomeMetodo = pathSeparado[5];

    print('\n${request.method} ${request.path} $parameters');
  }

  void logResponse(String result, Timer timer) {
    print(result);
    print('TIMER(ms) ${timer.value}');
  }

  void onRequest(RequestOptions request) async {
    timer.reset();
    timer.start();

    if (showRequests) {
      logRequest(request);
    }

    if (showProgress) {
      ApiDefaults.showProgress?.call();
      if (waitProgress > 0) {
        await Future.delayed(Duration(milliseconds: waitProgress));
      }
    }
  }

  void onResponse(Response<dynamic> response) {
    log.tempo = timer.value.toString();
    timer.stop();

    if (showRequests) {
      logResponse('RESULT: $response', timer);
    }

    if (showProgress) {
      ApiDefaults.hideProgress?.call();
    }
  }

  void onError(DioError dioError) {
    log.tempo = timer.value.toString();
    timer.stop();

    if (!showRequests) {
      logRequest(dioError.requestOptions);
    }

    // se foi erro do server, obtém a mensagem de erro...
    if (dioError.type == DioErrorType.badResponse &&
        dioError.response?.statusCode == 500) {
      log.resultado = dioError.response?.data['Message'];
    }

    logResponse('ERROR: ${dioError.message}', timer);

    if (showProgress) {
      ApiDefaults.hideProgress?.call();
    }
  }

  Future<String> getString(String path, Map<String, dynamic> values) async {
    final response = await dio.get(path, queryParameters: values);
    final result = getResult(response, null);
    return result ?? '';
  }

  Future<List<T>> getList<T>(
    String path,
    Map<String, dynamic> values,
    T Function(Map<String, dynamic>) fromJson, {
    String? descricao,
  }) async {
    log.descricao = descricao;
    try {
      final response = await dio.get("$baseURL$path", queryParameters: values);
      final list = getResult(response, fromJson);
      log.resultado = list;
      return list;
    } catch (ex) {
      if (log.resultado != null) {
        log.resultado = Exception(log.resultado);
      } else {
        log.resultado = ex;
      }
      rethrow;
    } finally {
      logsList.value.add(log);
      logsList.notifyListeners();
    }
  }

  Future<T?> get<T>(
    String path,
    Map<String, dynamic> values,
    T Function(Map<String, dynamic>)? fromJson, {
    String? descricao,
  }) async {
    log.descricao = descricao;
    try {
      final response = await dio.get("$baseURL$path", queryParameters: values);
      final result = getResult(response, fromJson);
      log.resultado = result;
      return result;
    } catch (ex) {
      if (log.resultado != null) {
        log.resultado = Exception(log.resultado);
      } else {
        log.resultado = ex;
      }
      rethrow;
    } finally {
      logsList.value.add(log);
      logsList.notifyListeners();
    }
  }

  Future<T?> post<T>(
    String path,
    Map<String, dynamic> values, {
    T Function(Map<String, dynamic>)? fromJson,
    String? descricao,
  }) async {
    log.descricao = descricao;
    try {
      final response = await dio.post("$baseURL$path", data: values);
      final result = getResult(response, fromJson);
      return result;
    } catch (ex) {
      if (log.resultado != null) {
        log.resultado = Exception(log.resultado);
      } else {
        log.resultado = ex;
      }
      rethrow;
    } finally {
      logsList.value.add(log);
      logsList.notifyListeners();
    }
  }

  Future<List<T>> postList<T>(
    String path,
    Map<String, dynamic> values,
    T Function(Map<String, dynamic>)? fromJson, {
    String? descricao,
  }) async {
    log.descricao = descricao;
    try {
      final response = await dio.post("$baseURL$path", data: values);
      final list = getResult(response, fromJson);
      return list;
    } catch (ex) {
      if (log.resultado != null) {
        log.resultado = Exception(log.resultado);
      } else {
        log.resultado = ex;
      }
      rethrow;
    } finally {
      logsList.value.add(log);
      logsList.notifyListeners();
    }
  }

  dynamic getResult<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final timer = Timer();
    timer.start();
    try {
      if (fromJson == null) {
        return response.data;
      }

      if (response.data is Map) {
        return fromJson(response.data as Map<String, dynamic>);
      }

      if (response.data is List) {
        return (response.data as List).map((json) => fromJson(json)).toList();
      }

      return response.data;
    } catch (ex) {
      print('\n\n\n');
      print(
          '******************************************************************');
      print('***** ERRO NO DECODE:\n${ex.toString()}');
      print(
          '******************************************************************');
      print('\n\n\n');
      throw ex;
    } finally {
      timer.stop();
      if (showRequests) {
        print('DECODE JSON(ms) ${timer.value}');
      }
    }
  }
}

class Timer {
  void start() {
    if (_millis < 0) return;
    _millis -= DateTime.now().millisecondsSinceEpoch;
  }

  void stop() {
    if (_millis >= 0) return;
    _millis += DateTime.now().millisecondsSinceEpoch;
  }

  void reset() => _millis = 0;

  int _millis = 0;

  int get value =>
      _millis >= 0 ? _millis : _millis + DateTime.now().millisecondsSinceEpoch;
}

class InfoLog {
  InfoLog({
    this.ip = "Não tem ou não encontrado",
    this.porta = "Não tem ou não encontrado",
    this.method = "Não tem ou não encontrado",
    this.controller = "Não tem ou não encontrado",
    this.nomeMetodo = "Não tem ou não encontrado",
    this.descricao = "Não tem ou não encontrado",
    this.tempo = "Não tem ou não encontrado",
    this.resultado,
  });

  String ip;
  String porta;
  String method;
  String controller;
  String nomeMetodo;
  String? descricao;
  String tempo;

  dynamic resultado;
}
