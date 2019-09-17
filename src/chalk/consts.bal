int[] FORGROUND_COLOR_CODES = [30, 31, 32, 33, 34, 35, 36, 37];
int[] BACKGROUND_COLOR_CODES = [40, 41, 42, 43, 44, 45, 46, 47];

const string RESET_CODE = "0";
const string LIGHT_CODE = "1;";
const string DARK_CODE = "2;";

const string ITALIC_CODE = "3;";
const string UNDERLINE_CODE = "4;";

const string REVERSE_CODE = "7;";

const string ESCAPE_PREFIX = "\u001B[";
const string ESCAPE_SUFFIX = "m";

string RESET_ALL_CODE = ESCAPE_PREFIX + RESET_CODE + ESCAPE_SUFFIX;