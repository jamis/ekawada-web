class ReferenceSource < Source
  info_attr :authors, :article, :title, :date, :additional

  private # --------------------------------------------------------------

  def field_order
    [ :authors, :article, :title, :date, :additional ]
  end
end
