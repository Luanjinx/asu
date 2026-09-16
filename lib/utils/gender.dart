enum Gender {
  male,
  female,
  other;

  static Gender fromString(String? value) {
    if (value == null || value.isEmpty) return Gender.male;
    if (value == 'male') return Gender.male;
    if (value == 'female') return Gender.female;
    return Gender.other;
  }
}
