class OnlineSource < Source
  info_attr :authors, :article, :site, :editor, :publication_info, :access_date, :url

  private # --------------------------------------------------------------

  def field_order
    [ :authors, :article, :site, :editor, :publication_info, :access_date, :url ]
  end
end
