class MacAddressUtil {
  static bool isMacAddress(String str) => RegExp(r"^IVM_([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$").hasMatch(str);

  static String getMacAddressText(String str) => str.substring(4, str.length);

}