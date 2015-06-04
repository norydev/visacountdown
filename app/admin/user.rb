ActiveAdmin.register User do

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

  permit_params :email, :latest_entry, :citizenship, :destination, :admin

  index do
    selectable_column
    column :id
    column :email
    column :citizenship
    column :destination
    column :latest_entry
    # column :created_at
    column :updated_at
    column :admin
    actions
  end

  form do |f|
    f.inputs "Identity" do
      # f.input :name
      f.input :email
      f.input :citizenship
    end
    f.inputs "Entries" do
      f.input :destination
      f.input :latest_entry
    end
    f.inputs "Admin" do
      f.input :admin
    end
    f.actions
  end

end
