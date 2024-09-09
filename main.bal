import ballerina/io;
import ballerina/file;

isolated function getName(Node node) returns string {
    return string `node_${node.index}`;
}

isolated function nodeToString(Node node) returns string {
    if node is LeafNode {
        return node.value ? "True" : "False";
    }
    return string `${node.identifier}`;
}

isolated function nodeColor(LeafNode node) returns string {
    return node.value ? "green" : "red";
}

function drawNode(Node node, string[] edgeBuffer, string[] nodeBuffer) {
    string name = getName(node);
    string label = nodeToString(node);
    if node is LeafNode {
        nodeBuffer.push(string `  ${name} [label="${label}" color="${nodeColor(node)}"];`);
        return;
    }
    nodeBuffer.push(string `  ${name} [label="${label}"];`);
    edgeBuffer.push(string `  ${name} -> ${getName(node.left)} [label="Left"];`);
    edgeBuffer.push(string `  ${name} -> ${getName(node.middle)} [label="Middle"];`);
    edgeBuffer.push(string `  ${name} -> ${getName(node.right)} [label="Right"];`);
    drawNode(node.left, edgeBuffer, nodeBuffer);
    drawNode(node.middle, edgeBuffer, nodeBuffer);
    drawNode(node.right, edgeBuffer, nodeBuffer);
}

function drawGraph(Node topNode) returns string {
    string[] edgeBuffer = [];
    string[] nodeBuffer = [];
    drawNode(topNode, edgeBuffer, nodeBuffer);
    string[] graph = [];
    graph.push("digraph G {");
    graph.push("node [shape=circle];");
    graph.push(...nodeBuffer);
    graph.push(...edgeBuffer);
    graph.push("}");
    return "\n".join(...graph);
}

function getInputData(string data) returns string|error {
    boolean isFile = check file:test(data, "EXISTS");
    if (isFile) {
        return check io:fileReadString(data);
    }
    return data;
}

public function main(string inputData) returns error? {
    string data = check getInputData(inputData);
    Tokenizer tokenizer = new Tokenizer(data);
    ParseContext context = new;
    Node topNode = parseNode(context, tokenizer);
    string graph = drawGraph(topNode);
    io:println(graph);
}

