# -*- coding: UTF-8 -*-
require 'uri'
require 'spec_helper'

# MockConfig class
# for .build_messenger_config
class MockConfig
  @@url = nil
  def self.url
    @@url
  end
  def self.url=(url_in)
    @@url = url_in
  end

  def self.username
    'tim'
  end
  def self.update_key
    'abc123'
  end
  def self.tunnelid
    '1234'
  end
  def self.ip4addr
    '127.0.0.1'
  end
end

# MockMessenger class
# for submit_update testing
class MockMessenger
  attr_reader :x
  def initialize(xa)
    @x = xa
  end

  def call_api
    x
  end
end

describe TunnelBroker::Client do
  describe '::ENDPOINT' do
    subject { TunnelBroker::Client::ENDPOINT }

    it { should be_an_instance_of String }

    it 'should match the URI regexp' do
      expect(URI.regexp.match(subject)).to_not be_nil
    end

    it 'should use HTTPS' do
      u = URI(subject)
      expect(u.scheme.downcase).to eql 'https'
    end
  end

  describe '.config' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:config, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when @config does not exist' do
      subject { TunnelBroker::Client.new.send(:config) }

      it { should be_an_instance_of TunnelBroker::Configuration }
    end

    context 'when @config does exist' do
      before do
        @tbc = TunnelBroker::Client.new
        @tbc.instance_variable_set(
          :@config, TunnelBroker::Configuration.new
        )
      end
      subject { @tbc.send(:config) }

      it { should be_an_instance_of TunnelBroker::Configuration }
    end
  end

  describe '.build_messenger_config' do
    before do
      @tbc = TunnelBroker::Client.new
      allow(@tbc).to receive(:config).and_return(MockConfig)
      @base_hash = { url: TunnelBroker::Client::ENDPOINT }
    end

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:build_messenger_config, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when config.url set' do
      before do
        allow(MockConfig).to receive(:url).and_return('http://tb.io/')
        allow(MockConfig).to receive(:username).and_return(nil)
        allow(MockConfig).to receive(:update_key).and_return(nil)
        allow(MockConfig).to receive(:tunnelid).and_return(nil)
        allow(MockConfig).to receive(:ip4addr).and_return(nil)
      end

      subject { @tbc.send(:build_messenger_config) }

      it { should be_an_instance_of Hash }

      it { should eql(url: 'http://tb.io/') }
    end

    context 'when config.url is not set' do
      before do
        allow(MockConfig).to receive(:username).and_return(nil)
        allow(MockConfig).to receive(:update_key).and_return(nil)
        allow(MockConfig).to receive(:tunnelid).and_return(nil)
        allow(MockConfig).to receive(:ip4addr).and_return(nil)
      end

      subject { @tbc.send(:build_messenger_config) }

      it { should be_an_instance_of Hash }

      it { should eql(url: TunnelBroker::Client::ENDPOINT) }
    end

    context 'when config.username is set' do
      before do
        @cfg = @base_hash.merge(username: MockConfig.username)
        allow(MockConfig).to receive(:update_key).and_return(nil)
        allow(MockConfig).to receive(:tunnelid).and_return(nil)
        allow(MockConfig).to receive(:ip4addr).and_return(nil)
      end

      subject { @tbc.send(:build_messenger_config) }

      it { should be_an_instance_of Hash }

      it { should eql @cfg }
    end

    context 'when config.update_key is set' do
      before do
        @cfg = @base_hash.merge(update_key: MockConfig.update_key)
        allow(MockConfig).to receive(:username).and_return(nil)
        allow(MockConfig).to receive(:tunnelid).and_return(nil)
        allow(MockConfig).to receive(:ip4addr).and_return(nil)
      end

      subject { @tbc.send(:build_messenger_config) }

      it { should be_an_instance_of Hash }

      it { should eql @cfg }
    end

    context 'when config.tunnelid is set' do
      before do
        @cfg = @base_hash.merge(tunnelid: MockConfig.tunnelid)
        allow(MockConfig).to receive(:username).and_return(nil)
        allow(MockConfig).to receive(:update_key).and_return(nil)
        allow(MockConfig).to receive(:ip4addr).and_return(nil)
      end

      subject { @tbc.send(:build_messenger_config) }

      it { should be_an_instance_of Hash }

      it { should eql @cfg }
    end

    context 'when config.ip4addr is set' do
      before do
        @cfg = @base_hash.merge(ip4addr: MockConfig.ip4addr)
        allow(MockConfig).to receive(:username).and_return(nil)
        allow(MockConfig).to receive(:update_key).and_return(nil)
        allow(MockConfig).to receive(:tunnelid).and_return(nil)
      end

      subject { @tbc.send(:build_messenger_config) }

      it { should be_an_instance_of Hash }

      it { should eql @cfg }
    end

    context 'when all config options are set' do
      before do
        @cfg = {
          url: TunnelBroker::Client::ENDPOINT,
          username: MockConfig.username,
          update_key: MockConfig.update_key,
          tunnelid: MockConfig.tunnelid,
          ip4addr: MockConfig.ip4addr
        }
      end

      subject { @tbc.send(:build_messenger_config) }

      it { should be_an_instance_of Hash }

      it { should eql @cfg }
    end
  end

  describe '.submit_update' do
    before do
      @tbc = TunnelBroker::Client.new
    end

    context 'when given any args' do
      it 'to raise ArgumentError' do
        expect do
          @tbc.submit_update(nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when submitted with no args' do
      before do
        allow(@tbc).to receive(:config).and_return(MockConfig)
        allow(@tbc).to receive(:build_messenger_config).and_return(
          x: 'wat'
        )
        allow(TunnelBroker::Messenger).to receive(:new) do |arg1|
          MockMessenger.new(arg1)
        end
      end

      subject { @tbc.submit_update }

      it { should be_an_instance_of Hash }

      it { should eql(x: 'wat') }
    end
  end

  describe '.configure' do
    before do
      @tbc = TunnelBroker::Client.new
    end

    context 'when given any args' do
      it 'should raise ArgumentError' do
        expect do
          @tbc.configure(nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called with a block' do
      before do
        allow(@tbc).to receive(:config).and_return('configObj')
      end

      it 'should yield control' do
        expect { |b| @tbc.configure(&b) }.to yield_control
      end

      it 'should yield the object returned from .config' do
        expect { |b| @tbc.configure(&b) }.to yield_with_args('configObj')
      end
    end

    context 'when not called with a block' do
      subject { @tbc.configure }

      it { should be_nil }
    end
  end
end
