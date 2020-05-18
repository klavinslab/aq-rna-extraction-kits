# RNA Extraction Test

Documentation here. Start with a paragraph, not a heading or title, as in most views, the title will be supplied by the view.


### Parameters

- **Options** 



### Precondition <a href='#' id='precondition'>[hide]</a>
```ruby
def precondition(_op)
  true
end
```

### Protocol Code <a href='#' id='protocol'>[hide]</a>
```ruby
# frozen_string_literal: true

needs 'Standard Libs/PlanParams'
needs 'Standard Libs/Units'
needs 'Standard Libs/Debug'
needs 'RNAExtractionKits/RNAExtractionKits'

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
      sample_volume: { qty: 140, units: MICROLITERS }
    }
  end

  # Default parameters that are applied to individual operations.
  #   Can be overridden by:
  #   * Adding a JSON-formatted list of key, value pairs to an `Operation`
  #     input of type JSON and named `Options`.
  #
  def default_operation_params
    {}
  end

  ########## MAIN ##########

  def main
    setup_test_options(operations: operations) if debug

    @job_params = update_job_params(
      operations: operations,
      default_job_params: default_job_params
    )
    return {} if operations.errored.any?

    operations.retrieve.make

    set_kit(name: @job_params[:rna_extraction_kit])

    run_kit_protocol(sample_volume: @job_params[:sample_volume])

    operations.store

    {}
  end
end

```
