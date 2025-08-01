String formatIndianNumber(int number) {
  final units = [
    {'value': 10000000, 'label': 'crore'},
    {'value': 100000, 'label': 'lakh'},
    {'value': 1000, 'label': 'thousand'},
    {'value': 100, 'label': 'hundred'},
  ];

  String result = '';
  int remaining = number;

  for (var unit in units) {
    int count = remaining ~/ (unit['value'] as int);
    if (count > 0) {
      result += '$count ${unit['label']} ';
      remaining %= unit['value'] as int;
    }
  }

  // Optionally add the remaining amount < 100
  if (remaining > 0) {
    result += '$remaining';
  }

  return result.trim();
}