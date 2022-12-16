#!/usr/bin/env bash

dir=$(dirname $0)/../..

rm $dir/app/assets/fontawesome/png/*
rm $dir/dev/assets/fontawesome/png/*

for source in $dir/dev/assets/fontawesome/svg/*; do
  filename=$(basename -s .svg $source)
  inkscape -z -e $dir/dev/assets/fontawesome/png/$filename.png $source
done

mogrify -resize 20x20\> \
 -gravity center \
 -extent 20x20 \
 -background none \
 -path $dir/app/assets/fontawesome/png \
 $dir/dev/assets/fontawesome/png/*
