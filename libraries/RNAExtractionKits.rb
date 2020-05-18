# frozen_string_literal: true

needs 'RNAExtractionKits/TestRNAExtractionKit'
needs 'RNAExtractionKits/QIAampDSPViralRNAMiniKit'

# Module for switching among several different RNA extraction kits
#
# @author Devin Strickland <strcklnd@uw.edu>
module RNAExtractionKits
  # Extend the module with the correct methods based on the kit name
  #
  # @param name [String] the name of the kit
  # @return [void]
  def set_kit(name:)
    case name
    when TestRNAExtractionKit::NAME
      extend TestRNAExtractionKit
    when QIAampDSPViralRNAMiniKit::NAME
      extend QIAampDSPViralRNAMiniKit
    else
      raise ProtocolError, "Unrecognized RNA Extraction Kit: #{name}"
    end
  end

  # Run the protocol defined by the kit
  #
  # @param sample_volume [Hash] the volume as a Hash in the format
  #   `{ qty: 140, units: MICROLITERS }`
  # @return [void]
  def run_kit_protocol(sample_volume:)
    prepare_materials

    notes_on_handling

    lyse_samples(sample_volume: sample_volume)

    bind_to_columns

    wash_columns

    elute_rna
  end
end
