def resource(name)
  File.read("./spec/resources/#{name}")
end

def curriculum_xml
  resource('curriculum.xml')
end

def curriculum_zip
  resource('curriculum.zip')
end
