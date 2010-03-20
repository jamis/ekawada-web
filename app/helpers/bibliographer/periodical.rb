module Bibliographer
  class Periodical < Bibliographer::Base
    info_attr :authors, :article, :title, :date, :volume, :pages

    def format
      parts = [] 
      parts << authors + "." if authors?
      parts << "\"#{article}.\"" if article?
      parts << publication_title(title) if title?
      parts << volume if volume?
      parts << date + ":" if date?
      parts << pages + "." if pages?

      parts.join(" ").chop << "."
    end
  end
end
