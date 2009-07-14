class Nexus::Artifact
  attr_accessor :group, :name, :version, :type, :uri
  
  def initialize(parameters)
    self.group = parameters['groupId']
    self.name = parameters['artifactId']
    self.version = parameters['version']
    self.type = parameters['packaging']
    self.uri = parameters['resourceURI']
  end
end