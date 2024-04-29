import json
import subprocess

new_version = input("Enter new version tag: ")

#### app ####
path_to_app_file = "app/package.json"
with open(path_to_app_file, "r") as file:
  data = json.load(file)
data["version"] = new_version
with open(path_to_app_file, "w") as file:
  json.dump(data, file, indent = 2)

# build
subprocess.run("cd app && npm run build", shell = True)

#### backend ####
path_to_app_file = "backend/composer.json"
with open(path_to_app_file, "r") as file:
  data = json.load(file)
data["version"] = new_version
with open(path_to_app_file, "w") as file:
  json.dump(data, file, indent = 2)

#### docker stuff ####

subprocess.run("docker stop app backend && docker rm app backend && docker image prune && docker-compose build app backend && docker-compose up -d", shell = True)
