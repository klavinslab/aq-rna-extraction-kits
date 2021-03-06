# frozen_string_literal: true

needs 'RNA Extraction Kits/QiagenRNAExtractionHelper'

# Module for Qiagen RNeasy Mini Kit
#
# @author Devin Strickland <strcklnd@uw.edu>
# @note The instructions here are based on the BU Center for Regenerative
#   Medicine COVID-19 test (http://www.bu.edu/dbin/stemcells/covid-19.php)
module QiagenRNeasyMiniKit
  include QiagenRNAExtractionHelper

  NAME = 'Qiagen RNeasy Mini Kit'

  COLUMN_LONG = 'RNeasy spin column'

  MIN_SAMPLE_VOLUME = { qty: 300, units: MICROLITERS }.freeze
  DEFAULT_SAMPLE_VOLUME = MIN_SAMPLE_VOLUME

  CENTRIFUGE_SPEED = { qty: 8000, units: TIMES_G }.freeze
  CENTRIFUGE_TIME = { qty: 15, units: SECONDS }.freeze
  CENTRIFUGE_TIME_AND_SPEED = "#{Units.qty_display(CENTRIFUGE_TIME)} at " \
    "#{Units.qty_display(CENTRIFUGE_SPEED)}"

  LYSIS_BUFFER = 'Buffer RLT'

  ELUTION_VOLUME = { qty: 50, units: MICROLITERS }.freeze
  ELUTION_TUBE_LONG = "new 1.5 #{MILLILITERS} collection tube (supplied)"
  ELUTION_TUBE_SHORT = 'collection tube'

  # @todo may need to add something from the Qiagen manual
  def prepare_materials; end

  def notes_on_handling
    qiagen_notes_on_handling
  end

  # @note adapted from `QIAampDSPViralRNAMiniKit`
  # @todo determine how much of the detail to keep or change
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

      note "Get one #{LYSIS_TUBE_LONG} for each sample, and copy the IDs " \
        "from the samples to the #{LYSIS_TUBE_SHORT}s."
      note "Pipet #{qty_display(buffer_volume)} of #{LYSIS_BUFFER} " \
        "into each #{LYSIS_TUBE_SHORT}."
      note "Transfer #{qty_display(sample_volume)} of each sample to the " \
        "corresponding #{LYSIS_TUBE_SHORT}."
      note "Mix by pulse-vortexing each tube for 15 #{SECONDS}."
      # TODO: Should this be kept in?
      warning 'To ensure efficient lysis, it is essential that the sample is ' \
        "mixed thoroughly with #{LYSIS_BUFFER} to yield a homogeneous solution"
      # Frozen samples that have only been thawed once can also be used.
      # TODO: Should this be kept in?
      note "Incubate at room temperature (15-25#{DEGREES_C}) for 10 #{MINUTES}"
    end

    show do
      title 'Add Ethanol'

      note "Briefly centrifuge the #{LYSIS_TUBE_LONG}s to remove drops from " \
        'the inside of the lids.'
      # TODO: provision ethanol at beginning and use shorter name
      note "Add #{qty_display(ethanol_volume)} ethanol (100%) to each " \
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
      'Qiagen RNeasy Mini Kit'
    raise ProtocolError, msg
  end

  # @note adapted from `QIAampDSPViralRNAMiniKit`
  # @todo determine how much of the detail to keep or change
  def bind_rna(operations: [], sample_volume: DEFAULT_SAMPLE_VOLUME,
               expert: false)
    loading_volume, n_loads = loading_volume(sample_volume: sample_volume)

    show do
      title 'Add Samples to Columns'

      note "Get one #{COLUMN_LONG} for each sample, and copy the IDs " \
        "from the #{LYSIS_TUBE_LONG}s to the #{COLUMN_SHORT}s."
      note "Carefully apply #{qty_display(loading_volume)} of each sample " \
        "solution to the corresponding #{COLUMN_SHORT} " \
        "(in #{WASH_TUBE_LONG}s) without wetting the rim."
      note "Close the lids, and centrifuge for #{CENTRIFUGE_TIME_AND_SPEED}."
      note "Place the #{COLUMN_SHORT}s into clean #{WASH_TUBE_SHORT}s, and " \
        "discard the #{WASH_TUBE_SHORT}s containing the filtrate."
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
      title 'Wash with Buffer RW1'

      note "Add 700 #{MICROLITERS} Buffer RW1 to each #{COLUMN_LONG}."
      note 'Close the lids gently, and centrifuge for ' \
        "#{CENTRIFUGE_TIME_AND_SPEED}."
      warning "Carefully remove the #{COLUMN_SHORT}s from the collection " \
        'tubes so that the columns do not contact the flow-through.'
      note 'Empty the collection tubes completely.'
      note 'Reuse the collection tubes in the next step.'
    end

    show do
      title 'Wash twice with Buffer RPE'

      note "Add 500 #{MICROLITERS} Buffer RPE to each #{COLUMN_LONG}."
      note 'Close the lids gently, and centrifuge for ' \
        "#{CENTRIFUGE_TIME_AND_SPEED}."
      note 'Empty the collection tubes.'
      note 'Reuse the collection tubes in the next step.'
      # Note: Buffer RPE is supplied as a concentrate. Ensure that ethanol is
      # added to Buffer RPE before use (see Things to do before starting).
      separator

      note "Add 500 #{MICROLITERS} Buffer RPE to the #{COLUMN_SHORT}."
      # The long centrifugation dries the spin column membrane, ensuring that
      # no ethanol is carried over during RNA elution. Residual ethanol may
      # interfere with downstream reactions.
      note "Close the lids gently, and centrifuge for 2 #{MINUTES} at " \
        "#{qty_display(CENTRIFUGE_SPEED)}."
      warning "Carefully remove the #{COLUMN_SHORT}s from the collection " \
        'tubes so that the columns do not contact the flow-through.'
      note 'Discard the collection tubes.'
      separator

      # TODO: Should we do this step?
      note "Place each #{COLUMN_SHORT} in a new #{WASH_TUBE_LONG}, " \
        "and discard the #{WASH_TUBE_SHORT}s containing the filtrate."
      # This centrifuge speed is meant to be different
      note "Centrifuge at full speed for 1 #{MINUTES}."
    end
  end

  def elute_rna(operations: [], expert: false)
    show do
      title 'Elute RNA'

      note "Get one #{ELUTION_TUBE_LONG} for each #{COLUMN_SHORT}, and copy " \
        "the IDs from the #{COLUMN_SHORT}s to the #{ELUTION_TUBE_SHORT}s."
      note "Place each #{COLUMN_LONG} in a #{ELUTION_TUBE_SHORT}."
      note "Add #{qty_display(ELUTION_VOLUME)} RNAse-free water directly " \
        'to each spin column membrane.'
      note "Close the lids gently, and centrifuge for 1 #{MINUTES} at " \
        "#{qty_display(CENTRIFUGE_SPEED)}."
    end
  end

  private

  # @todo generalize this for all sample lysis buffers
  def lysis_buffer_volume(sample_volume:)
    unless sample_volume[:units] == MICROLITERS
      raise ProtocolError, "Parameter :sample_volume must be in #{MICROLITERS}"
    end

    qty = sample_volume[:qty]
    { qty: qty, units: MICROLITERS }
  end

  def ethanol_volume(sample_volume:)
    qty = sample_volume[:qty] * 2.0
    { qty: qty, units: MICROLITERS }
  end

  def loading_volume(sample_volume:)
    qty = sample_volume[:qty]
    qty += lysis_buffer_volume(sample_volume: sample_volume)[:qty]
    qty += ethanol_volume(sample_volume: sample_volume)[:qty]
    if qty <= 600
      n_loads = 1
    elsif qty <= 1200
      n_loads = 2
    elsif qty <= 1800
      n_loads = 3
    else
      raise ProtocolError, 'Parameter :sample_volume must be <= 1800 ' \
        "#{MICROLITERS}"
    end
    qty /= n_loads.to_f
    [{ qty: qty, units: MICROLITERS }, n_loads]
  end
end
