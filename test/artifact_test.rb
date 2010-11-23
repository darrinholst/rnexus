require 'test_helper'

class ArtifactTest < Test::Unit::TestCase
  def setup
    @hash = {
      'groupId' => 'group', 
      'artifactId' => 'name', 
      'version' => 'version', 
      'packaging' => 'war', 
      'resourceURI' => 'uri',
      'repoId' => 'repo',
      'classifier' => 'classifier'
    }
  end

  def test_construction_from_a_hash
    artifact = Nexus::Artifact.new @hash

    assert_equal('group', artifact.group)
    assert_equal('name', artifact.name)
    assert_equal('version', artifact.version)
    assert_equal('war', artifact.type)
    assert_equal('uri', artifact.uri)
    assert_equal('repo', artifact.repo)
    assert_equal('classifier', artifact.classifier)
  end  

  def test_serialization_to_a_hash
    artifact = Nexus::Artifact.new @hash
    assert_equal @hash, artifact.to_hash
  end

  def test_serialization_to_a_hash_roundtrips
    artifact = Nexus::Artifact.new @hash
    assert_equal artifact, Nexus::Artifact.new(artifact.to_hash)
  end

  def test_artifact_equality
    assert(Nexus::Artifact.new(@hash) == Nexus::Artifact.new(@hash))
  end
end
