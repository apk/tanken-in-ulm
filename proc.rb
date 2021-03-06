require 'rubygems'
require 'json'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

stm=JSON.parse(File.read('stm.json'))
stm.each_pair do |k,v|
  # puts v.inspect
  # puts "#{v['mtsk_id']} #{v['name']} #{v['strasse']}"
end

TANKS={
  "E51F11107DC14F40BD641495229268AF" => "RAN Heidenh.",
  "105307C4856245E49CC2A04EF4A19400" => "Aral Karlstr.",
  "6536B656E5794A10AF7C751CB7DB4DEF" => "Aral Illerstr.",
  "9BA4605727294DFC9E6222A65083A9DA" => "Esso Hindenb. 3",
  "36574A40AD27403692F0560AE140F871" => "Esso Hindenb. 24",
  "84DB67BD07664099B1CD0084F7AB936E" => "AVIA Blaubeurer",
  "728344C8F3FE4C809865CD7A256415FC" => "Aral BB"
}

keys=TANKS.keys.sort

out={}

File.open('data/flist') do |fi|
  fi.each_line do |ln|
    File.open(ln.strip+'.jsa') do |f|
      f.each_line do |l|
        j=JSON.parse(l)
        i=1
        o=[j['t']]
        keys.each do |k|
          o[i]=j[k] ? j[k]+i/1000.0 : 1.2
          i+=1
        end
        out[o[0]]=o
      end
    end
  end
end
# puts out.inspect
File.open("tmp.data","w") do |f|
  out.keys.sort.each do |k|
    f.puts out[k].join(' ')
  end
end

IO.popen("gnuplot44","w") do |f|
  f.puts "set terminal png size 1024,384"
  f.puts "set output \"cost.png\""
  f.puts "set title \"E5\""
  # f.puts "set xtics scale 0.6"
  f.puts "set timefmt \"%s\""
  f.puts "set format x \"%d.%m %H\""
  f.puts "set xdata time"
  f.puts "set key horizontal below"
  # f.puts "set xrange [0:24]"
  f.puts "set grid"
  z=1
  s=keys.sort.map do |a|
    z+=1
    "\"tmp.data\" using 1:#{z} with lines title \"#{TANKS[a]}\""
  end
  f.puts "plot #{s.join','}"
end
