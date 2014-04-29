require 'rspec/core/formatters/base_text_formatter'

class VimQuickfixFormatter < RSpec::Core::Formatters::BaseTextFormatter
  # This registers the notifications this formatter supports, and tells
  # us that this was written against the RSpec 3.x formatter API.
  RSpec::Core::Formatters.register self, :dump_failures, :dump_summary

  def initialize(output)
    super(output)
  end

  def dump_failures(notification)
    return if failed_examples.empty?
    failed_examples.each do |example|
      dump_failure_info(example) unless pending_fixed?(example)
    end
  end

  def dump_summary(summary)
    output.puts "\n#{summary.summary_line}"
  end

  # NoOp
  def seed(*args); end
  def message(*args); end
  def dump_pending(*args); end

  private

  def dump_failure_info(example)
    exception = example.exception
    output.puts "#{relative_path(example.location)}: E: #{example.full_description}"

    lines = exception.message
              .gsub(/^\n|\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]/, '')
              .split("\n")
              .map { |line| line.length > 128 ? "#{line[0, 125]}..." : line }
              .compact

    output.puts lines.join("\n    ")
  end

  def relative_path(path)
    path.gsub(/^\.\//, '')
  end
end
