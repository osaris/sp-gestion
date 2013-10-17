# this should stay in /config/initializers/ folder because it extends already defined class
class String

  def filenamize
    Iconv.iconv("ASCII//IGNORE//TRANSLIT", "UTF-8", self).join.sanitize
  rescue
    self.sanitize
  end

  def sanitize
    self.gsub(/[^a-z._0-9 -]/i, "").tr(".", "_").gsub(/(\s+)/,"_").squeeze("_").downcase
  end
end
