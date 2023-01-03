#!/usr/bin/env bash

dir=$(dirname $0)/../..

rm $dir/app/assets/fontawesome/buttons/*
rm $dir/dev/assets/fontawesome/buttons/png/*

for source in $dir/dev/assets/fontawesome/buttons/svg/*; do
  filename=$(basename -s .svg $source)
  inkscape -z -e $dir/dev/assets/fontawesome/buttons/png/$filename.png $source
done

mogrify -resize 20x20\> \
 -gravity center \
 -extent 20x20 \
 -background none \
 -path $dir/app/assets/fontawesome/buttons \
 $dir/dev/assets/fontawesome/buttons/png/*

inkscape -z -e $dir/app/assets/fontawesome/appicon.png $dir/dev/assets/fontawesome/appicon.svg
