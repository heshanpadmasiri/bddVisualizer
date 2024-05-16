import ballerina/io;

public function main() returns error? {
    string data = check io:fileReadString("test.bir");
    Tokenizer tokenizer = new Tokenizer(data);
    io:println(parseNode(tokenizer));
}

