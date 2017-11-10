data "archive_file" "response_headers" {
  type = "zip"
  output_path = "${path.module}/function.zip"
  source {
    filename = "index.js"
    content = "${file("${path.module}/index.js")}"
  }
}

resource "aws_lambda_function" "response_headers" {
  provider = "aws.us-east-1"
  function_name = "response_headers"
  filename = "${data.archive_file.response_headers.output_path}"
  source_code_hash = "${data.archive_file.response_headers.output_base64sha256}"
  role = "${aws_iam_role.lambda.arn}"
  handler = "index.handler"
  runtime = "nodejs6.10"
  memory_size = 128
  timeout = 1
  publish = true
}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name_prefix = "${var.bucket}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda.json}"
}

resource "aws_iam_role_policy_attachment" "basic" {
  role = "${aws_iam_role.lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
