class BookSource < Source
  info_attr :authors, :title, :location, :company, :date, :additional

  private # --------------------------------------------------------------

  def field_order
    [ :authors, :title, :location, :company, :date, :additional ]
  end
end
