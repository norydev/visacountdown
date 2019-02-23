ActiveAdmin.register User do
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
