# frozen_string_literal: true

needs 'Standard Libs/Units'

# Module for QIAamp DSP Viral RNA Mini Kit
#
# @author Devin Strickland <strcklnd@uw.edu>
module QIAampDSPViralRNAMiniKit
  include Units

  NAME = 'QIAamp DSP Viral RNA Mini Kit'

  WASH_TUBE = "2 #{MILLILITERS} wash tube (WT)"

  MIN_SAMPLE_VOLUME =     { qty: 140, units: MICROLITERS }.freeze
  DEFAULT_SAMPLE_VOLUME = MIN_SAMPLE_VOLUME
  WASH_VOLUME =           { qty: 500, units: MICROLITERS }.freeze

  def prepare_materials
    show do
      title 'Things to do before starting'
      bullet "Equilibrate samples to room temperature (15–25#{DEGREES_C})"
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
    show do
      title 'Handling of QIAamp Mini spin columns'

      note 'Due to the sensitivity of nucleic acid amplification ' \
        'technologies, the following precautions are necessary when handling ' \
        'QIAamp Mini spin columns to avoid cross contamination between ' \
        'sample preparations:'
      bullet 'Carefully apply the sample or solution to the QIAamp Mini ' \
        'spin column. Pipet the sample into the QIAamp Mini spin column ' \
        'without wetting the rim of the column.'
      bullet 'Always change pipet tips between liquid transfers. ' \
        'We recommend the use of aerosol-barrier pipet tips.'
      bullet 'Avoid touching the QIAamp Mini spin column membrane with ' \
        'the pipet tip.'
      bullet 'After all pulse-vortexing steps, briefly centrifuge the ' \
       'microcentrifuge tubes to remove drops from the inside of the lids.'
      bullet 'Open only one QIAamp Mini spin column at a time, and take care ' \
        'to avoid generating aerosols.'
      bullet 'Wear gloves throughout the entire procedure. In case of ' \
        'contact between gloves and sample, change gloves immediately.'
    end
  end

  # @todo will we be working with a different sample volume for each operation?
  # @todo make use_operations do this^
  def lyse_samples_constant_volume(sample_volume: nil)
    # TODO: Move this logic up to the calling method
    if sample_volume[:qty] < MIN_SAMPLE_VOLUME[:qty]
      msg = "Sample volume must be > #{qty_display(MIN_SAMPLE_VOLUME)}"
      raise ProtocolError, msg
    end
    sample_volume ||= DEFAULT_SAMPLE_VOLUME
    buffer_volume = buffer_avl_volume(sample_volume: sample_volume)
    ethanol_volume = buffer_volume

    show do
      title 'Lyse Samples'

      note "Pipet #{qty_display(buffer_volume)} of prepared Buffer AVL " \
        'containing carrier RNA into a lysis tube (LT).'
      # If the sample volume is larger than 140 μl, increase the amount of
      # Buffer AVL–carrier RNA proportionally (e.g., a 280 μl sample will
      # require 1120 μl Buffer AVL–carrier RNA) and use a larger tube.
      note "Add #{qty_display(sample_volume)} plasma, serum, urine, " \
        'cell-culture supernatant, or cell- free body fluid to the ' \
        'Buffer AVL–carrier RNA in the lysis tube (LT).'
      note "Mix by pulse-vortexing for 15 #{SECONDS}."
      warning 'To ensure efficient lysis, it is essential that the sample ' \
        'is mixed thoroughly with Buffer AVL to yield a homogeneous solution'
      # Frozen samples that have only been thawed once can also be used.
      note "Incubate at room temperature (15–25#{DEGREES_C}) for 10 #{MINUTES}"
    end

    show do
      title 'Add Ethanol'

      note 'Briefly centrifuge the lysis tube (LT) to remove drops from ' \
        'the inside of the lid.'
      note "Add #{qty_display(ethanol_volume)} ethanol (96–100%) to the " \
        'sample, and mix by pulse-vortexing for ≥15 seconds. ' \
        'After mixing, briefly centrifuge the tube to remove drops from ' \
        'inside the lid.'
      # Only ethanol should be used since other alcohols may result in
      # reduced RNA yield and purity. Do not use denatured alcohol, which
      # contains other substances such as methanol or methylethylketone.
      # If the sample volume is greater than 140 μl, increase the amount of
      # ethanol proportionally (e.g., a 280 μl sample will require
      # 1120 μl of ethanol). In order to ensure efficient binding, it is
      # essential that the sample is mixed thoroughly with the ethanol
      # to yield a homogeneous solution.
    end
  end

  def lyse_samples_variable_volume(operations:)
    msg = 'Method lyse_samples_variable_volume is not supported for ' \
      'QIAamp DSP Viral RNA Mini Kit'
    raise ProtocolError, msg
  end

  def bind_rna
    show do
      title 'Add Samples to Columns'

      note 'Carefully apply 630 #{MICROLITERS} of the solution from step 5 to the ' \
        'QIAamp Mini spin column (in a wash tube (WT)) without wetting the rim.'
      note "Close the cap, and centrifuge at approximately 6000 #{TIMES_G} " \
        "for ≥1 #{MINUTES}. Place the QIAamp Mini spin column into a clean" \
        "#{WASH_TUBE}, and discard the wash tube containing " \
        'the filtrate.'
      warning 'Close each spin column in order to avoid cross-contamination ' \
        'during centrifugation.'
      # Centrifugation is performed at approximately 6000 x g in order to limit
      # microcentrifuge noise. Centrifugation at full speed will not affect the
      # yield or purity of the viral RNA. If the solution has not completely
      # passed through the membrane, centrifuge again at a higher speed
      # until all of the solution has passed through.
      separator

      note 'Carefully open the QIAamp Mini spin column, and repeat step 6.'
      note 'Repeat this step until all of the lysate has been loaded onto ' \
        'the spin column.'
    end
  end

  def wash_rna
    show do
      title 'Wash with Buffer AW1'

      note 'Carefully open the QIAamp Mini spin column, and add ' \
        "#{qty_display(WASH_VOLUME)} Buffer AW1."
      note 'Close the cap, and centrifuge at approximately ' \
        "6000 #{TIMES_G} for ≥1 #{MINUTES}."
      note "Place the QIAamp Mini spin column in a clean #{WASH_TUBE}, " \
        'and discard the wash tube containing the filtrate.'
      # It is not necessary to increase the volume of Buffer AW1 even if the
      # original sample volume was larger than 140 μl.
    end

    show do
      title 'Wash with Buffer AW1'

      note 'Carefully open the QIAamp Mini spin column, and add ' \
        "#{qty_display(WASH_VOLUME)} Buffer AW2."
      note 'Close the cap and centrifuge at full speed ' \
        "(approximately 20,000 #{TIMES_G}) for 3 #{MINUTES}."
      separator

      note "Place the QIAamp Mini spin column in a new #{WASH_TUBE}, " \
        'and discard the wash tube containing the filtrate. '
      note "Centrifuge at full speed for 1 #{MINUTES}."
    end
  end

  def elute_rna
    show do
      title 'Elute RNA'

      note 'Place the QIAamp Mini spin column in a clean elution tube (ET).'
      note 'Discard the wash tube containing the filtrate.'
      note 'Carefully open the QIAamp Mini spin column and add ' \
        "60 #{MICROLITERS} of Buffer AVE equilibrated to room temperature."
      note "Close the cap, and incubate at room temperature for ≥1 #{MINUTES}."
      note "Centrifuge at approximately 6000 #{TIMES_G} for ≥1 #{MINUTES}."
    end
  end

  private

  def buffer_avl_volume(sample_volume:)
    unless sample_volume[:units] == MICROLITERS
      raise ProtocolError, "Parameter :sample_volume must be in #{MICROLITERS}"
    end

    qty = sample_volume[:qty] * 560 / 140
    { qty: qty, units: MICROLITERS }
  end
end
