module Bibliographer
  class Book < Bibliographer::Base
    info_attr :authors, :section, :title, :additional, :location, :company, :date, :pages

    def format
      parts = [] 
      parts << authors + "." if authors?
      parts << "\"#{section}.\"" if section?
      parts << publication_title(title) + "." if title?
      parts << additional + "." if additional?
      parts << location + ":" if location?
      parts << company + "," if company?
      parts << date + "." if date?
      parts << pages + "." if pages?

      parts.join(" ").chop << "."
    end
  end
end
