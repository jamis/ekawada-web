module Bibliographer
  class Online < Bibliographer::Base
    info_attr :authors, :article, :site, :editor, :publication_info, :access_date, :url

    def format
      parts = [] 

      parts << authors + "." if authors?
      parts << "\"#{article}.\"" if article?
      parts << publication_title(site) + "." if site?
      parts << "Ed. " + editor + "." if editor?
      parts << publication_info + ":" if publication_info?
      parts << access_date + "," if access_date?
      parts << hyperlink(url) + "." if url?

      parts.join(" ").chop << "."
    end
  end
end
