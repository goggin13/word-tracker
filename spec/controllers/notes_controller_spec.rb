require 'rails_helper'

RSpec.describe NotesController, type: :controller do

  let(:valid_attributes) {
    {
      :front => "front",
      :back => "back",
    }
  }

  let(:invalid_attributes) {
    {
      :back => "back",
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      note = Note.create! valid_attributes.merge(:user_id => 1)
      get :index, {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      note = Note.create! valid_attributes.merge(:user_id => 1)
      get :show, params: {:id => note.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "returns a success response" do
      get :new, {}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "returns a success response" do
      note = Note.create! valid_attributes.merge(:user_id => @user.id)
      get :edit, params: {:id => note.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "creates a new Note" do
        expect {
          post :create, params: {:note => valid_attributes}
        }.to change(Note, :count).by(1)

        expect(Note.last.user.id).to eq(@user.id)
      end

      it "redirects to the created note" do
        post :create, params: {:note => valid_attributes}
        expect(response).to redirect_to(Note.last)
      end
    end

    context "with invalid params" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {:note => invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
        @note = Note.create! valid_attributes.merge(:user => @user)
      end

      let(:new_attributes) {
        {
          :front => "new_front",
          :back => "new_back",
        }
      }

      it "updates the requested note" do
        put :update, params: {:id => @note.to_param, :note => new_attributes}
        @note.reload
        expect(@note.front).to eq("new_front")
        expect(@note.back).to eq("new_back")
      end

      it "redirects to the note" do
        @note = Note.create! valid_attributes.merge(:user_id => @user.id)
        put :update, params: {:id => @note.to_param, :note => valid_attributes}
        expect(response).to redirect_to(@note)
      end
    end

    context "with invalid params" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "returns a success response (i.e. to display the 'edit' template)" do
        note = Note.create! valid_attributes.merge(:user_id => @user.id)
        put :update, params: {:id => note.to_param, :note => invalid_attributes}
        expect(response.code).to eq("302")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "destroys the requested note" do
      note = Note.create! valid_attributes.merge(:user_id => @user.id)
      expect {
        delete :destroy, params: {:id => note.to_param}
      }.to change(Note, :count).by(-1)
    end

    it "redirects to the notes list" do
      note = Note.create! valid_attributes.merge(:user_id => @user.id)
      delete :destroy, params: {:id => note.to_param}
      expect(response).to redirect_to(notes_url)
    end
  end
end
