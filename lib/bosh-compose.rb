require 'yaml'
require 'json'
require 'bosh/template/renderer'

module Bosh
  module Compose
    class Renderer
      def render(template_file, deployment_manifest_file)
        spec = look_for_spec_relative_to(template_file)

        manifest_yaml = File.read(deployment_manifest_file)
        manifest = YAML.load(manifest_yaml)
        manifest = set_defaults_from_spec(manifest, spec) if spec != nil

        manifest_json = JSON.generate(manifest)

        renderer = Bosh::Template::Renderer.new(context: manifest_json)
        renderer.render(template_file)
      end

      # Attempts to find a relevant spec file based on template file location
      def look_for_spec_relative_to(template_file)
        job_root = File.expand_path('..', File.dirname(template_file))
        spec_path = File.join(job_root, 'spec')
        if !File.exists? spec_path
          STDERR.puts "no spec file found relative to template file"
          return
        end

        STDERR.puts "found spec file at #{spec_path}, importing."
        spec = File.read(spec_path)
        return YAML.load(spec)
      end

      def set_defaults_from_spec(manifest, spec)
        spec["properties"].map do |key, value|
          if !manifest["properties"].key? key
            add_nested_property(manifest["properties"], key, value["default"])
          end
        end
        return manifest
      end

      # car.make
      # set_value("car.make")
      #   map[car] = [make]
      #
      # set_value("car.model")
      # map[car] = [make, model]
      #
      # set_value("car.features.power_windows")
      #   map[car] = set_value("features.power_windows")
      #   map[car] = map[features] = [power_windows]
      def add_nested_property(map, key, value)
        if !key.include? '.'
          if map[key].nil?
            map[key] = value
          end

          return
        end

        keys = key.split '.'
        if map[keys.first].nil?
          map[keys.first] = {}
        end

        add_nested_property map[keys.first], keys.drop(1).join('.'), value
      end
    end
  end
end
