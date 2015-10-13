ActiveAdmin.register Destination do

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

  permit_params :user_id, :zone, :latest_entry

  index do
    selectable_column
    column :id
    column :user
    column :zone
    column :latest_entry
    actions
  end

  form do |f|
    f.inputs "Identity" do
      f.input :zone, collection: ZONES
    end
    f.inputs "Attributes" do
      f.input :user_id
      f.input :latest_entry
    end
    f.actions
  end

end
