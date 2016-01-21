module HasArchive
  module Hook
    def has_archive(*args, **kargs)
      include HasArchive
    end
  end
end
