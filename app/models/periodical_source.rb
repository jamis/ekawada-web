class PeriodicalSource < Source
  info_attr :authors, :article, :title, :date, :volume, :pages

  private # --------------------------------------------------------------

  def field_order
    [ :authors, :article, :title, :date, :volume, :pages ]
  end
end
