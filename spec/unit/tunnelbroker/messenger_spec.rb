# -*- coding: UTF-8 -*-
require 'spec_helper'

describe TunnelBroker::Messenger do
  before do
    @opts = {
      url: 'test1', username: 'test2', update_key: 'test3', tunnelid: 'test4'
    }
    @messenger = TunnelBroker::Messenger.new(@opts)
  end

  describe '.opts_to_inst' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @messenger.send(:opts_to_inst, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @messenger.send(:opts_to_inst)
        end.to raise_error ArgumentError
      end
    end

    context 'when given an option hash and inst_vars do not exist' do
      before do
        @messenger.remove_instance_variable(:@url)
        @messenger.remove_instance_variable(:@username)
        @messenger.remove_instance_variable(:@update_key)
        @messenger.remove_instance_variable(:@tunnelid)
      end

      it 'should properly convert the hash to instance variables' do
        t_opts = { url: 't', username: 'u', update_key: 'k', tunnelid: 'ti' }
        @messenger.send(:opts_to_inst, t_opts)

        m = @messenger.instance_variable_get(:@url)
        expect(m).to eql t_opts[:url]

        m = @messenger.instance_variable_get(:@username)
        expect(m).to eql t_opts[:username]

        m = @messenger.instance_variable_get(:@update_key)
        expect(m).to eql t_opts[:update_key]

        m = @messenger.instance_variable_get(:@tunnelid)
        expect(m).to eql t_opts[:tunnelid]
      end
    end

    context 'when given an option hash and inst_vars do exist' do
      it 'should properly convert the hash to instance variables' do
        t_opts = { url: 'w', username: 'x', update_key: 'y', tunnelid: 'z' }
        @messenger.send(:opts_to_inst, t_opts)

        m = @messenger.instance_variable_get(:@url)
        expect(m).to eql t_opts[:url]

        m = @messenger.instance_variable_get(:@username)
        expect(m).to eql t_opts[:username]

        m = @messenger.instance_variable_get(:@update_key)
        expect(m).to eql t_opts[:update_key]

        m = @messenger.instance_variable_get(:@tunnelid)
        expect(m).to eql t_opts[:tunnelid]
      end
    end
  end

  describe '.call_endpoint' do
    before do
      allow(TunnelBroker::Messenger).to receive(:get).with(
        'test1',
        basic_auth: {
          username: @opts[:username], password: @opts[:update_key]
        },
        query: {
          username: @opts[:username], password: @opts[:update_key],
          hostname: @opts[:tunnelid]
        }
      ).and_return('success!')
    end

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          @messenger.send(:call_endpoint, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called with no arguments' do
      subject { @messenger.send(:call_endpoint) }

      it { should eql 'success!' }
    end
  end

  describe '.call_api' do
    before do
      allow(TunnelBroker::Messenger).to receive(:get).with(
        'test1',
        basic_auth: {
          username: @opts[:username], password: @opts[:update_key]
        },
        query: {
          username: @opts[:username], password: @opts[:update_key],
          hostname: @opts[:tunnelid]
        }
      ).and_return('more practice, more success!')

      allow(TunnelBroker::APIResponse).to receive(:new) do |arg1|
        arg1
      end
    end

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect { @messenger.call_api(nil) }.to raise_error ArgumentError
      end
    end

    context 'when passed on args' do
      subject { @messenger.call_api }

      it { should eql 'more practice, more success!' }
    end
  end

  describe '#new' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          TunnelBroker::Messenger.new(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          TunnelBroker::Messenger.new
        end.to raise_error ArgumentError
      end
    end

    context 'when given an option Hash' do
      subject { @messenger }

      it { should be_an_instance_of TunnelBroker::Messenger }
    end
  end
end
