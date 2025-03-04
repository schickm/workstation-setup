#!/bin/sh

COMMIT_MSG_FILE=$1
TICKET=$(extract-jira-ticket.sh)
TICKET_FORMATTED="[$TICKET]"

if test -n "$TICKET" && ! grep -q "$TICKET_FORMATTED" "$COMMIT_MSG_FILE" ; then
    printf "%s %s" "$TICKET_FORMATTED" "$(cat $COMMIT_MSG_FILE)" > $COMMIT_MSG_FILE
fi


