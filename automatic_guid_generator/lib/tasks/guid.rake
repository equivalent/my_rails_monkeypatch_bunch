# rake guid:update_nil   # updating records that has nil guid; f.e. if you add guid to table with preexisting records
namespace :guid do

    task :update_nil => :environment do
    desc "generate guid to records with nil guid"

      #Since Rails doesn't load classes unless it needs them, you must read the models from the folder. Here is the code
      Dir[Rails.root.to_s + '/app/models/**/*.rb'].each do |file| 
        begin
          require file
        rescue
        end
      end


     models = ActiveRecord::Base.subclasses.collect { |type| type.name }.sort
     models.each do |model_name|
        model = eval model_name
        p model.to_s

        if model.first and model.first.has_guid?

          model.all.each do |model_object|
            p "  id:#{model_object.id} "
            if model_object.guid.blank?
              p "     nil guid, generating" 
              model_object.generate_random_guid
              model_object.save!
              p "     new guid is #{model_object.guid}" 
            else
              p "     already has guid" 
            end
          end
          
        else
          p "  no guid column or no records" 
        end
     end
    end
end
