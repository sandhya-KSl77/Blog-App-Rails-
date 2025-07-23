class ArticlePolicy < ApplicationPolicy
  def update?
    return true if user.admin?
    return true if user.editor?
    user.normal_user? && user.id == record.user_id
  end

  def destroy?
    return true if user.admin?
    return true if user.editor? && user.id == record.user_id
    user.normal_user? && user.id == record.user_id
  end
end
