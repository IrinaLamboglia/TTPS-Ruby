class ApplicationRecord < ActiveRecord::Base
  # Esta clase es la clase base de todos los modelos de la aplicación.

  primary_abstract_class


  def sort_link(collection, field, title)
    direction = (params[:sort] == field.to_s && params[:direction] == "asc") ? "desc" : "asc"
    link_to title, params.permit(:name, :category, :status, :page).merge(sort: field, direction: direction)
  end
end
