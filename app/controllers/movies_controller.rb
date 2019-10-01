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

    #@all_ratings = ['G', 'PG', 'PG-13', 'R']
    @all_ratings = Movie.order(params[:rating]).select(:rating).map(&:rating).uniq
    @checks = checked_boxes
    @checks.each do |rating|
      params[:rating] = true
    end

    if params[:sort]
      @movies = Movie.order(params[:sort])
    elsif params[:rating]
      @movies = @all_rating
    else
      @movies = Movie.all
    end


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

  def checked_boxes
    if params[:rating]
      params[:rating].keys
    else
      @all_ratings
    end
  end

end
