# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel I18n.t("admin.dashboard.system_info") do
          dl do
            Rails::Info.to_s.split("\n")[1..-1].each do |line|
              line = line.split('   ')
              dt line.first
              dd line.last
            end
          end

          hr

          pre Config.info

          # hr

          # dl do
          #   ENV.each do |key, value|
          #     dt key
          #     if key =~ /key/ || key =~ /secret/ || key =~ /pepper$/ ||
          #        key =~ /KEY/ || key =~ /SECRET/ || key =~ /PEPPER$/ ||
          #        key =~ /DATABASE/ || key =~ /SQL/
          #       dd code(value[0..7] + value.gsub(/..?.?/, '*'))
          #     else
          #       value = value[0..50] + '...' if value.length > 50
          #       dd code(value)
          #     end
          #   end
          # end
        end
      end

      column do
        panel link_to(
          I18n.t("admin.users.recent_sign_in_users"),
          admin_users_path(
            order: 'last_sign_in_at_desc'
          )
        ) do
          table_for User.where.not(last_sign_in_at: nil).reorder(last_sign_in_at: :desc).limit(10) do
            column :username { |user| link_to(user.username, admin_user_path(user)) }
            column :last_sign_in_at { |user| distance_of_time_in_words_to_now(user.last_sign_in_at) }
            column :sign_in_count do |user|
              per_day = format '%.3f', (user.sign_in_count.to_f / ((Time.current - user.created_at) / 1.day) + 0.5)
              "#{user.sign_in_count} (#{per_day}/day)"
            end
            column :current_sign_in_ip do |user|
              status_tag_class = user.current_sign_in_ip == user.last_sign_in_ip ? 'yes' : nil
              status_tag(user.current_sign_in_ip, class: status_tag_class)
            end
          end
        end

        panel link_to(
          I18n.t("admin.users.recent_registered_users"),
          admin_users_path(
            order: 'created_at_desc'
          )
        ) do
          table_for User.reorder(created_at: :desc).limit(10) do
            column :username { |user| link_to(user.username, admin_user_path(user)) }
            column :name { |user| link_to(user.name, admin_user_path(user)) }
            column :created_at
            column :current_sign_in_ip { |user| status_tag(user.current_sign_in_ip) }
          end
        end
      end
    end
  end
end
