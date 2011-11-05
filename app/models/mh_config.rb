require 'ostruct'

class MHConfig
  class DSL
    attr_reader :services, :hosts
    
    def initialize
      @services = {}
      @hosts = {}
      @email = nil
    end
    
    def email *args
      if args.length > 0
        @email = args[0]
      else
        @email
      end
    end
    
    def frequency *args
      if args.length > 0
        @frequency = args[0]
      else
        @frequency
      end
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
    
    def local &block
      if block_given?
        @local = block
      else
        @local
      end
    end
  end 
  
  class << self
    attr_reader :email
          
    def parse string
      dsl = DSL.new
      dsl.instance_eval string
      @services = dsl.services
      @hosts = dsl.hosts
      @email = dsl.email
      @frequency = dsl.frequency
    end
    
    def frequency
      @frequency || 5.minutes
    end
    
    def services
      @services || {}
    end
    def hosts
      @hosts || {}
    end
  end
end