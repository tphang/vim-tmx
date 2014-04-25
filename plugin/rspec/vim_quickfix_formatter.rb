require 'rspec/core/formatters/base_text_formatter'

class VimQuickfixFormatter < RSpec::Core::Formatters::BaseTextFormatter
  def example_failed example
    exception = example.execution_result[:exception]
    backtrace = format_backtrace(exception.backtrace, example).first
    backtrace.match %r{\./(.*\.rb:\d+)(?::|\z)}
    path = $1

    message = format_message exception.message
    path    = format_caller path
    output.puts "#{path}: [FAIL] #{message}" if path
  end

  def example_pending example
    message = format_message example.execution_result[:pending_message]
    path    = format_caller example.location
    output.puts "#{path}: [PEND] #{message}" if path
  end

  # NOOPs
  def dump_failures *args; end
  def dump_pending *args; end
  def message msg; end
  def dump_summary *args; end
  def seed *args; end

  private

  def format_message msg
    msg.gsub("\n", ' ')[0,40].squeeze.strip
  end
end
