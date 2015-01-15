require 'rubygems'
require 'json'

def load_jsa fn
  a=[]
  File.open(fn) do |f|
    f.each_line do |l|
      a<<=JSON.parse(l)
    end
  end
  a
end

def simp inp
  a=[]
  last=nil # last thing we wrote (modifyable)
  curr=nil # next thing we want to write
  inp.each do |r|
    if last
      last['t']=r['t']
      if last == r
        # Doesn't change, just extend
        curr=r
      else
        # Does change, write old and new thing, and restart.
        if curr
          a<<=curr
        end
        last=r.clone
        a<<=r
        curr=nil
      end
    else
      last=r.clone
      a<<=r
    end 
  end
  if curr
    a<<=curr
  end
  a
end

a=simp(load_jsa('data/16450.jsa'))

TANKS={
  "E51F11107DC14F40BD641495229268AF" => "RAN Heidenh.",
  "105307C4856245E49CC2A04EF4A19400" => "Aral Karlstr.",
  "6536B656E5794A10AF7C751CB7DB4DEF" => "Aral Illerstr.",
  "9BA4605727294DFC9E6222A65083A9DA" => "Esso Hindenb. 3",
  "36574A40AD27403692F0560AE140F871" => "Esso Hindenb. 24",
  "84DB67BD07664099B1CD0084F7AB936E" => "AVIA Blaubeurer",
  "728344C8F3FE4C809865CD7A256415FC" => "Aral BB"
}

TANKS.each_pair do |k,n|
  puts "#{k}: #{n}"
  bt=nil
  bv=nil
  et=nil
  a.each do |d|
    t=d['t']
    d=d[k]
    if bt
      if bv==d
        et=t
      else
        if et
          puts "#{bt} -> #{et}: #{bv}" if bv
          bt=et
        end
        puts "#{bt} -> #{t}: #{bv} -> #{d}" if bv and d
        bt=t
        bv=d
        et=nil
      end
    else
      bt=t
      bv=d
      et=nil
    end
  end
  if et
    puts "#{bt} -> #{et}: #{bv}" if bv
  end
end

#keys=[]
#a.each do |x|
#  puts JSON.generate(x)
#end
