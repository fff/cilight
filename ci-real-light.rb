#! /bin/ruby
require 'rubygems'
require 'blinky'

light = Blinky.new.light 

dev=Pipeline.new('http://ci:9090/view/dev-pipeline/cc.xml',:red, [])
test=Pipeline.new('http://ci:9090/view/test-pipeline/cc.xml',:pink, ['SHARK-SIT-regression'])

check([dev,test],light)

