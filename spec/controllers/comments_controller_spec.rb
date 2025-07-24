require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user)    { FactoryBot.create(:user) }
  let(:article) { FactoryBot.create(:article, user: user, body: "This is a long enough body to pass validation.") }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    it "creates a new comment" do
      expect {
        post :create, params: {
          article_id: article.id,
          comment: { body: "A valid comment for testing" }
        }
      }.to change(Comment, :count).by(1)

      expect(response).to redirect_to(article)
      expect(flash[:notice]).to eq("Comment posted successfully.")
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { FactoryBot.create(:comment, article: article, user: user) }

    it "deletes the comment" do
      expect {
        delete :destroy, params: {
          article_id: article.id,
          id: comment.id
        }
      }.to change(Comment, :count).by(-1)

      expect(response).to redirect_to(article_path(article))
      expect(flash[:notice]).to eq("Comment deleted.")
    end
  end
end
