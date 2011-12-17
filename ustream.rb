require 'nokogiri'

dvgrab_base = 'dvgrab -f raw - | ffmpeg -f dv -i -'
fme_sig = 'flashver=FME/3.0\20(compatible;\20FMSc/1.0)'
frame = 10
video_bitrate = '300k'
audio_bitrate = '48k'
audio_sampling_rate = 22050
video_size = '320x240'

 if ARGV[0] == nil then
    puts "Please specify the files for ustream."
    exit
end

if !File.exist?(ARGV[0]) then
    puts "File not found."
    exit
end

f = File.open(ARGV[0])
ust_xml = Nokogiri::XML(f)
rmtp_uri = ust_xml.xpath("//output/rtmp/url").text
key = ust_xml.xpath("//output/rtmp/stream").text

print "RMTP: %s\n" % rmtp_uri
print "KEY: %s\n" % key

cmd = "%s -s %s -r %d -b %s -as %d -ab %s -f flv \'%s/%s %s\'" % 
	[dvgrab_base, video_size, frame, video_bitrate, audio_sampling_rate, 
	audio_bitrate, rmtp_uri, key, fme_sig]

system(cmd)
if ($? != 0) then
  puts "Failed."
  exit
end
