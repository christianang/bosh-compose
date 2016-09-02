require 'yaml'
require 'json'
require 'bosh/template/renderer'

module Bosh
  module Compose
    class Renderer
      def render(template_file, deployment_manifest_file)
        spec = look_for_spec template_file
        manifest_yaml = File.read(deployment_manifest_file)
        manifest = YAML.load(manifest_yaml)

        manifest = set_defaults_from_spec(manifest, spec)
        manifest_json = JSON.generate(manifest)

        renderer = Bosh::Template::Renderer.new(context: manifest_json)
        renderer.render(template_file)
      end

      # Attempts to find a relevant spec file based on template file location
      def look_for_spec(template_file)
        job_root = File.expand_path('..', File.dirname(template_file))
        spec_path = File.join(job_root, 'spec')
        spec = File.read(spec_path) if File.exists? spec_path
        return YAML.load(spec)
      end

      def set_defaults_from_spec(manifest, spec)
        spec["properties"].map do |key, value|
          if !manifest["properties"].key? key
            manifest["properties"][key] = value["default"]
          end
        end
        return manifest
      end
    end
  end
end
