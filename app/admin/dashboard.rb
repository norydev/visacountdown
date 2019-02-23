ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Users" do
          ul do
            User.last(10).reverse.map do |user|
              li link_to(user.email, admin_user_path(user))
            end
          end
        end
      end
    end
  end
end
