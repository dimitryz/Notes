#!/bin/bash

cd `dirname "$0"`
cd NotesServer
swift package update
cd ../NotesShared
swift package update
