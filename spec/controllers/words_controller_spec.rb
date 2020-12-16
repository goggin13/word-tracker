require 'spec_helper'

describe WordsController, :type => :controller do

  let(:valid_attributes) { { "text" => "MyString", "user_id" => 1 } }

  describe "GET index" do
    it "returns a JSON array with all the existing words for the current user" do
      user = FactoryBot.create(:user)
      FactoryBot.create(
        :definition,
        text: "word1 means word1",
        word: FactoryBot.create(:word, text: "word1", user: user),
      )
      FactoryBot.create(
        :definition,
        text: "word2 means word2",
        word: FactoryBot.create(:word, text: "word2", user: user),
      )

      sign_in user
      get :index, params: {format: "json"}

      response.status.should == 200

      result = JSON.parse(response.body)

      result.should include({ "word1" => ["word1 means word1"] })
      result.should include({ "word2" => ["word2 means word2"] })
    end

    it "defaults to words from goggin13@gmail" do
      user = FactoryBot.create(:user, email: "goggin13@gmail.com")
      word = FactoryBot.create(:word, user: user)
      get :index, {}
      assigns(:words).should eq([word])
      assigns(:user).should eq(user)
    end

    it "only displays words from the current user" do
      user = FactoryBot.create(:user)
      sign_in user

      word = FactoryBot.create(:word, user: user)
      another_users_word = FactoryBot.create(:word)

      get :index, {}
      assigns(:words).should eq([word])
      assigns(:user).should eq(user)
    end

    it "displays the words for a requested user_id" do
      user = FactoryBot.create(:user)
      sign_in user

      word = FactoryBot.create(:word, user: user)
      another_users_word = FactoryBot.create(:word)

      get :index, params: {:user_id => another_users_word.user_id}
      assigns(:words).should eq([another_users_word])
      assigns(:user).should eq(another_users_word.user)
    end

    it "redirects to the sign up page if there is no default user and no signed in user" do
      get :index
      flash[:error].should == "No default user is setup."
      response.should redirect_to new_user_registration_path
    end
  end

  describe "GET show" do
    it "assigns the requested word as @word" do
      word = Word.create! valid_attributes
      get :show, params: {:id => word.to_param}
      assigns(:word).should eq(word)
    end
  end

  describe "GET new" do
    it "assigns a new word as @word" do
      get :new, {}
      assigns(:word).should be_a_new(Word)
    end
  end

  describe "DELETE destroy" do
    describe "authenticated" do
      before do
        sign_in FactoryBot.create(:user)
      end

      it "destroys the requested word" do
        word = Word.create! valid_attributes
        expect {
          delete :destroy, params: {:id => word.to_param}
        }.to change(Word, :count).by(-1)
      end

      it "redirects to the words list" do
        word = Word.create! valid_attributes
        delete :destroy, params: {:id => word.to_param}
        response.should redirect_to(words_url)
      end
    end

    describe "unauthenticated" do
      it "redirects to the home page" do
        word = Word.create! valid_attributes
        expect do
          delete :destroy, params: {:id => word.to_param}
          response.should redirect_to(root_path)
        end.to change(Definition, :count).by(0)
      end
    end
  end

  describe "POST create" do
    describe "authenticated" do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      it "returns existing definitions if they are available" do
        word = FactoryBot.create(:word, text: "word1", :user => @user)
        FactoryBot.create(:definition, text: "word1 means word1", word: word)
        FactoryBot.create(:definition, text: "word1 also means word1", word: word)

        post :create, params: {word: "word1", format: :json}

        response.status.should == 200
        JSON.parse(response.body).should == {
          "word1" => ["word1 means word1", "word1 also means word1"]
        }
      end

      it "looks up the defintion from wordnik" do
        VCR.use_cassette "hysteria_api_response" do
          post :create, params: {:word => "hysteria", format: :json}
          response.status.should == 200
          result = JSON.parse(response.body)

          result.should == {
            "hysteria" => [
              "Behavior exhibiting excessive or uncontrollable emotion, such as fear or panic.",
              "A mental disorder characterized by emotional excitability and sometimes by amnesia or a physical deficit, such as paralysis, or a sensory deficit, without an organic cause."
            ]
          }
        end
      end

      it "returns 422 if the definition cannot be located" do
        VCR.use_cassette "not_found_api_response" do
          post :create, params: {:word => "this-word-wont-be-found", format: :json}
          response.status.should == 422
          result = JSON.parse(response.body)
          result["errors"][0].should == "No definition found for 'this-word-wont-be-found'"
        end
      end
    end

    describe "unauthorized" do
      it "returns 401 for a JSON request" do
        post :create, params: {word: "word1", format: :json}
        response.status.should == 401
      end

      it "redirects to the home page with a warning for a web request" do
        post :create, params: {word: "word1"}

        response.should redirect_to "/"
        flash[:warning].should == "You must be logged in."
      end
    end
  end
end
