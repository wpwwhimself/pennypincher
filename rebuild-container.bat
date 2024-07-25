@echo off

if [%1] == [] (
  echo Error: no container defined. Choose a container:
  call docker ps -a --format "{{.Names}}"
  exit /b 1
)

echo Stopping %1:
call docker stop %1
call docker rm -v %1

echo Rebuilding %1:
call docker-compose build %1
call docker-compose up -d %1

echo Clearing up:
call docker image prune -f
call docker builder prune -f
