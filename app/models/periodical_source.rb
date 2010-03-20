class PeriodicalSource < Source
  info_attr :authors, :article, :title, :volume, :date, :pages

  def brief
    s = title.dup
    s << ", #{volume || date}" if volume || date
    return s
  end

  private # --------------------------------------------------------------

  def field_order
    [ :authors, :article, :title, :volume, :date, :pages ]
  end
end
