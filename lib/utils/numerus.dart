final _numbersToLetters = {
  1: 'I',
  4: 'IV',
  5: 'V',
  9: 'IX',
  10: 'X',
  40: 'XL',
  50: 'L',
  90: 'XC',
  100: 'C',
  400: 'CD',
  500: 'D',
  900: 'CM',
  1000: 'M',
};

String romanNumeral(int number) {
  assert(number > 0, 'Number must be greater than 0');
  assert(number <= 3000, 'Number must be less or equal to 3000');

  final keys = _numbersToLetters.keys.toList();
  keys.sort((a, b) => b.compareTo(a));

  final result = StringBuffer();
  for (final key in keys) {
    while (number >= key) {
      result.write(_numbersToLetters[key]);
      number -= key;
    }
  }

  return result.toString();
}
