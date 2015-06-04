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

  permit_params :user_id, :first_day, :last_day

  index do
    selectable_column
    column :id
    column :user_id
    column :zone
    column :first_day
    column :last_day
    # column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs "Identity" do
      # f.input :name
      f.input :user_id
    end
    f.inputs "Attributes" do
      f.input :zone
      f.input :first_day
      f.input :last_day
    end
    f.actions
  end

end
