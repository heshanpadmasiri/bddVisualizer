type Node InnerNode|LeafNode;

type LeafNode boolean;

type InnerNode record {
    string identifier;
    Node left;
    Node middle;
    Node right;
};

function parseNode(Tokenizer tok) returns Node {
    Token? token = tok.next();
    if token == () {
        panic error("Unexpected EOF");
    }
    if token is Identifier {
        return finishInnerNode(tok, token[0]);
    } else if token == OPEN_PAREN {
        Node node = parseNode(tok);
        expectToken(tok, CLOSE_PAREN);
        return node;
    } else if token is TRUE|FALSE {
        return token == TRUE;
    } else {
        panic error("Unexpected token " + token);
    }
}

function finishInnerNode(Tokenizer tok, string identifier) returns InnerNode {
    expectToken(tok, QUESTION_MARK);
    Node left = parseNode(tok);
    expectToken(tok, COLON);
    Node middle = parseNode(tok);
    expectToken(tok, COLON);
    Node right = parseNode(tok);
    return {identifier, left, middle, right};
}

function expectToken(Tokenizer tok, Token token) {
    Token? next = tok.next();
    if next == () {
        panic error("Unexpected EOF");
    }
    if next != token {
        panic error("Unexpected token " + tokenToString(next) + " expected " + tokenToString(token));
    }
}

