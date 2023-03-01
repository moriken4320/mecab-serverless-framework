import json
import MeCab

neologd_tagger = MeCab.Tagger(
    '-O wakati '
    '-r /dev/null ')


def lambda_handler(event, context):
    node = neologd_tagger.parseToNode(event['body'])

    result = []
    while node:
        if not node.feature.startswith('BOS/EOS'):
            result.append(node.feature)
        node = node.next

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps(result),
        "isBase64Encoded": False
    }
