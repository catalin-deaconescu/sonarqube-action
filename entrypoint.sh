#!/bin/bash

set -e

REPOSITORY_NAME=$(basename "${GITHUB_REPOSITORY}")

if [[ ! -z "${INPUT_PASSWORD}" ]]; then
  echo "::warning ::Running this GitHub Action without authentication token is NOT recommended!"
  SONAR_PASSWORD="${INPUT_PASSWORD}"
else
  SONAR_PASSWORD=""
fi

if [[ -f "${INPUT_PROJECTBASEDIR%/}pom.xml" ]]; then
  echo "::error file=${INPUT_PROJECTBASEDIR%/}pom.xml::Maven project detected. You should run the goal 'org.sonarsource.scanner.maven:sonar' during build rather than using this GitHub Action."
  exit 1
fi

if [[ -f "${INPUT_PROJECTBASEDIR%/}build.gradle" ]]; then
  echo "::error file=${INPUT_PROJECTBASEDIR%/}build.gradle::Gradle project detected. You should use the SonarQube plugin for Gradle during build rather than using this GitHub Action."
  exit 1
fi

pwd
ls -d */

#check sonar inputs
if [[ ! -f "${INPUT_PROJECTBASEDIR%/}sonar-project.properties" ]]; then
  [[ -z "${INPUT_PROJECTKEY}" ]] && SONAR_PROJECTKEY="${REPOSITORY_NAME}" || SONAR_PROJECTKEY="${INPUT_PROJECTKEY}"
  [[ -z "${INPUT_PROJECTNAME}" ]] && SONAR_PROJECTNAME="${REPOSITORY_NAME}" || SONAR_PROJECTNAME="${INPUT_PROJECTNAME}"
  [[ -z "${INPUT_PROJECTVERSION}" ]] && SONAR_PROJECTVERSION="" || SONAR_PROJECTVERSION="${INPUT_PROJECTVERSION}"

  #check if any location for scan is defined
  if [[ ! -z ${INPUT_ANGULARLOCATION} || ! -z ${INPUT_NETLOCATION} || ! -z ${INPUT_NODELOCATION} || ! -z ${INPUT_PYTHONLOCATION} || ! -z ${INPUT_SQLLOCATION} ]];  then
   
    #check angular location
    if [ ! -z ${INPUT_ANGULARLOCATION} ]; then
      echo 'start for angular';
      sonar-scanner \
        -Dsonar.host.url="${INPUT_HOST}" \
        -Dsonar.projectKey="${SONAR_PROJECTKEY}" \
        -Dsonar.projectName="${SONAR_PROJECTNAME}" \
        -Dsonar.projectVersion="${SONAR_PROJECTVERSION}" \
        -Dsonar.projectBaseDir="/github/workspace${INPUT_ANGULARLOCATION}" \
        -Dsonar.login="${INPUT_LOGIN}" \
        -Dsonar.password="${SONAR_PASSWORD}" \
        -Dsonar.sources="/github/workspace${INPUT_ANGULARLOCATION}" \
        -Dsonar.sourceEncoding="${INPUT_ENCODING}"
    fi

    #check .net location
    if [ ! -z ${INPUT_NETLOCATION} ]; then
      echo 'start for .net';
      sonar-scanner \
        -Dsonar.host.url="${INPUT_HOST}" \
        -Dsonar.projectKey="${SONAR_PROJECTKEY}" \
        -Dsonar.projectName="${SONAR_PROJECTNAME}" \
        -Dsonar.projectVersion="${SONAR_PROJECTVERSION}" \
        -Dsonar.projectBaseDir="/github/workspace${INPUT_NETLOCATION}" \
        -Dsonar.login="${INPUT_LOGIN}" \
        -Dsonar.password="${SONAR_PASSWORD}" \
        -Dsonar.sources="/github/workspace${INPUT_NETLOCATION}" \
        -Dsonar.sourceEncoding="${INPUT_ENCODING}"
    fi

    #check node location
    if [ ! -z ${INPUT_NODELOCATION} ]; then
      echo 'start for node';
    fi

    #check python location
    if [ ! -z ${INPUT_PYTHONLOCATION} ]; then
      echo 'start for python';
    fi

    #check SQL location
    if [ ! -z ${INPUT_SQLLOCATION} ]; then
      echo 'start for SQL';
      sonar-scanner \
        -Dsonar.host.url="${INPUT_HOST}" \
        -Dsonar.projectKey="${SONAR_PROJECTKEY}" \
        -Dsonar.projectName="${SONAR_PROJECTNAME}" \
        -Dsonar.projectVersion="${SONAR_PROJECTVERSION}" \
        -Dsonar.projectBaseDir="/github/workspace${INPUT_SQLLOCATION}" \
        -Dsonar.login="${INPUT_LOGIN}" \
        -Dsonar.password="${SONAR_PASSWORD}" \
        -Dsonar.sources="/github/workspace${INPUT_SQLLOCATION}" \
        -Dsonar.sourceEncoding="${INPUT_ENCODING}"
    fi

  else
    echo "::error I have no idea what you want to run Sonar for. Check your locations.";
  fi

else
  echo "::error I don't know why you ended up here. Check missing variables in your workflow"
fi
