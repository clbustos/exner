# encoding: UTF-8

$:.unshift(File.dirname(__FILE__)+"/.")
$:.unshift(File.dirname(__FILE__)+"/../lib/")
require 'haml'

require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?

require 'logger'
require 'exner'
$log = Logger.new('log/app.log')

Haml::Template.options[:ugly] = true


configure :development do |c|
  c.enable :logging, :dump_errors, :raise_errors, :sessions
end

configure :production do |c|
  c.enable :logging, :dump_errors, :raise_errors, :sessions
end

get "/" do
  @ejemplo="
I   1   Wo      Fo               A   P     1.0    PER
I   5   Wv      VFu              Ls
I   6   Dd+     FC'.mau         (Hd),Fi   4.0     DR1
I   7   WSo     FT.mpo           Ad        3.5    MOR,DR1
II  2   W+      FMa.VF.Co   (2)	 A,Ls      5.5    AG
II  8   DSo     CF-              An        4.0
II	9   DdS+    CF-         (2)  Ls        3.0
III 3   D+      Mao         (2)  H     P   4.0    COP
III 4   D+      Mp.Co       (2)  H,Id  P   3.0    DR1
III 10  D+      Ma.FC.mpu   (2)  H,Cg      3.0    DV2
III 11  W+      Ma.FTo           H,Sc  P   5.5
"
    
  haml :index
end
