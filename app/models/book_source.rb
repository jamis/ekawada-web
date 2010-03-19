class BookSource < Source
  info_attr :authors, :title, :location, :company, :date, :additional

  def brief
    "#{title}, #{date}"
  end

  private # --------------------------------------------------------------

  def field_order
    [ :authors, :title, :location, :company, :date, :additional ]
  end
end
