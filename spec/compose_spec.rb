require 'json'
require 'compose'

RSpec.describe Compose::Renderer, "#render" do
  subject(:renderer) do
    Compose::Renderer.new
  end

  let(:template) do
    File.join(assets_dir, 'template.erb')
  end

  let(:manifest) do
    File.join(assets_dir, 'manifest.yml')
  end

  let(:expected_rendered_template) do
    File.join(assets_dir, 'rendered_template')
  end

  let(:assets_dir) do
    File.expand_path('assets', File.dirname(__FILE__))
  end

  it "renders a bosh job .erb template given a bosh deployment manifest" do
    rendered_template = renderer.render template, manifest
    expect(rendered_template).to(eq(File.read(expected_rendered_template)))
  end
end
