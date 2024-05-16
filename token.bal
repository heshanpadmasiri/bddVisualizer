type Identifier [string]; // This is to defferentiate other preposition tokens

const OPEN_PAREN = "(";
const CLOSE_PAREN = ")";
const COLON = ":";
const QUESTION_MARK = "?";
const TRUE = "true";
const FALSE = "false";

type Token Identifier|OPEN_PAREN|CLOSE_PAREN|COLON|QUESTION_MARK|TRUE|FALSE;

class Tokenizer {
    string text;
    int index;

    function init(string text) {
        self.index = 0;
        self.text = text;
    }

    function next() returns Token? {
        if self.index >= self.text.length() {
            return ();
        }
        match self.text[self.index] {
            "(" => {
                self.index = self.index + 1;
                return OPEN_PAREN;
            }
            ")" => {
                self.index = self.index + 1;
                return CLOSE_PAREN;
            }
            ":" => {
                self.index = self.index + 1;
                return COLON;
            }
            "?" => {
                self.index = self.index + 1;
                return QUESTION_MARK;
            }
            "0" => {
                self.index = self.index + 1;
                return FALSE;
            }
            "1" => {
                self.index = self.index + 1;
                return TRUE;
            }
            var c if isLetter(c) => {
                int 'start = self.index;
                self.index += 1;
                var isAlphanumeric = charPredicateWrapper(function(string:Char ch) returns boolean {
                            return isLetter(ch) || isDigit(ch);
                        });
                while isAlphanumeric(self.peek()) {
                    self.index += 1;
                }
                return [self.text.substring('start, self.index)];
            }
            _ => {
                panic error("Unexpected token " + self.text[self.index]);
            }
        }
    }

    function peek() returns string:Char? {
        return self.index < self.text.length() ? self.text[self.index] : ();
    }
}

type CharPredicate function (string:Char) returns boolean;

function charPredicateWrapper(CharPredicate basePredicate) returns function (string:Char?) returns boolean {
    return function(string:Char? c) returns boolean {
        return c is string:Char && basePredicate(c);
    };
}

isolated function isLetter(string:Char c) returns boolean {
    return c >= "a" && c <= "z" || c >= "A" && c <= "Z";
}

isolated function isDigit(string:Char c) returns boolean {
    return c >= "0" && c <= "9";
}

isolated function tokenToString(Token token) returns string {
    if token is string {
        return token;
    }
    return "Ident:" + token[0];
}
