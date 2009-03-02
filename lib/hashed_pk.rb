module Hashed_Pk
  def self.included(base) #:nodoc:
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def has_hashed_primary_key(options = {})
      opt = { :length => 31, :init_string => lambda { Time.now.to_f.to_s } }
      opt.merge!(options)
      
      @hashed_pk_length = opt[:length]
      @hashed_pk_init_string = opt[:init_string]
      
      include InstanceMethods
      before_create :set_id
    end
    
    def init_string
      @hashed_pk_init_string.call
    end
    
    def max_tries
      if !@hashed_pk_max_tries
        @hashed_pk_max_tries = ((2**@hashed_pk_length) * 1.5).to_i
      end
      @hashed_pk_max_tries
    end
    
    def hash_n(str)
      i = Digest::SHA1.hexdigest(str).hex
      i % (2**@hashed_pk_length)
    end
    
  end
  
  module InstanceMethods
  protected
    def set_id
      i = self.class.hash_n(self.class.init_string)
      tries = 1
      while self.class.base_class.exists?(i) do
        i = self.class.hash_n(i.to_s + self.class.init_string)
        tries += 1
        # it 
        if tries > self.class.max_tries
          raise ActiveRecord::ActiveRecordError
        end
      end
      self.send("#{self.class.primary_key}=", i)
    end
  end
end
