require 'test_helper'

class RepositoryTest < Test::Unit::TestCase
  JSON = <<-eos
    {
       "data":[
          {
             "resourceURI":"uri1",
             "groupId":"group1",
             "artifactId":"artifact1",
             "version":"version1",
             "packaging":"packaging1"
          },
          {
            "resourceURI":"uri2",
            "groupId":"group2",
            "artifactId":"artifact2",
            "version":"version2",
            "packaging":"packaging2"
          }
       ]
    }
  eos

  def setup
    @repository = Nexus::Repository.new("http://localhost/nexus", "user", "pass")
  end

  def test_find_artifacts_using_all_options
    expected_url = "http://localhost/nexus/service/local/data_index/repo_groups/public?a=artifact&g=group&p=war"
    FakeWeb.register_uri(:get, expected_url, :body => JSON)
    assert_artifacts @repository.find_artifacts(:group => 'group', :name => 'artifact', :type => 'war')
  end

  def test_find_artifacts_using_artifact_id_only
    expected_url = "http://localhost/nexus/service/local/data_index/repo_groups/public?a=artifact"
    FakeWeb.register_uri(:get, expected_url, :body => JSON)
    assert_artifacts @repository.find_artifacts(:name => 'artifact')
  end

  def test_find_artifacts_when_arguments_is_not_a_hash
    exception = assert_raise RuntimeError do
      @repository.find_artifacts(nil)
    end

    assert_equal("arguments must be a hash", exception.message)
  end

  def test_find_artifacts_when_invalid_arguments_passed
    exception = assert_raise RuntimeError do
      @repository.find_artifacts(:a => 'foo', :b => 'bar')
    end

    assert_equal("invalid argument passed, valid arguments are (group, name, type)", exception.message)
  end

  def test_find_artifacts_when_empty_arguments_passed
    exception = assert_raise RuntimeError do
      @repository.find_artifacts({})
    end

    assert_equal("must pass at least one argument (group, name, type)", exception.message)
  end

  def test_delete
    expected_url = "http://user:pass@localhost/nexus/service/local/repositories/repo/content/org/group/artifact/version/"
    artifact = Nexus::Artifact.new('groupId' => 'org.group', 'artifactId' => 'artifact', 'version' => 'version', 'repoId' => 'repo')
    FakeWeb.register_uri(:delete, expected_url, :status => 200)
    assert_equal(200, @repository.delete(artifact))
  end

  def test_download
    artifact = Nexus::Artifact.new('resourceURI' => 'http://nexus/artifact')
    FakeWeb.register_uri(:get, "http://nexus/artifact", :body => 'file content')
    file = @repository.download(artifact)
    assert_equal('file content', file)
  end

  def assert_artifacts(artifacts)
    assert_equal(2, artifacts.size)
    assert_artifact(artifacts[0], 'group1', 'artifact1', 'version1', 'packaging1', 'uri1')
    assert_artifact(artifacts[1], 'group2', 'artifact2', 'version2', 'packaging2', 'uri2')
  end

  def assert_artifact(artifact, group, name, version, type, uri)
    assert_equal(group, artifact.group)
    assert_equal(name, artifact.name)
    assert_equal(version, artifact.version)
    assert_equal(type, artifact.type)
    assert_equal(uri, artifact.uri)
  end
end
