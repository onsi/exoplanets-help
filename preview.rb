#!/usr/bin/ruby
require 'erb'
require 'yaml'
require 'fileutils'

CONTENT = File.join(File.dirname(__FILE__), 'content')
LIB = File.join(File.dirname(__FILE__), 'lib')
PREVIEW = File.expand_path(File.join(File.dirname(__FILE__), 'preview'))

FileUtils.rmtree(PREVIEW)
FileUtils.mkdir(PREVIEW)
FileUtils.cp(Dir.glob(File.join(LIB,'*')), PREVIEW)

help_entries = YAML::load(File.open(File.join(CONTENT, 'help.yaml')).read)
head = <<-HEAD
  <html>
  <head>
  <link href="#{PREVIEW + '/help.css'}" rel="stylesheet" type="text/css" />
  <script src="#{PREVIEW + '/jquery.js'}" type="text/javascript"></script>
  <script src="#{PREVIEW + '/help.js'}" type="text/javascript"></script>
  </head>
  <body>
  <div class="header">
      <div class="bold header-link">Kepler Explorer</div>
      <div class="header-link">Help Preview</div>
  </div>
HEAD

foot = %q{
  </body>
  </html>
}

puts "Generating Previews"
puts "==================="
Dir.glob(File.join(CONTENT, '**', '*.erb')) do |filename|
  puts "For #{filename}"
  target_name = filename.sub(/\.\/content\//, '')
  target_dir = File.join(PREVIEW, File.dirname(target_name))
  FileUtils.mkdir_p(target_dir)
  rendered_file = ERB.new(File.open(filename).read).result
  this_target_link = target_name.sub(/\.erb/,'')
  all_help_entries = help_entries['all']
  erb = ERB.new %q{
    <%= head %>
    <div class='sidebar'>
        <ul>
            <% for help_entry in all_help_entries do %>
            <% if help_entry['divider'] %>
            <li class="divider"><%= help_entry['divider'] %></li>
            <% else %>
            <a href="../<%= "#{help_entry['link']}.html" %>">
            <li class="<%= help_entry['link'] == this_target_link ? "current" : "help-link" %>"><%= help_entry['name'] %></li>
            </a>
            <% end %>
            <% end %>
        </ul>
    </div>
    <div class="content">
    <%= rendered_file %>
    </div>
    <%= foot %>
  }
  
  target_filename = File.join(target_dir, File.basename(target_name, File.extname(target_name)) + '.html')  
  File.open(target_filename, 'w') do |f|
    f << erb.result(binding)
  end
end

`open #{File.join(PREVIEW, "#{help_entries['all'][1]['link']}.html")}`