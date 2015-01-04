require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe DefinitionsController do

  # This should return the minimal set of attributes required to create a valid
  # Definition. As you add validations to Definition, be sure to
  # adjust the attributes here as well.
  def valid_attributes
    { "text" => "MyString" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DefinitionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET edit" do
    it "assigns the requested definition as @definition" do
      definition = FactoryGirl.create(:definition)
      get :edit, {:word_id => definition.word.id, :id => definition.to_param}, valid_session
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
        # Assuming there are no other definitions in the database, this
        # specifies that the Definition created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Definition.any_instance.should_receive(:update).with({ "text" => "MyString" })
        put :update, {:word_id => @word.id, :id => definition.to_param, :definition => { "text" => "MyString" }}, valid_session
      end

      it "assigns the requested definition as @definition" do
        definition = FactoryGirl.create(:definition, word: @word)
        put :update, {:word_id => @word.id, :id => definition.to_param, :definition => valid_attributes}, valid_session
        assigns(:definition).should eq(definition)
      end

      it "redirects to the word" do
        definition = FactoryGirl.create(:definition, word: @word)
        put :update, {:word_id => @word.id, :id => definition.to_param, :definition => valid_attributes}, valid_session
        response.should redirect_to(word_path(@word))
      end
    end

    describe "unauthenticated" do
      it "redirects to the home page" do
        definition = FactoryGirl.create(:definition, word: @word)
        put :update, {:word_id => @word.id, :id => definition.to_param, :definition => valid_attributes}, valid_session
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
        Definition.any_instance.stub(:save).and_return(false)
        put :update, {:word_id => @word.id, :id => definition.to_param, :definition => { "text" => "invalid value" }}, valid_session
        assigns(:definition).should eq(definition)
      end

      it "re-renders the 'edit' template" do
        definition = FactoryGirl.create(:definition, word: @word)
        # Trigger the behavior that occurs when invalid params are submitted
        Definition.any_instance.stub(:save).and_return(false)
        put :update, {:word_id => @word.id, :id => definition.to_param, :definition => { "text" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @word = FactoryGirl.create(:word)
    end

    it "destroys the requested definition" do
      definition = FactoryGirl.create(:definition, word: @word)
      expect {
        delete :destroy, {:word_id => @word.id, :id => definition.to_param}, valid_session
      }.to change(Definition, :count).by(-1)
    end

    it "redirects to the definitions list" do
      definition = FactoryGirl.create(:definition, word: @word)
      delete :destroy, {:word_id => @word.id, :id => definition.to_param}, valid_session
      response.should redirect_to(word_definitions_url(@word))
    end
  end
end
