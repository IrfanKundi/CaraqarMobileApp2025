String formatPrice(int number) {
  if (number >= 10000000) {
    // Crores
    double crores = number / 10000000;
    return '${crores.toStringAsFixed(crores == crores.toInt() ? 0 : 2)} crore';
  } else if (number >= 100000) {
    // Lakhs
    double lakhs = number / 100000;
    return '${lakhs.toStringAsFixed(lakhs == lakhs.toInt() ? 0 : 2)} lakh';
  } else {
    return number.toString();
  }
}