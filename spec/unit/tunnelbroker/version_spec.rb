# -*- coding: UTF-8 -*-
require 'spec_helper'

describe TunnelBroker::VERSION do
  it { should be_an_instance_of String }

  it 'should match a semantic version regex check' do
    m = /^\d+\.\d+\.\d+$/
    expect(m.match(subject)).not_to be_nil
  end
end
