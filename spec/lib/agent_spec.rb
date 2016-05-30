require 'lib/agent'

RSpec.describe Agent do

  subject(:agent) { Agent.new }

  let(:cpu_usage)     { rand * 100 }
  let(:disk_usage)    { rand * 100 }
  let(:process_list)  { ['process 1', 'process 2'] }

  before do
    allow(agent).to receive(:get_cpu_usage).and_return(cpu_usage)
    allow(agent).to receive(:get_disk_usage).and_return(disk_usage)
    allow(agent).to receive(:get_process_list).and_return(process_list)

    allow(HTTParty).to receive(:post).and_return(double(:response).as_null_object)
  end

  it 'sends a message to the server' do
    expect(HTTParty).to receive(:post).with('http://localhost:3000/api/readings', anything)

    agent.emit!
  end

  it 'sends the readings data' do
    body = JSON({ reading: { data: {  cpu_usage: cpu_usage,
                                      disk_usage: disk_usage,
                                      process_list: process_list } } })
    expect(HTTParty).to receive(:post).with('http://localhost:3000/api/readings',
                                            hash_including(body: body))

    agent.emit!
  end

  it 'sends the data as a json' do
    body = JSON({ reading: { data: {  cpu_usage: cpu_usage,
                                      disk_usage: disk_usage,
                                      process_list: process_list } } })
    expect(HTTParty).to receive(:post).with('http://localhost:3000/api/readings',
                                            hash_including(headers: { 'Content-Type' => 'application/json' }))

    agent.emit!
  end

end