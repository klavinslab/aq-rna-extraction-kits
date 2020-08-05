# frozen_string_literal: true

needs 'RNA Extraction Kits/QiagenRNAExtractionHelper'

# Module for QIAamp DSP Viral RNA Mini Kit
#
# @author Devin Strickland <strcklnd@uw.edu>
module QIAampDSPViralRNAMiniKit
  include QiagenRNAExtractionHelper

  NAME = 'QIAamp DSP Viral RNA Mini Kit'

  COLUMN_LONG = 'QIAamp Mini spin column'

  MIN_SAMPLE_VOLUME =     { qty: 140, units: MICROLITERS }.freeze
  DEFAULT_SAMPLE_VOLUME = MIN_SAMPLE_VOLUME
  WASH_VOLUME =           { qty: 500, units: MICROLITERS }.freeze

  CENTRIFUGE_SPEED = { qty: 6000, units: TIMES_G }.freeze
  CENTRIFUGE_TIME = { qty: 1, units: MINUTES }.freeze
  CENTRIFUGE_TIME_AND_SPEED = "#{Units.qty_display(CENTRIFUGE_TIME)} at " \
    "#{Units.qty_display(CENTRIFUGE_SPEED)}"

  def prepare_materials
    show do
      title 'Things to do before starting'
      bullet "Equilibrate samples to room temperature (15-25#{DEGREES_C})"
      bullet 'Equilibrate Buffer AVE to room temperature'
      # TODO: Need some way of indicating this has been done
      bullet 'Check that Buffer AW1 and Buffer AW2 have been prepared ' \
        'according to the instructions'
      # TODO: Need some way of indicating this has been done
      bullet 'Add carrier RNA reconstituted in Buffer AVE to Buffer AVL ' \
        'according to the instructions'
    end
  end

  def notes_on_handling
    qiagen_notes_on_handling
  end

  # @todo will we be working with a different sample volume for each operation?
  # @todo make use_operations do this^
  def lyse_samples_constant_volume(sample_volume: DEFAULT_SAMPLE_VOLUME,
                                   expert: false)
    # TODO: Move this logic up to the calling method
    if sample_volume[:qty] < MIN_SAMPLE_VOLUME[:qty]
      msg = "Sample volume must be > #{qty_display(MIN_SAMPLE_VOLUME)}"
      raise ProtocolError, msg
    end
    buffer_volume = lysis_buffer_volume(sample_volume: sample_volume)
    ethanol_volume = ethanol_volume(sample_volume: sample_volume)

    show do
      title 'Lyse Samples'

      # TODO: Add Pipettor module
      note "Get one #{LYSIS_TUBE_LONG} for each sample, and copy the IDs " \
        "from the samples to the #{LYSIS_TUBE_SHORT}s."
      note "Pipet #{qty_display(buffer_volume)} of prepared Buffer AVL " \
        "(containing carrier RNA) into each #{LYSIS_TUBE_SHORT}."
      # If the sample volume is larger than 140 ul, increase the amount of
      # Buffer AVL-carrier RNA proportionally (e.g., a 280 ul sample will
      # require 1120 ul Buffer AVL-carrier RNA) and use a larger tube.
      note "Transfer #{qty_display(sample_volume)} of each sample to the " \
        "corresponding #{LYSIS_TUBE_SHORT}."
      # TODO: Should this be kept in?
      note "Mix by pulse-vortexing for 15 #{SECONDS}."
      warning 'To ensure efficient lysis, it is essential that the sample ' \
        'is mixed thoroughly with Buffer AVL to yield a homogeneous solution'
      # Frozen samples that have only been thawed once can also be used.
      # TODO: Should this be kept in?
      note "Incubate at room temperature (15-25#{DEGREES_C}) for 10 #{MINUTES}"
    end

    show do
      title 'Add Ethanol'

      note "Briefly centrifuge the #{LYSIS_TUBE_LONG}s to remove drops from " \
        'the inside of the lids.'
      # TODO: provision ethanol at beginning and use shorter name
      note "Add #{qty_display(ethanol_volume)} ethanol (96-100%) to each " \
        'sample, and mix by pulse-vortexing for >15 seconds. ' \
        'After mixing, briefly centrifuge the tubes to remove drops from ' \
        'inside the lids.'
      # Only ethanol should be used since other alcohols may result in
      # reduced RNA yield and purity. Do not use denatured alcohol, which
      # contains other substances such as methanol or methylethylketone.
      # If the sample volume is greater than 140 ul, increase the amount of
      # ethanol proportionally (e.g., a 280 ul sample will require
      # 1120 ul of ethanol). In order to ensure efficient binding, it is
      # essential that the sample is mixed thoroughly with the ethanol
      # to yield a homogeneous solution.
    end
  end

  def lyse_samples_variable_volume(operations:, expert: false)
    msg = 'Method lyse_samples_variable_volume is not supported for ' \
      'QIAamp DSP Viral RNA Mini Kit'
    raise ProtocolError, msg
  end

  def bind_rna(operations: [], sample_volume: DEFAULT_SAMPLE_VOLUME,
               expert: false)
    loading_volume, n_loads = loading_volume(sample_volume: sample_volume)

    show do
      title 'Add Samples to Columns'

      note "Get one #{COLUMN_LONG} for each sample, and copy the IDs " \
        "from the #{LYSIS_TUBE_LONG}s to the #{COLUMN_SHORT}s."
      note "Carefully apply #{qty_display(loading_volume)} of each sample " \
        " solution to the corresponding #{COLUMN_SHORT} " \
        "(in #{WASH_TUBE_LONG}s) without wetting the rim."
      note "Close the lids, and centrifuge for #{CENTRIFUGE_TIME_AND_SPEED}." \
        "Place the #{COLUMN_SHORT}s into clean" \
        "#{WASH_TUBE_SHORT}s, and discard the old #{WASH_TUBE_SHORT}s " \
        'containing the filtrate.'
      warning 'Close each spin column in order to avoid cross-contamination ' \
        'during centrifugation.'
      # Centrifugation is performed at approximately 6000 x g in order to limit
      # microcentrifuge noise. Centrifugation at full speed will not affect the
      # yield or purity of the viral RNA. If the solution has not completely
      # passed through the membrane, centrifuge again at a higher speed
      # until all of the solution has passed through.
      separator

      note "Carefully open the #{COLUMN_SHORT}s, and repeat the " \
        "loading #{n_loads - 1} more times until all of the lysate has " \
        "been loaded onto the #{COLUMN_SHORT}s."
    end
  end

  def wash_rna(operations: [], expert: false)
    show do
      title 'Wash with Buffer AW1'

      note "Carefully open the #{COLUMN_LONG}, and add " \
        "#{qty_display(WASH_VOLUME)} Buffer AW1."
        note 'Close the lids gently, and centrifuge for ' \
          "#{CENTRIFUGE_TIME_AND_SPEED}."
      note "Place each #{COLUMN_SHORT} into a clean #{WASH_TUBE_LONG}, " \
        "and discard the #{WASH_TUBE_SHORT}s containing the filtrate."
      # It is not necessary to increase the volume of Buffer AW1 even if the
      # original sample volume was larger than 140 ul.
    end

    show do
      title 'Wash with Buffer AW2'

      note "Carefully open the #{COLUMN_LONG}s, and add " \
        "#{qty_display(WASH_VOLUME)} Buffer AW2."
      # This centrifuge speed is meant to be different
      note 'Close the cap and centrifuge at full speed ' \
        "(approximately 20,000 #{TIMES_G}) for 3 #{MINUTES}."
      separator

      note "Place each #{COLUMN_SHORT} into a new #{WASH_TUBE_LONG}, " \
        "and discard the #{WASH_TUBE_SHORT}s containing the filtrate."
      # This centrifuge speed is meant to be different
      note "Centrifuge at full speed for 1 #{MINUTES}."
    end
  end

  def elute_rna(operations: [], expert: false)
    show do
      title 'Elute RNA'

      note "Place each #{COLUMN_LONG} into a clean #{ELUTION_TUBE_LONG}."
      note "Discard the #{WASH_TUBE_SHORT}s containing the filtrate."
      note "Carefully open the #{COLUMN_SHORT}s and add " \
        "60 #{MICROLITERS} of Buffer AVE equilibrated to room temperature."
      note "Close the cap, and incubate at room temperature for >1 #{MINUTES}."
      note "Centrifuge for #{CENTRIFUGE_TIME_AND_SPEED}."
    end
  end

  private

  def lysis_buffer_volume(sample_volume:)
    unless sample_volume[:units] == MICROLITERS
      raise ProtocolError, "Parameter :sample_volume must be in #{MICROLITERS}"
    end

    qty = sample_volume[:qty] * 560 / 140
    { qty: qty, units: MICROLITERS }
  end

  def ethanol_volume(sample_volume:)
    qty = lysis_buffer_volume(sample_volume: sample_volume)[:qty]
    { qty: qty, units: MICROLITERS }
  end

  # TODO: Is this right?
  def loading_volume(sample_volume:)
    qty = 630
    n_loads = 2
    [{ qty: qty, units: MICROLITERS }, n_loads]
  end
end
