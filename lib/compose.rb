require 'yaml'
require 'json'
require 'bosh/template/renderer'

module Compose
  class Renderer
    def render(template_file, deployment_manifest_file)
      manifest = File.read(deployment_manifest_file)

      manifest_json = JSON.generate(YAML.load(manifest))

      renderer = Bosh::Template::Renderer.new(context: manifest_json)
      renderer.render(template_file)
    end
  end
end
