require 'test_helper'

class ArtifactTest < Test::Unit::TestCase
  def test_construction_from_a_hash
    artifact = Nexus::Artifact.new(
      'groupId' => 'group', 
      'artifactId' => 'name', 
      'version' => 'version', 
      'packaging' => 'war', 
      'resourceURI' => 'uri',
      'repoId' => 'repo')
      
    assert_equal('group', artifact.group)
    assert_equal('name', artifact.name)
    assert_equal('version', artifact.version)
    assert_equal('war', artifact.type)
    assert_equal('uri', artifact.uri)
    assert_equal('repo', artifact.repo)
  end
end
