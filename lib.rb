#! /bin/ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'

ColorMap = {
	:red => :failure!,
	:blue => :building!,
	:pink => :warning!,
	:green => :success!,
	:black => :off!
}	

class Pipeline
	def initialize(url, color, ignoreNames)
		@url = url
		@color = color
		@ignoreNames = ignoreNames
		puts "Watch pipeline [#{@url}] with [#{@color}] as failure color, and ignore:#{@ignoreNames}"
	end

	def read_project
		Nokogiri::XML(open(@url)).xpath('//Projects/Project').reject{|p| @ignoreNames.include? p.attr(:name) }
	end
# <Project webUrl="http://ci:9090/job/iiWeb/" name="iiWeb" lastBuildLabel="789" lastBuildTime="2014-05-21T10:03:33Z"
# lastBuildStatus="Failure" activity="Sleeping"/>
	def read_cc_status(light)
		hasBuilding = false
		read_project.each do |p|
			return failure(light, p) unless p.attr(:lastBuildStatus).eql? :Success.to_s
			puts "#{p.attr(:name)} is #{p.attr(:lastBuildStatus)} and #{p.attr(:activity)}"
			hasBuilding &= p.attr(:activity).eql? :Building.to_s
		end
		hasBuilding ? :Building : :Sleeping
	end

	def failure(light, p)
		puts "#{p.attr(:name)} is failure! last status: #{p.attr(:lastBuildStatus)}"
		light.method(ColorMap[@color]).call
		:Failure
	end
end

def check(pipelines, light)
	test(light)
	statuses = pipelines.map do |pip| 
		status = pip.read_cc_status(light)
		return :Failure if status.eql? :Failure
	end

	return light.building! if statuses.include? :Building
	return light.success! 
end

def test(light)
	light.success!
	light.failure!
	light.building!
	light.warning!
	light.off!
end	