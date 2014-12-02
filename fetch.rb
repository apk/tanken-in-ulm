require 'json'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

res=nil

IO.popen("/usr/bin/wget --tries=1 -O - 'http://www.spritpreismonitor.de/suche/?tx_spritpreismonitor_pi1[searchRequest][plzOrtGeo]=89073&tx_spritpreismonitor_pi1[searchRequest][umkreis]=5&tx_spritpreismonitor_pi1[searchRequest][kraftstoffart]=e5&tx_spritpreismonitor_pi1[searchRequest][tankstellenbetreiber]='") do |f|
  f.each_line do |l|
    if l =~ /var spmResult = (\[.*\]);/
      res=$1
    end
  end
end

js=JSON.parse(res)
t=Time.now().to_i
out={ 't' => t}
stm={}

js.each do |j|
  begin
    out[j['mtsk_id']]=j['e5'].to_f
  rescue e
    # nix
  end
  stm[j['mtsk_id']]=j
end

s=(t%86400).to_s
fnm="data/#{t/86400}"
File.open("#{fnm}.jsa","a") do |f|
  f.puts JSON.generate(out)+"\n"
end
File.open("stm.json","w") do |f|
  f.puts JSON.generate(stm)+"\n"
end

fn=[fnm]
begin
  File.open("data/flist") do |f|
    f.each_line do |l|
      fn<<=l.strip
    end
  end
rescue Errno::ENOENT
puts fn.inspect
end
File.open("data/flist","w") do |f|
  fn.sort.uniq.reverse[0..7].each do |n|
    f.puts n
  end
end

