platform :ios, '9.0'
use_frameworks!

target 'SocialEase' do
  pod 'AFNetworking'
  pod 'BDBOAuth1Manager'
  pod 'Parse'
end

post_install do |installer|
  directory = installer.config.project_pods_root + 'BDBOAuth1Manager/BDBOAuth1Manager'
  puts directory
  if File.directory?(directory)
  	puts Dir.entries(directory)
  	Dir.entries(directory).each do |filename|
  	  full_path = directory + filename
  	  puts full_path
  	  if File.file?(full_path)
  	    text = File.read(full_path)
  		new_contents = text.gsub(/#import "(AF.+)"/, '#import <AFNetworking/\1>')
  	    File.open(full_path, "w") {|file| file.puts new_contents }
  	  end
  	end
  end
end

