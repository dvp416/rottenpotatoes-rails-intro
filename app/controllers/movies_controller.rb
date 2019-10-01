class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.pluck(:rating).uniq

   if params[:ratings]
     session[:ratings] = params[:ratings]
   end
   session[:ratings] = session[:ratings] || Hash[ @all_ratings.map {|ratings| [ratings, 1]} ]
   @ratings = session[:ratings]

   if params[:sort]
     session[:sort] = params[:sort]
   end
   session[:sort] = session[:sort] || nil
   @category = session[:sort]

   #@movies = Movie.where("rating in (?)", @ratings.keys).find(:all, :order => @category)
   if @category and @ratings
     @movies = Movie.order(:order => @category).where(:rating => @ratings.keys)
   else
     @movies = Movie.all
   end


    #if params[:sort]
    #  @movies = Movie.order(params[:sort])
    #elsif params[:ratings]
    #  @movies = Movie.where(:rating => params[:ratings].keys)
    #else
    #  @movies = Movie.all
    #end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
