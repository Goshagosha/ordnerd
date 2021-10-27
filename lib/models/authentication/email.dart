import 'package:formz/formz.dart';

enum EmailValidationError { empty }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String? value) {
    if (value == null) return EmailValidationError.empty;
    if (!RegExp('^([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,7})+\$')
        .hasMatch(value)) return EmailValidationError.empty;
  }
}
