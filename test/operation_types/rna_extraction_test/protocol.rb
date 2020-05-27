# frozen_string_literal: true

needs 'Standard Libs/PlanParams'
needs 'Standard Libs/Units'
needs 'Standard Libs/Debug'
needs 'RNA Extraction Kits/RNAExtractionKits'

# Test Extract RNA Protocol
#
# @author Devin Strickland <strcklnd@uw.edu>
class Protocol
  include PlanParams
  include Units
  include Debug
  include RNAExtractionKits

  ########## DEFAULT PARAMS ##########

  # Default parameters that are applied equally to all operations.
  #   Can be overridden by:
  #   * Associating a JSON-formatted list of key, value pairs to the `Plan`.
  #   * Adding a JSON-formatted list of key, value pairs to an `Operation`
  #     input of type JSON and named `Options`.
  #
  def default_job_params
    {
      rna_extraction_kit: TestRNAExtractionKit::NAME,
      expert: false
    }
  end

  # Default parameters that are applied to individual operations.
  #   Can be overridden by:
  #   * Adding a JSON-formatted list of key, value pairs to an `Operation`
  #     input of type JSON and named `Options`.
  #
  def default_operation_params
    {
      sample_volume: { qty: 300, units: MICROLITERS }

    }
  end

  ########## MAIN ##########

  def main
    setup_test_options(operations: operations) if debug

    @job_params = update_all_params(
      operations: operations,
      default_job_params: default_job_params,
      default_operation_params: default_operation_params
    )
    return {} if operations.errored.any?

    operations.retrieve.make

    set_kit(name: @job_params[:rna_extraction_kit])

    sample_volumes = operation_sample_volumes(operations)
    if sample_volumes.uniq.length == 1
      run_rna_extraction_kit(
        sample_volume: sample_volumes.first,
        expert: @job_params[:expert]
      )
    else
      run_rna_extraction_kit(
        operations: operations,
        expert: @job_params[:expert]
      )
    end

    operations.store

    {}
  end

  def operation_sample_volumes(operations)
    operations.map { |op| op.temporary[:options][:sample_volume] }
  end
end
