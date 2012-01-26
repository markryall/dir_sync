Given /^the file system:$/ do |table|
  `mkdir -p tmp/aruba`
  Dir.chdir 'tmp/aruba' do
    table.hashes.each do |row|
      path, time =  row['path'], row['time'].to_i
      formatted_time = Time.at(time).strftime '%Y%m%d%H%M.%S'
      `mkdir -p #{File.dirname path}`
      `touch -t #{formatted_time} #{path}`
    end
  end
end

Given /^past synchronisation history:$/ do |table|
  home = File.expand_path '~'
  `mkdir #{home}/.dir_sync`
  File.open("#{home}/.dir_sync/test", 'w') do |f|
    table.hashes.each do |row|
      path, time =  row['path'], row['time'].to_i
      f.puts "#{path}:#{time}"
    end
  end
end