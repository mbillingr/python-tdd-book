module ActsAsCsv
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_csv
      include InstanceMethods
    end
  end

  module InstanceMethods
    def read
      @csv_contents = []
      filename = self.class.to_s.downcase + '.txt'
      file = File.new(filename)
      @headers = file.gets.chomp.split(', ')

      file.each do |row|
        @csv_contents << row.chomp.split(', ')
      end
    end

    def each(&block)
      csv_contents.each {|row| block.call CsvRow.new(headers, row)}
    end

    attr_accessor :headers, :csv_contents
    def initialize
      read
    end
  end
end

class CsvRow
  attr_accessor :headers, :values

  def initialize(headers, values)
    @headers = headers
    @values = values
  end

  def method_missing name, *args
    i = @headers.find_index(name.to_s)
    if i == nil
      nil
    else
      @values[i]
    end
  end
end

class RubyCsv  # no inheritance! You can mix it in
  include ActsAsCsv
  acts_as_csv
end

m = RubyCsv.new

m.each {|row| puts row.inspect}

m.each {|row| puts row.first}
m.each {|row| puts row.last}
m.each {|row| puts row.country}
m.each {|row| puts row.foo}
