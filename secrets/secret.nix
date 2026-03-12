let
  neo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0dkeI+7IdQujtZ3UCSfYB2uPFKZz3i7hWlO4O/sMh+ me@nikolajjsj.com";
  users = [ neo ];
in
{
  "cloudflare.age".publicKeys = users;
  "hashed-password-file".publicKeys = users;
};
