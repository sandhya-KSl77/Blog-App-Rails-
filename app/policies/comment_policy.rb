class CommentPolicy < ApplicationPolicy
  def update?
    return true if user.admin? || user.editor?
    user.normal_user? && user.id == record.user_id
  end

  def destroy?
    return true if user.admin? || user.editor?
    user.normal_user? && user.id == record.user_id
  end
end
