#!/bin/bash
set -e
cleanup() {
  rm -rf $TMPDIR/build/*
}
cleanup
echo done
