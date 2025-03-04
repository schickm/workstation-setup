#!/bin/sh

COMMIT_MSG_FILE=$1
TICKET=$(extract-jira-ticket.sh)

if ! grep -q "$TICKET" "$COMMIT_MSG_FILE" ; then
    printf "[%s] %s" "$TICKET" "$(cat $COMMIT_MSG_FILE)" > $COMMIT_MSG_FILE
fi


