import ballerina/io;

public function main() returns error? {
    string data = check io:fileReadString("test.bir");
    Tokenizer tokenizer = new Tokenizer(data);
    while (true) {
        Token? token = tokenizer.next();
        if (token is ()) {
            break;
        }
        io:println(token);
    }
}

