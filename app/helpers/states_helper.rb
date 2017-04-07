# frozen_string_literal: true
module StatesHelper
  def state_badge(object)
    badges_class = case object.state
                   when 'in_progress'
                     'badge-success'
                   when 'prepare_to_end'
                     'badge-info'
                   else
                     'badge-default'
                   end

    content_tag(:span, class: ['badge', badges_class]) do
      object.human_state
    end
  end
end
