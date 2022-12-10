output "name" {
  value = substr(sha256("hello world"), 0, 8)
}