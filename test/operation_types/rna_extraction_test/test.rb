# frozen_string_literal: true

class ProtocolTest < ProtocolTestBase
  def setup
    add_random_operations(3)

    # # Use this if you want to test alternative extraction kits
    # # Kits
    # #   Qiagen RNeasy Mini Kit
    # #   QIAamp DSP Viral RNA Mini Kit
    # #   Test RNA Extraction Kit
    # #   MagMAX Viral/Pathogen II Nucleic Acid Isolation Kit

    # s1 = Sample.find_by_name('Patient Sample 111')
    # s2 = Sample.find_by_name('Patient Sample 222')
    # s3 = Sample.find_by_name('Patient Sample 333')

    # [s1, s2, s3].each do |sample|
    #   add_operation
    #     .with_input('Specimen', sample)
    #     .with_property(
    #       'Options',
    #       '{ "rna_extraction_kit": "Qiagen RNeasy Mini Kit", "expert": false }'
    #     )
    #     .with_output('Specimen', sample)
    # end
  end

  def analyze
    log('Hello from Nemo')
    assert_equal(@backtrace.last[:operation], 'complete')
  end
end
