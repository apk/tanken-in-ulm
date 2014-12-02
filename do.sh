#!/bin/sh
cd `dirname $0`
LANG=C
export LANG
exec >>do.log 2>&1

mkdir -p data
touch data/flist

/package/host/localhost/ruby-2.1.1/bin/ruby fetch.rb
/package/host/localhost/ruby-2.1.1/bin/ruby proc.rb

dir=../../html/tanken

cat >$dir/index.html <<\EOF
<p>Tanken:
<p><img src="cost.png">
EOF
cp cost.png $dir/cost.png
