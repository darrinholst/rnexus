class Nexus::Artifact
  attr_accessor :group, :name, :version, :type, :uri, :repo, :classifier

  def initialize(parameters)
    @group      = parameters['groupId']
    @name       = parameters['artifactId']
    @version    = parameters['version']
    @type       = parameters['packaging']
    @uri        = parameters['resourceURI']
    @repo       = parameters['repoId']
    @classifier = parameters['classifier']
  end

  def to_hash
    hash = {}
    hash['groupId']     = group
    hash['artifactId']  = name
    hash['version']     = version
    hash['packaging']   = type
    hash['resourceURI'] = uri
    hash['repoId']      = repo
    hash['classifier']  = classifier
    hash
  end

  def == other
    to_hash == other.to_hash
  end
end
