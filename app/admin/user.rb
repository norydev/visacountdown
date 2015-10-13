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

  permit_params :email, :citizenship, :admin

  index do
    selectable_column
    column :id
    column :email
    column :citizenship
    column :admin
    actions
  end

  form do |f|
    f.inputs "Identity" do
      f.input :email
      f.input :citizenship, collection: COUNTRIES
    end
    f.inputs "Admin" do
      f.input :admin
    end
    f.actions
  end

end
