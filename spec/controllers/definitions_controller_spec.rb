require 'spec_helper'

describe DefinitionsController, :type => :controller do

  def valid_attributes
    { "text" => "MyString" }
  end

  let(:valid_session) { {} }

  describe "GET edit" do
    it "assigns the requested definition as @definition" do
      definition = FactoryGirl.create(:definition)
      get :edit, params: {:word_id => definition.word.id, :id => definition.to_param}
      assigns(:definition).should eq(definition)
    end
  end

  describe "PUT update" do
    before do
      @word = FactoryGirl.create(:word)
    end

    describe "with valid params" do
      before do
        sign_in FactoryGirl.create(:user)
      end

      it "updates the requested definition" do
        definition = FactoryGirl.create(:definition, word: @word)

        put :update, params: {
          :word_id => @word.id,
          :id => definition.to_param,
          :definition => { "text" => "MyString" }
        }
        definition.reload

        definition.text.should == "MyString"
      end

      it "assigns the requested definition as @definition" do
        definition = FactoryGirl.create(:definition, word: @word)
        put :update, params: {:word_id => @word.id, :id => definition.to_param, :definition => valid_attributes}
        assigns(:definition).should eq(definition)
      end

      it "redirects to the word" do
        definition = FactoryGirl.create(:definition, word: @word)
        put :update, params: {:word_id => @word.id, :id => definition.to_param, :definition => valid_attributes}
        response.should redirect_to(word_path(@word))
      end
    end

    describe "unauthenticated" do
      it "redirects to the home page" do
        definition = FactoryGirl.create(:definition, word: @word)
        put :update, params: {:word_id => @word.id, :id => definition.to_param, :definition => valid_attributes}
        response.should redirect_to(root_path)
        flash[:warning].should == "You must be logged in."
      end
    end

    describe "with invalid params" do
      before do
        sign_in FactoryGirl.create(:user)
      end

      it "assigns the definition as @definition" do
        definition = FactoryGirl.create(:definition, word: @word)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Definition).to receive(:save).and_return(false)
        put :update, params: {:word_id => @word.id, :id => definition.to_param, :definition => { "text" => "invalid value" }}
        assigns(:definition).should eq(definition)
      end

      it "re-renders the 'edit' template" do
        definition = FactoryGirl.create(:definition, word: @word)
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Definition).to receive(:save).and_return(false)
        put :update, params: {:word_id => @word.id, :id => definition.to_param, :definition => { "text" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @word = FactoryGirl.create(:word)
    end

    describe "authenticated" do
      before do
        sign_in FactoryGirl.create(:user)
      end

      it "destroys the requested definition" do
        definition = FactoryGirl.create(:definition, word: @word)
        expect {
          delete :destroy, params: {:word_id => @word.id, :id => definition.to_param}
        }.to change(Definition, :count).by(-1)
      end

      it "redirects to the word page" do
        definition = FactoryGirl.create(:definition, word: @word)
        delete :destroy, params: {:word_id => @word.id, :id => definition.to_param}
        response.should redirect_to(word_path(@word))
      end
    end

    describe "unauthenticated" do
      it "redirects to the home page" do
        definition = FactoryGirl.create(:definition, word: @word)
        expect do
          delete :destroy, params: {:word_id => @word.id, :id => definition.to_param}
        end.to change(Definition, :count).by(0)

        response.should redirect_to(root_path)
      end
    end
  end
end
