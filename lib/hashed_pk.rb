module Hashed_Pk
  def self.included(base) #:nodoc:
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def has_hashed_primary_key(options = {})
      if options.include? :hash_algorithm
        @hash_algorithm = options[:hash_algorithm]
      else
        @hash_algorithm = lambda { |str| Digest::MD5.hexdigest(str) }
      end
      if options.include? :init_string
        @init_string = options[:init_string]
      else
        @init_string = lambda { Time.now.to_s }
      end
      include InstanceMethods
      before_create :set_id
    end
    
    def hash_algorithm
      @hash_algorithm
    end
    
    def init_string
      @init_string.call
    end
  end
  
  module InstanceMethods
  protected
    def set_id
      str = self.class.hash_algorithm.call(self.class.init_string)
      #TODO: in case of STI this will not be correct (find parent?)
      while self.class.exists?(str) do
        str = self.class.hash_algorithm.call(str)
      end
      self.id = str
    end
  end
end
