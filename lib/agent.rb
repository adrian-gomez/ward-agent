require 'logger'
require 'json'

require 'httparty'
require 'usagewatch'
require 'yew'

class Agent

  HEADERS = { 'Content-Type' => 'application/json' }
  READINGS_PATH = '/api/readings'

  def emit!
    logger.debug("Sending data: #{data}")
    do_post(readings_path, { reading: { data: data } }).tap do |response|
      log_response(response)
    end
  rescue => error
    logger.error("#{error.class}: #{error.message}")
    error.backtrace.each { |trace| logger.error(trace) }
  end

  private

  def do_post(path, data)
    HTTParty.post(path, { body: JSON(data), headers: HEADERS })
  end

  def readings_path
    URI.join(settings.ward_server_uri, READINGS_PATH).to_s
  end

  def log_response(response)
    if response.success?
      logger.debug("Response: #{response.body}")
    else
      logger.warn("Error response: #{response.body}")
    end
  end

  def data
    @data ||= {
      cpu_usage: get_cpu_usage,
      disk_usage: get_disk_usage,
      process_list: get_process_list
    }
  end

  def get_cpu_usage
    Usagewatch.uw_cpuused
  end

  def get_disk_usage
    Usagewatch.uw_diskused_perc
  end

  def get_process_list
    Usagewatch.uw_cputop
  end

  def logger
    self.class.logger
  end

  def settings
    self.class.settings
  end

  def self.logger
    @logger ||= Logger.new(settings.log_file, 'daily')
  end

  def self.settings
    @settings ||= Yew.load('config/settings.yml')
  end

end