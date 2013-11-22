require 'spec_helper'

describe ProjectsController do

  before(:each) do
    @projects = [create(:project), create(:project)]
  end

  describe "when not logged in" do
    describe "GET 'index'" do
      it "should fail" do
        get :index
        response.should_not be_success
      end

      it "should redirect to login" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  describe "for a logged in user" do
    login_user

    let(:valid_attributes) { attributes_for(:project) }

    describe "who does not have projects" do
      it "index should not get any projects" do
        get :index, {}
        assigns(:projects).should be_empty
      end
    end

    describe "who does have projects" do
      before(:each) do
        @project1 = create(:project, user: @user)
        @project2 = create(:project, user: @user)
      end

      describe "GET index" do
        it "should get the users projects" do
          get :index, {}
          assigns(:projects).should include(@project1)     
          assigns(:projects).should include(@project2)     
        end
        it "should not get other projects" do
          get :index, {}
          @projects.each do |project|
            assigns(:projects).should_not include(project)     
          end
        end
      end

      describe "GET show" do
        it "gets a user project" do
          get :show, {id: @project1.to_param}
          assigns(:project).should eq(@project1)          
        end

        it "should redirect to root when getting a strangers project" do
          get :show, {id: @projects.first.to_param}
          response.should redirect_to(root_path)
        end
      end
 
      describe "GET new" do
        it "assigns a new project as @project" do
          get :new, {}
          assigns(:project).should be_a_new(Project)
        end

        it "should build a new project owned by the user" do
          get :new, {}
          assigns(:project).user.should eq(@user)
        end
      end

      describe "GET edit" do
        it "assigns the requested project as @project" do
          get :edit, {id: @project1.to_param}
          assigns(:project).should eq(@project1)          
        end

        it "should redirect to root when editing a strangers project" do
          get :edit, {id: @projects.first.to_param}
          response.should redirect_to(root_path)
        end
      end

      describe "POST create" do
        describe "with valid params" do
          it "creates a new Project" do
            expect {
              post :create, {:project => attributes_for(:project)}
            }.to change(Project, :count).by(1)
          end

          it "assigns a newly created project as @project" do
            post :create, {:project => attributes_for(:project)}
            assigns(:project).should be_a(Project)
            assigns(:project).should be_persisted
          end

          it "redirects to the created project" do
            post :create, {:project => attributes_for(:project)}
            response.should redirect_to(Project.last)
          end
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved project as @project" do
            # Trigger the behavior that occurs when invalid params are submitted
            Project.any_instance.stub(:save).and_return(false)
            post :create, {:project => { "title" => "invalid value" }}
            assigns(:project).should be_a_new(Project)
          end
        end
      end
 
      describe "PUT update" do
        describe "with valid params" do
          it "updates the requested project" do
            Project.any_instance.should_receive(:update).with({ "title" => "Zap Project" })
            put :update, {:id => @project1.to_param, :project => { "title" => "Zap Project" }}
          end

          it "assigns the requested project as @project" do
            put :update, {:id => @project1.to_param, :project => attributes_for(:project)}
            assigns(:project).should eq(@project1)
          end

          it "redirects to the project" do
            put :update, {:id => @project1.to_param, :project => attributes_for(:project)}
            response.should redirect_to(@project1)
          end
        end

        describe "with invalid params" do
          it "assigns the project as @project" do
            Project.any_instance.stub(:save).and_return(false)
            put :update, {:id => @project1.to_param, :project => { "title" => "" }}
            assigns(:project).should eq(@project1)
          end
        end
      end

      describe "DELETE destroy" do
        it "destroys the requested project" do
          expect {
            delete :destroy, {:id => @project1.to_param}
          }.to change(Project, :count).by(-1)
        end

        it "redirects to the projects list" do
          delete :destroy, {:id => @project1.to_param}
          response.should redirect_to(projects_url)
        end
      end
    end
  end
end
