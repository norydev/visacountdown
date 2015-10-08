ActiveAdmin.register Period do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  permit_params :destination_id, :first_day, :last_day, :zone, :user_id

  index do
    selectable_column
    column :id
    column :user
    column :zone
    column :first_day
    column :last_day
    actions
  end

  form do |f|
    f.inputs "Identity" do
      f.input :destination_id
    end
    f.inputs "Attributes" do
      f.input :zone, collection: ZONES
      f.input :first_day
      f.input :last_day
    end
    f.actions
  end

end
