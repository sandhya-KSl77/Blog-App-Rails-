class ArticlePolicy < ApplicationPolicy
  def show?
    true 
  end

  def create?
    user_subscribed?
  end

  def update?
    return true if user.admin?
    return true if user.editor? && owns_article?
    user.normal_user? && user_subscribed? && owns_article?
  end

  def destroy?
    return true if user.admin?
    return true if user.editor? && owns_article?
    user.normal_user? && user_subscribed? && owns_article?
  end

  private

  def user_subscribed?
    user&.subscription&.status == 'active'
  end

  def owns_article?
    user.id == record.user_id
  end
end
