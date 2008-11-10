require 'rubygems'
require 'atchoum'

class Invisible < Atchoum::Website
  ROOT = ENV['SITE_ROOT'] || ''
  
  def layout
    xhtml_html do
      head do
        title 'The Invisible Web Framework'
        link :rel => 'stylesheet', :href => "#{ROOT}/screen.css", :type => 'text/css', :media => "screen, projection"
        link :rel => 'stylesheet', :href => "#{ROOT}/print.css", :type => 'text/css', :media => "print"
        text "<!--[if IE]>"
        link :rel => 'stylesheet', :href => "#{ROOT}/ie.css", :type => 'text/css', :media => "screen, projection"
        text "<![endif]-->"
      end
      body do
        div :class => "header prepend-2" do
          h1 "Invisible"
          h4 {"Small, Simple #{span.alt('&')} Easy"}
        end
        div.container do
          div.screenshots! :class => "prepend-2 clearfix" do
            div :class => "span-7 column" do
              img :src => "http://code.macournoyer.com/images/defensio_plugin.gif"
              p "Rails structure"
            end
            div :class => "span-7 column" do
              img :src => "http://code.macournoyer.com/images/defensio_plugin.gif"
              p "All in one place"
            end
            div :class => "span-7 column" do
              img :src => "http://code.macournoyer.com/images/defensio_plugin.gif"
              p "Almost no code"
            end
          end
          
          pre.install! "gem install macournoyer-invisible \n--source http://gems.github.com", :class => "prepend-2"
          
          pre.box.sample! do
            <<-EOS.gsub(/^\s{14}/, '')
              get "ohaie" do
                render "nice"
              end
            EOS
          end
          
          div.footer do
            text "&copy; "
            a(:href => 'http://macournoyer.com') { 'Marc-Andr&eacute; Cournoyer' }
          end
        end
      end
    end
  end
  
  def index_page
    h1 "ohaie"
  end
end