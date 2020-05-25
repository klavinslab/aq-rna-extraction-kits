# frozen_string_literal: true

class ProtocolTest < ProtocolTestBase
  def setup
    add_random_operations(1)

    # Use this if you want to test alternative extraction kits
    # add_operation
    #   .with_property(
    #     'Options',
    #     '{ "rna_extraction_kit": "QIAamp DSP Viral RNA Mini Kit" }'
    #   )
  end

  def analyze
    log('Hello from Nemo')
    assert_equal(@backtrace.last[:operation], 'complete')
  end
end
