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
<html>
<head>
<title>Tanken in Ulm</title>
<link rel="stylesheet" type="text/css" href="http://ken.apk.li/ken.css">
</head>
<body bgcolor="white">
<ul class="blkhd"><li class="blk"><a class="undec" href="http://parken.apk.li/">Parken</a></li><li class="blk act">Tanken</li>&nbsp;&bullet;&nbsp;<li class="blk green"><a class="undec" href="http://apk.li/"><tt>apk.li</tt></a></li></ul>
<div class="bodybox">
<h3>Tanken</h3>
<p><img src="cost.png">
</div>
</body>
</html>
EOF
cp cost.png $dir/cost.png
