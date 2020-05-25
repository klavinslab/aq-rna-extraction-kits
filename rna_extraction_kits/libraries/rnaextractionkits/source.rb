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
  # @note if `sample_volume` is provided, then all samples will be run
  #   using that volume of sample
  # @note if `sample_volume` is not provided, but `operations` are, then
  #   the protocol will look for sample_volumes assigned to the `Operations`
  # @note if neither `sample_volume` nor `operations` are provided, then
  #   all samples will be run using `DEFAULT_SAMPLE_VOLUME`
  # @param operations [OperationList] the operations to run
  # @param sample_volume [Hash] the volume as a Hash in the format
  #   `{ qty: 140, units: MICROLITERS }`
  # @return [void]
  def run_rna_extraction_kit(operations: [], sample_volume: nil)
    prepare_materials

    notes_on_handling

    if sample_volume
      lyse_samples_constant_volume(sample_volume: sample_volume)
    elsif operations.present?
      lyse_samples_variable_volume(operations: operations)
    else
      lyse_samples_constant_volume
    end

    bind_rna

    wash_rna

    elute_rna
  end
end
