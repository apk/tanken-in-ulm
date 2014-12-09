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
<style>
.blkhd {
  margin: 0px;
  margin-bottom: 10px;
  border-bottom: 1px solid black;
  list-style-type: none;
  background-color: #6666ff;
  color: black;
}
.act {
  color: black;
  background-color: lightgray;
}
.blk {
  font-family: sans-serif;
  display: inline-block;
  padding: 5px;
}
.blk:hover {
  background-color: lightgray;
  color: blue;
}
.green {
  background-image: url(http://apk.li/branch.jpg);
  color: white;
}
.undec {
  text-decoration: none;
}
body {
  margin: 0pt;
}
</style>
</head>
<body bgcolor="white">
<ul class="blkhd"><li class="blk"><a class="undec" href="http://parken.apk.li/">Parken</a></li><li class="blk act">Tanken</li>&nbsp;&bullet;&nbsp;<li class="blk green"><a class="undec" href="http://apk.li/"><tt>apk.li</tt></a></li></ul>
<div style="margin: 8px;">
<h3>Tanken</h3>
<p><img src="cost.png">
</div>
</body>
</html>
EOF
cp cost.png $dir/cost.png
