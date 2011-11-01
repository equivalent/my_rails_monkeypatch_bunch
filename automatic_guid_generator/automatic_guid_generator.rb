 # config/initializers/automatic_guid.rb

 module AutomaticGuidGenerator
   class ActiveRecord::Base
     before_create :pre_generate_guid_automaticly

     
     def self.generate_random_string(length)
        Base64.encode64(Digest::SHA1.digest("#{rand(1<<128)}/#{Time.now.to_f}/#{Process.pid}")).gsub(/([^ a-zA-Z0-9_.-]+)/n) do
           '%' + $1.unpack('H2' * $1.size).join('%').upcase
        end.tr(' ', '+').gsub('%','q')[1..length].downcase
     end

     def generate_random_guid
        length=10

        random_string = self.class.generate_random_string(length)
        until self.class.where( 'guid = ?', random_string ).present? == false do
          random_string = self.class.generate_random_string(length)
        end

        self.guid = random_string
     end
     
     def pre_generate_guid_automaticly
       #if table have guid column, pre-generate it's uniq guid
       if self.class.column_names.include? 'guid' 
         generate_random_guid
       end
     end
   end
 end
