# frozen_string_literal: true
class Version < PaperTrail::Version
  belongs_to :operator, polymorphic: true

  def whodunnit
    operator
  end

  def whodunnit=(whodunnit)
    self.operator = whodunnit if whodunnit.present?
  end
end
