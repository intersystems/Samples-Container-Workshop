REM Simple run command to launch an InterSystems IRIS container on Windows
REM create the directory 'durable' with mode 777
docker run ^
  --publish 80:52773 ^
  --publish 1972:1972 ^
  --volume=%CD%\durable:/ISC^
  --rm=true^
  --detach ^
  --env ISC_DATA_DIRECTORY=/ISC/iris.data.d^
  --name=GS2023 ^
  containers.intersystems.com/intersystems/iris-community:2023.1.0.229.0