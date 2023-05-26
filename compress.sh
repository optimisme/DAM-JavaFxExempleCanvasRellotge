#!/bin/bash

folder=`basename "$PWD"` && find . -path './.*' -o -path './Release/*' ! -name '.gitignore' -prune -o -print | zip -r ../$folder.zip -@ -x '**/__MACOSX' -x '*.zip'