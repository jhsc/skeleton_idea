class Api::RecipesController < Api::BaseController
  def index
    respond_with :api, recipess
  end

  def show
    respond_with :api, recipes
  end

  def create
    respond_with :api, recipess.create(recipes_params)
  end

  def destroy
    respond_with :api, recipes.destroy
  end

  private

  def recipess
    @recipess ||= Recipes.all
  end

  def recipes
    @recipes ||= Recipess.find(params[:id])
  end

  def recipes_params
    params.permit(:title, :content)
  end
end