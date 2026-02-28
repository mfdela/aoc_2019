defmodule Aoc.Day07 do
  def part1(input) do
    program = parse_input(input)

    # Generate all permutations of phase settings 0-4
    [0, 1, 2, 3, 4]
    |> permutations()
    |> Enum.map(&run_amplifier_chain(program, &1))
    |> Enum.max()
  end

  def part2(input) do
    program = parse_input(input)

    # Generate all permutations of phase settings 5-9
    [5, 6, 7, 8, 9]
    |> permutations()
    |> Enum.map(&run_feedback_loop(program, &1))
    |> Enum.max()
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, value} end)
    |> Enum.into(%{})
  end

  def run_amplifier_chain(program, phase_settings) do
    phase_settings
    |> Enum.reduce(0, fn phase_setting, input_signal ->
      run_amplifier(program, phase_setting, input_signal)
    end)
  end

  def run_amplifier(program, phase_setting, input_signal) do
    inputs = [phase_setting, input_signal]
    run_amplifier_to_completion(program, 0, inputs, [])
  end

  def run_amplifier_to_completion(program, pc, inputs, outputs) do
    case run_program_until_output_or_halt(program, pc, inputs, outputs) do
      {:halt, _final_program, final_outputs} ->
        List.last(final_outputs)
      {:output, new_program, new_pc, remaining_inputs, new_outputs, _output_value} ->
        run_amplifier_to_completion(new_program, new_pc, remaining_inputs, new_outputs)
    end
  end

  def run_feedback_loop(program, phase_settings) do
    # Initialize all 5 amplifiers with their phase settings
    amplifiers = Enum.with_index(phase_settings)
    |> Enum.map(fn {phase, index} ->
      initial_state = %{
        program: program,
        pc: 0,
        inputs: (if index == 0, do: [phase, 0], else: [phase]),
        outputs: [],
        halted: false
      }
      {index, initial_state}
    end)
    |> Enum.into(%{})

    # Run the feedback loop until amplifier E halts
    run_feedback_loop_step(amplifiers, 0, 0)
  end

  defp run_feedback_loop_step(amplifiers, current_amp, last_e_output) do
    amp_state = amplifiers[current_amp]

    if amp_state.halted do
      # If current amplifier is halted, move to next
      next_amp = rem(current_amp + 1, 5)
      if amplifiers[4].halted do
        # Amplifier E has halted, return its last output
        last_e_output
      else
        run_feedback_loop_step(amplifiers, next_amp, last_e_output)
      end
    else
      # Run the current amplifier until it outputs or halts
      case run_program_until_output_or_halt(amp_state.program, amp_state.pc, amp_state.inputs, amp_state.outputs) do
        {:halt, final_program, outputs} ->
          # Amplifier halted
          updated_state = %{amp_state | program: final_program, outputs: outputs, halted: true}
          updated_amplifiers = Map.put(amplifiers, current_amp, updated_state)

          new_last_e_output = if current_amp == 4 and length(outputs) > 0, do: List.last(outputs), else: last_e_output

          if current_amp == 4 do
            # Amplifier E halted, return its last output
            new_last_e_output
          else
            next_amp = rem(current_amp + 1, 5)
            run_feedback_loop_step(updated_amplifiers, next_amp, new_last_e_output)
          end

        {:output, new_program, new_pc, remaining_inputs, outputs, output_value} ->
          # Amplifier produced output
          updated_state = %{amp_state | program: new_program, pc: new_pc, inputs: remaining_inputs, outputs: outputs}
          updated_amplifiers = Map.put(amplifiers, current_amp, updated_state)

          # Send output to next amplifier
          next_amp = rem(current_amp + 1, 5)
          next_state = amplifiers[next_amp]
          next_updated_state = %{next_state | inputs: next_state.inputs ++ [output_value]}
          final_amplifiers = Map.put(updated_amplifiers, next_amp, next_updated_state)

          new_last_e_output = if current_amp == 4, do: output_value, else: last_e_output

          run_feedback_loop_step(final_amplifiers, next_amp, new_last_e_output)
      end
    end
  end


  def run_program_until_output_or_halt(program, pc, inputs, outputs) do
    instruction = program[pc]
    opcode = rem(instruction, 100)
    modes = div(instruction, 100)

    case opcode do
      99 ->
        {:halt, program, outputs}

      1 ->
        # Add
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))
        dest = program[pc + 3]

        Map.put(program, dest, param1 + param2)
        |> run_program_until_output_or_halt(pc + 4, inputs, outputs)

      2 ->
        # Multiply
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))
        dest = program[pc + 3]

        Map.put(program, dest, param1 * param2)
        |> run_program_until_output_or_halt(pc + 4, inputs, outputs)

      3 ->
        # Input
        case inputs do
          [] ->
            # No input available, wait (this shouldn't happen in our implementation)
            {:wait_for_input, program, pc, inputs, outputs}
          [input | remaining_inputs] ->
            dest = program[pc + 1]
            Map.put(program, dest, input)
            |> run_program_until_output_or_halt(pc + 2, remaining_inputs, outputs)
        end

      4 ->
        # Output
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        new_outputs = outputs ++ [param1]
        {:output, program, pc + 2, inputs, new_outputs, param1}

      5 ->
        # Jump-if-true
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))

        new_pc = if param1 != 0, do: param2, else: pc + 3
        run_program_until_output_or_halt(program, new_pc, inputs, outputs)

      6 ->
        # Jump-if-false
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))

        new_pc = if param1 == 0, do: param2, else: pc + 3
        run_program_until_output_or_halt(program, new_pc, inputs, outputs)

      7 ->
        # Less than
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))
        dest = program[pc + 3]

        value = if param1 < param2, do: 1, else: 0

        Map.put(program, dest, value)
        |> run_program_until_output_or_halt(pc + 4, inputs, outputs)

      8 ->
        # Equals
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))
        dest = program[pc + 3]

        value = if param1 == param2, do: 1, else: 0

        Map.put(program, dest, value)
        |> run_program_until_output_or_halt(pc + 4, inputs, outputs)
    end
  end



  def get_param(program, addr, mode) do
    case mode do
      # Position mode
      0 -> program[program[addr]]
      # Immediate mode
      1 -> program[addr]
    end
  end

  def get_mode(modes, position) do
    modes
    |> div(Integer.pow(10, position))
    |> rem(10)
  end

  # Generate all permutations of a list
  def permutations([]), do: [[]]
  def permutations(list) do
    for elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest]
  end

end
