# -*- coding: UTF-8 -*-
require 'spec_helper'

describe TunnelBroker::Configuration do
  describe '.set_default_values' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:set_default_values, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when called after changing values' do
      before(:each) do
        subject.ip4addr = ''
        subject.tunnelid = ''
        subject.username = ''
        subject.update_key = ''
      end

      it 'should set ip to nil' do
        subject.send(:set_default_values)

        expect(subject.ip4addr).to be_nil
      end

      it 'should set tunnnelid to nil' do
        subject.send(:set_default_values)

        expect(subject.tunnelid).to be_nil
      end

      it 'should set username to nil' do
        subject.send(:set_default_values)

        expect(subject.username).to be_nil
      end

      it 'should set update_key to nil' do
        subject.send(:set_default_values)

        expect(subject.update_key).to be_nil
      end
    end
  end

  describe '#new' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          TunnelBroker::Configuration.new(nil)
        end.to raise_error ArgumentError
      end
    end

    context 'under normal conditions' do
      subject { TunnelBroker::Configuration.new }

      it { should be_an_instance_of TunnelBroker::Configuration }

      it 'should set the default configuration options' do
        expect(subject.ip4addr).to be_nil
        expect(subject.tunnelid).to be_nil
        expect(subject.username).to be_nil
        expect(subject.update_key).to be_nil
      end
    end
  end
end
