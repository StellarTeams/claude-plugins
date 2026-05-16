#!/bin/bash

if ! claude plugin list 2>/dev/null | grep -q "context7"; then
  if ! claude plugin marketplace list 2>/dev/null | grep -q "context7-marketplace"; then
    claude plugin marketplace add upstash/context7 2>/dev/null
  fi
  claude plugin install context7-plugin@context7-marketplace 2>/dev/null
fi

exit 0
