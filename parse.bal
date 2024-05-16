type Node InnerNode|LeafNode;

type NodeBase record {
    int index;
};

type LeafNode readonly & record {|
    *NodeBase;
    boolean value;
|};

type InnerNode readonly & record {|
    *NodeBase;
    string identifier;
    Node left;
    Node middle;
    Node right;
|};

class ParseContext {
    int nextId = 0;

    function nextIndex() returns int {
        int index = self.nextId;
        self.nextId = self.nextId + 1;
        return index;
    }
}

function parseNode(ParseContext cx, Tokenizer tok) returns Node {
    Token? token = tok.next();
    if token == () {
        panic error("Unexpected EOF");
    }
    if token is Identifier {
        return finishInnerNode(cx, tok, token[0]);
    } else if token == OPEN_PAREN {
        Node node = parseNode(cx, tok);
        expectToken(tok, CLOSE_PAREN);
        return node;
    } else if token is TRUE|FALSE {
        return {index: cx.nextIndex(), value: token == TRUE};
    } else {
        panic error("Unexpected token " + token);
    }
}

function finishInnerNode(ParseContext cx, Tokenizer tok, string identifier) returns InnerNode {
    int index = cx.nextIndex();
    expectToken(tok, QUESTION_MARK);
    Node left = parseNode(cx, tok);
    expectToken(tok, COLON);
    Node middle = parseNode(cx, tok);
    expectToken(tok, COLON);
    Node right = parseNode(cx, tok);
    return {index, identifier, left, middle, right};
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

