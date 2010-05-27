require 'rest_client'
require 'crack'
require 'tempfile'

class Nexus::Repository
  NEXUS_PARAMETERS = {
    :group => :g,
    :name => :a,
    :type => :p
  }

  def initialize(baseuri, username = nil, password = nil)
    @baseuri = baseuri
    @username = username
    @password = password
  end

  def find_artifacts(args)
    url = "#{@baseuri}/service/local/data_index/repo_groups/public?#{build_query_parameters_from(args)}"
    response = RestClient.get(url, :accept => 'application/json')
    Crack::JSON.parse(response.body)['data'].map {|data| Nexus::Artifact.new(data)}
  end

  def download(artifact)
    RestClient.get(artifact.uri)
  end

  def delete(artifact)
    url = "#{@baseuri}/service/local/repositories/#{artifact.repo}/content/#{artifact.group.gsub(/\./, '/')}/#{artifact.name}/#{artifact.version}/"
    RestClient::Resource.new(url, :user => @username, :password => @password).delete.code
  end

  private

  def build_query_parameters_from(args)
    raise "arguments must be a hash" unless args.is_a? Hash

    query_parameters = args.map do |entry|
      "#{nexus_parameter_for(entry.first)}=#{entry.last}"
    end.join("&")

    raise "must pass at least one argument #{nexus_parameters_to_s}" if query_parameters.empty?

    query_parameters
  end

  def nexus_parameter_for(parameter)
    nexus_param = NEXUS_PARAMETERS[parameter]
    raise "invalid argument passed, valid arguments are #{nexus_parameters_to_s}" unless nexus_param
    nexus_param
  end

  def nexus_parameters_to_s
    "(#{NEXUS_PARAMETERS.keys.join(', ')})"
  end
end

