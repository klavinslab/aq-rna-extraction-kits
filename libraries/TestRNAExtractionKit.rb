# frozen_string_literal: true

needs 'Standard Libs/Units'

# Minimal RNA Extraction Kit Module for testing
#
# @author Devin Strickland <strcklnd@uw.edu>
module TestRNAExtractionKit
  include Units

  NAME = 'Test RNA Extraction Kit'

  def prepare_materials
    show do
      title 'Things to do before starting'
    end
  end

  def notes_on_handling
    show do
      title 'Handling Materials'
    end
  end

  def lyse_samples(sample_volume:)
    show do
      title 'Lyse Samples'

      note "Sample volume: #{qty_display(sample_volume)}"
    end
  end

  def bind_to_columns
    show do
      title 'Add Samples to Columns'
    end
  end

  def wash_columns
    show do
      title 'Wash with Buffer'
    end
  end

  def elute_rna
    show do
      title 'Elute RNA'
    end
  end

end