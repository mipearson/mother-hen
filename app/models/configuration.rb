require 'ostruct'

class Configuration
  class DSL
    attr_reader :services, :hosts
    
    def initialize
      @services = {}
      @hosts = {}
    end
    def host name, opts = {}
      new_host = OpenStruct.new
      new_host.services = opts[:services] if opts.include? :services
      new_host.name = name
      new_host.hostname = name
      @hosts[name] = new_host
    end
    
    def service name, &block
      @services[name] = ServiceDSL.new name
      @services[name].instance_eval &block
    end
  end
  
  class ServiceDSL
    attr_reader :name
    
    def initialize name
      @name = name
      @ruby_block = lambda {}
    end
    
    def ruby_block &block
      if block_given?
        @ruby_block = block
      else
        @ruby_block
      end
    end
  end 
  
  class << self
    def parse string
      dsl = DSL.new
      dsl.instance_eval string
      @services = dsl.services
      @hosts = dsl.hosts
    end
    
    def services
      @services || {}
    end
    def hosts
      @hosts || {}
    end
  end
end