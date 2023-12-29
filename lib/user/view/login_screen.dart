import 'dart:convert';
import 'package:code_factory_delivery/common/component/custom_text_form_field.dart';
import 'package:code_factory_delivery/common/const/colors.dart';
import 'package:code_factory_delivery/common/const/data.dart';
import 'package:code_factory_delivery/common/layout/default_layout.dart';
import 'package:code_factory_delivery/common/secure_storage/secure_storage.dart';
import 'package:code_factory_delivery/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag, // 스크롤하면, 키보드 사라짐
        child: SafeArea(
          bottom: false,
          top: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(
                  height: 16,
                ),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: "이메일",
                  onChanged: (val) {
                    username = val;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  hintText: "비밀번호",
                  onChanged: (val) {
                    password = val;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // ID:비밀번호
                    final rawString = '$username:$password';
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    final token = stringToBase64.encode(rawString);

                    final resp = await dio.post(
                      'http://$ip/auth/login',
                      options:
                          Options(headers: {'authorization': 'Basic $token'}),
                    );

                    final refershToken = resp.data["refreshToken"];
                    final accessToken = resp.data["accessToken"];

                    final storage = ref.read(secureStorageProvider);

                    await storage.write(
                        key: REFRESH_TOKEN_KEY, value: refershToken);
                    await storage.write(
                        key: ACCESS_TOKEN_KEY, value: accessToken);

                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RootTab(),
                        ),
                      );
                    }
                    ;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: const Text(
                    "로그인",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextButton(
                  onPressed: () async {
                    const refreshToken =
                        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTY4ODQ1NDEyNywiZXhwIjoxNjg4NTQwNTI3fQ.MQWQicdtTdjhLBbeDDIz4xG0Yz4hEYsELetiSSKg0ZQ';
                    final resp = await dio.post(
                      'http://$ip/auth/token',
                      options: Options(
                          headers: {'authorization': 'Bearer $refreshToken'}),
                    );

                    print(resp.data);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "회원가입",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "환영합니다",
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "이메일과 비밀번호를 입력.\n오늘도 성공적인 주문이 되길 :)",
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
