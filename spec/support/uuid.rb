RSpec::Matchers.define :generate_a_uuid do |expected|
  match do |instance|
    instance.valid?

    # allow(instance).to receive(:generate_uuid)
    # expect(instance).to validate_presence_of :uuid
    # RSpec::Mocks.proxy_for(instance).reset

    # TODO: add in presence validation...

    expect(instance).to validate_uniqueness_of :uuid

    instance.uuid != nil
  end
end
