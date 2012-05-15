name "redmine"
description "Role for redmine."

run_list(
  "recipe[database]",
  "recipe[mysql::server]",
  "recipe[redmine]"
)

override_attributes(
  "mysql" => {
    "server_debian_password" => "",
    "server_root_password" => "37&9HJ6C8f"
  },
  "passenger" => {
    "version" => "2.2.15"
  },
  "redmine" => {
    "version" => "1.4.1",
    "session" => {
      "key" => "_redmine_session",
      "secret" => "b8x9cf018836e53e2216c428376931151c6882afb84f4794f98bbcc80352b62a60a7f93206c7f1a846461055af813fe853401e94be68ab737dbb5c5bf7f0c1f3"
    },
    "rails" => {
      "version" => "2.3.5",
      "environment" => "production"
    },
    "db" => {
      "type" => "mysql",
      "user" => "root",
      "password" => "redmine",
      "database" => "redmine",
      "hostname" => "localhost"
    }
  }
)
