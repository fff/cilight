#! /bin/ruby
require 'rubygems'
require 'nokogiri'
require './lib.rb'

class Light 
	def failure!
		puts :RED!
	end

	def warning!
		puts :PINK!
	end

	def building!
		puts :BLUE!
	end

	def success!
		puts :GREEN!
	end

	def off!
		puts :OFF!
	end
end

class Pipeline
	def read_project
		Nokogiri::XML('<Projects>
<Project webUrl="http://ci:9090/job/iiWeb/" name="iiWeb" lastBuildLabel="789" lastBuildTime="2014-05-21T10:03:33Z" lastBuildStatus="Failure" activity="Building"/>
<Project webUrl="http://ci:9090/job/iiWeb-FT/" name="iiWeb-FT" lastBuildLabel="832" lastBuildTime="2014-05-21T09:36:17Z" lastBuildStatus="Success" activity="Sleeping"/>
<Project webUrl="http://ci:9090/job/iiWeb2/" name="iiWeb-FT" lastBuildLabel="832" lastBuildTime="2014-05-21T09:36:17Z" lastBuildStatus="Success" activity="Building"/>
<Project webUrl="http://ci:9090/job/iiWeb2/" name="NNN" lastBuildLabel="832" lastBuildTime="2014-05-21T09:36:17Z" lastBuildStatus="Failure" activity="Building"/>
</Projects>').xpath('//Projects/Project').reject{|p| @ignoreNames.include? p.attr(:name) }
	end
end


light=Light.new

pip1=Pipeline.new('http://ci:9090/view/iiWeb-pipeline/cc.xml',:red, ['NNN','iiWeb'])
pip2=Pipeline.new('http://ci:9090/view/iiWeb-pipeline/cc.xml',:pink, ['iiWeb'])

check([pip1,pip2],light)


