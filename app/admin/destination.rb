ActiveAdmin.register Destination do
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
