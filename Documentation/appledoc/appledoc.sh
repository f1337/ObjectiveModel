#!/bin/sh

APPLEDOC="./appledoc"
PROJECT_NAME="ObjectiveModel"
PROJECT_COMPANY="Michael R. Fleet"
COMPANY_ID="us.f1337.michael"
TEMPLATES_PATH="Templates/"
SOURCE_PATH="../../ObjectiveModel"

$APPLEDOC --project-name "$PROJECT_NAME" --project-company "$PROJECT_COMPANY" --company-id "$COMPANY_ID" -t $TEMPLATES_PATH --ignore .m $SOURCE_PATH