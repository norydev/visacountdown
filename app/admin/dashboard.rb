ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # column do
    #   panel "Info" do
    #     para "Welcome to ActiveAdmin."
    #   end
    # end

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

      # column do
      #   panel "Recent Periods" do
      #     ul do
      #       Period.last(10).reverse.map do |period|
      #         li link_to("by " + User.find(period.user).email, admin_period_path(period))
      #       end
      #     end
      #   end
      # end
    end
  end # content
end
