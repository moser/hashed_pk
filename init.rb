require 'hashed_pk'
ActiveRecord::Base.class_eval { include Hashed_Pk }
