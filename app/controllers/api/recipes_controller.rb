class Api::RecipesController < Api::BaseController
  def index
    respond_with :api, recipes
  end

  def show
    respond_with :api, recipe
  end

  def create
    respond_with :api, recipes.create(recipe_params)
  end

  def destroy
    respond_with :api, recipes.destroy
  end

  private

  def recipes
    @recipes ||= Recipe.all
  end

  def recipe
    @recipes ||= Recipes.find(params[:id])
  end

  def recipes_params
    params.permit(:title, :content)
  end
end