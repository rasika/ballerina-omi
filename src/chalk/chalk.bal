import ballerina/io;

# Chalk object which provides text colorization capabilities.
public type Chalk object {

    private Color foregroundColor;
    private Color backgroundColor;
    private boolean isItalicized = false;
    private boolean isUnderlined = false;
    private boolean isLight = false;
    private boolean isDark = false;
    private boolean isReversed = false;

    # Creates a new chalk object.
    # 
    # + foregroundColor - Foreground color.
    # + backgroundColor - Background color.
    # + italicize - Boolean to indicate whether the texts should be italicized or not.
    # + underline - Boolean to indicate whether the texts should be is underlined or not.
    public function __init(Color foregroundColor, Color backgroundColor, boolean italicize = false, boolean underline = false) {
        self.isItalicized = italicize;
        self.isUnderlined = underline;
    }

    # Italicize the text if it is not already italicizided.
    # + return - Chalk object with the updated property.
    public function italicize() returns Chalk {
        self.isItalicized = true;
        return self;
    }

    # Underlines the text if it is not already italicizided.
    # + return - Chalk object with the updated property.
    public function underline() returns Chalk {
        self.isUnderlined = true;
        return self;
    }

    # Make the foreground and background darker than normal.
    # + return - Chalk object with the updated property.
    public function dark() returns Chalk {
        self.isLight = false;
        self.isDark = true;
        return self;
    }

    # Make the foreground and background lighter than normal.
    # + return - Chalk object with the updated property.
    public function light() returns Chalk {
        self.isLight = true;
        self.isDark = false;
        return self;
    }

    # Reset foreground and background color to the normal.
    # + return - Chalk object with the updated property.
    public function normal() returns Chalk {
        self.isLight = false;
        self.isDark = false;
        return self;
    }

    # Swaps the foreground and background colors.
    # + return - Chalk object with the updated property.
    public function reverse() returns Chalk {
        self.isReversed = !self.isReversed;
        return self;
    }

    # Sets the foreground color to the provided color.
    #
    # + color - A color.
    # + return - Chalk object with the updated property.
    public function foreground(Color color) returns Chalk {
        self.foregroundColor = color;
        return self;
    }

    # Sets the background color to the provided color.
    #
    # + color - A color.
    # + return - Chalk object with the updated property.
    public function background(Color color) returns Chalk {
        self.backgroundColor = color;
        return self;
    }

    # Updates the text properties. For FOREGROUND and BACKGROUND properties, a Color is expected as the value. For
    # other properties, a boolean value is expected.
    #
    # + property - a property
    # + value - if the property
    # + return - Chalk object with the updated property.
    public function withProperty(Property property, Color|boolean value) returns Chalk {
        if (property == ITALIC) {
            self.isItalicized = getBoolean(property, value);
        } else if (property == UNDERLINE) {
            self.isUnderlined = getBoolean(property, value);
        } else if (property == LIGHT) {
            self.isLight = getBoolean(property, value);
        } else if (property == DARK) {
            self.isDark = getBoolean(property, value);
        } else if (property == REVERSE) {
            self.isReversed = getBoolean(property, value);
        } else if (property == FOREGROUND) {
            self.foregroundColor = getColor(property, value);
        } else if (property == BACKGROUND) {
            self.backgroundColor = getColor(property, value);
        }
        return self;
    }

    # Colorizes the given text.
    #
    # + text - Text which needs to be colorized.
    # + return - Returns the colorized text.
    public function write(string text) returns string {
        // Get the forground color index.
        int foregroundColorIndex = getColorIndex(foregroundColor);
        // Get the background color index.
        int backgroundColorIndex = getColorIndex(backgroundColor);

        string colorizedString = "";
        // First, we append property flags. Then the forground color code. After that, we append the background color
        // code.
        colorizedString += ESCAPE_PREFIX;
        // Append light color code.
        if (self.isLight){
            colorizedString += LIGHT_CODE;
        }
        // Append dark code.
        if (self.isDark){
            colorizedString += DARK_CODE;
        }
        // Append italic code.
        if (self.isItalicized){
            colorizedString += ITALIC_CODE;
        }
        // Append underline code.
        if (self.isUnderlined){
            colorizedString += UNDERLINE_CODE;
        }
        // Append reversed code.
        if (self.isReversed){
            colorizedString += REVERSE_CODE;
        }
        // Append the forground color only if it is not set to default color.
        if (foregroundColorIndex != -1){
            // Append the foreground color.
            colorizedString += FORGROUND_COLOR_CODES[foregroundColorIndex] + ";";
        }

        // Append the background color only if it is not set to default color.
        if (backgroundColorIndex != -1){
            // Append the background color.
            colorizedString += BACKGROUND_COLOR_CODES[backgroundColorIndex] + ";";
        }

        // Append the escape suffix.
        colorizedString += ESCAPE_SUFFIX;

        // Append the text.
        colorizedString += text;

        // Append the reset code.
        colorizedString += RESET_ALL_CODE;
        // Return the colorized string.
        return colorizedString;
    }

    function getColorIndex(Color color) returns int {
        int code;
        if (color == BLACK) {
            code = 0;
        } else if (color == RED) {
            code = 1;
        } else if (color == GREEN) {
            code = 2;
        } else if (color == YELLOW) {
            code = 3;
        } else if (color == BLUE) {
            code = 4;
        } else if (color == PURPLE) {
            code = 5;
        } else if (color == CYAN) {
            code = 6;
        } else if (color == WHITE) {
            code = 7;
        } else if (color == DEFAULT) {
            code = -1;
        } else {
            string msg = "Unknown color: " + io:sprintf("%r", color);
            error err = error(msg);
            panic err;
        }
        return code;
    }

    function getBoolean(Property property, Color|boolean value) returns boolean {
        match value {
            Color => {
                error e = error("Boolean value expected for the property '" + io:sprintf("%r", property) + "'." );
                throw e;
            }
            var b => {
                return b;
            }
        }
    }

    function getColor(Property property, Color|boolean value) returns Color {
        match value {
            var c => {
                return c;
            }
            _ => {
                error e = error("Color value expected for the property '" + io:sprintf("%r", property) + "'." );
                throw e;
            }
        }
    }
};
