class FileReader

  def initialize(file_path)
    @path = file_path
  end

  def read_csv_file
    CSV.read("#{@path}/#{@path}.csv", headers: true, header_converters: :symbol, converters: :all)
  end
end
