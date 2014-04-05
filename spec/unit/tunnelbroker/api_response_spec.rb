# -*- coding: UTF-8 -*-
require 'spec_helper'

# Mock class for testing API responses
#
class MockResponse
  attr_reader :lines

  def initialize(text)
    @lines = [text]
  end
end

describe TunnelBroker::APIResponse do
  describe '::BADAUTH' do
    subject { TunnelBroker::APIResponse::BADAUTH }

    it { should be_an_instance_of Regexp }

    it 'should match the right string' do
      s = 'badauth'
      m = subject.match(s)
      expect(m[1]).to eql 'badauth'
    end
  end

  describe '::CHANGE' do
    subject { TunnelBroker::APIResponse::CHANGE } # obama

    it { should be_an_instance_of Regexp }

    it 'should match the right string' do
      s = 'good 127.0.0.1'
      m = subject.match(s)
      expect(m[1]).to eql 'good'
      expect(m[2]).to eql '127.0.0.1'
    end
  end

  describe '::NO_CHANGE' do
    subject { TunnelBroker::APIResponse::NO_CHANGE }

    it { should be_an_instance_of Regexp }

    it 'should match the right string' do
      s = 'nochg 127.0.0.1'
      m = subject.match(s)
      expect(m[1]).to eql 'nochg'
      expect(m[2]).to eql '127.0.0.1'
    end
  end

  describe '.matched_response' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:matched_response, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect { subject.send(:matched_response) }.to raise_error ArgumentError
      end
    end

    context 'when given a match' do
      subject do
        TunnelBroker::APIResponse.new(MockResponse.new('nochg 127.0.0.1'))
      end
      let(:m) { TunnelBroker::APIResponse::NO_CHANGE }
      let(:thematch) { m.match('nochg 127.0.0.1') }

      it 'should return a Hash for .response' do
        subject.send(:matched_response, thematch)
        expect(subject.response).to be_an_instance_of Hash
      end

      it 'should return the exepcted Hash for .response' do
        subject.send(:matched_response, thematch)
        expect(subject.response)
          .to eql(msg: thematch[1], data: { ip: thematch[2] })
      end
    end
  end

  describe '.no_change' do
    context 'when given more than two args' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:no_change, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect { subject.send(:no_change) }.to raise_error ArgumentError
      end
    end

    context 'when passed a match' do
      subject do
        TunnelBroker::APIResponse.new(MockResponse.new('nochg 127.0.0.1'))
      end
      let(:m) { TunnelBroker::APIResponse::NO_CHANGE }
      let(:thematch) { m.match('nochg 127.0.0.1') }

      it 'should return true for .successful?' do
        subject.send(:no_change, thematch)
        expect(subject.successful?).to be_truthy
      end

      it 'should return false for .changed?' do
        subject.send(:no_change, thematch)
        expect(subject.changed?).to be_falsey
      end

      it 'should return a Hash for .response' do
        subject.send(:no_change, thematch)
        expect(subject.response).to be_an_instance_of Hash
      end

      it 'should return the exepcted Hash for .response' do
        subject.send(:no_change, thematch)
        expect(subject.response)
          .to eql(msg: thematch[1], data: { ip: thematch[2] })
      end
    end
  end

  describe '.change' do
    context 'when given more than two args' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:change, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect { subject.send(:change) }.to raise_error ArgumentError
      end
    end

    context 'when passed a match' do
      subject do
        TunnelBroker::APIResponse.new(MockResponse.new('good 127.0.0.1'))
      end
      let(:m) { TunnelBroker::APIResponse::CHANGE }
      let(:thematch) { m.match('good 127.0.0.1') }

      it 'should return true for .successful?' do
        subject.send(:change, thematch)
        expect(subject.successful?).to be_truthy
      end

      it 'should return true for .changed?' do
        subject.send(:change, thematch)
        expect(subject.successful?).to be_truthy
      end

      it 'should return a Hash for .response' do
        subject.send(:change, thematch)
        expect(subject.response).to be_an_instance_of Hash
      end

      it 'should return the expected Hash for .response' do
        subject.send(:change, thematch)
        expect(subject.response)
          .to eql(msg: thematch[1], data: { ip: thematch[2] })
      end
    end
  end

  describe '.bad_auth' do
    context 'when given more than two args' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:bad_auth, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect { subject.send(:bad_auth) }.to raise_error ArgumentError
      end
    end

    context 'when passed a match' do
      subject do
        TunnelBroker::APIResponse.new(MockResponse.new('badauth'))
      end
      let(:m) { TunnelBroker::APIResponse::BADAUTH }
      let(:thematch) { m.match('badauth') }

      it 'should return false for .successful?' do
        subject.send(:bad_auth, thematch)
        expect(subject.successful?).to be_falsey
      end

      it 'should return false for .changed?' do
        subject.send(:bad_auth, thematch)
        expect(subject.changed?).to be_falsey
      end

      it 'should return a Hash for .response' do
        subject.send(:bad_auth, thematch)
        expect(subject.response).to be_an_instance_of Hash
      end

      it 'should return the expected Hash for .response' do
        subject.send(:bad_auth, thematch)
        expect(subject.response)
          .to eql(msg: thematch[1], data: {})
      end
    end
  end

  describe '.parse_response' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          subject.send(:parse_response, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect { subject.send(:parse_response) }.to raise_error ArgumentError
      end
    end

    context 'when given a badauth string' do
      before do
        m = TunnelBroker::APIResponse::BADAUTH
        @md = m.match('badauth')
        allow_any_instance_of(TunnelBroker::APIResponse)
          .to receive(:bad_auth).with(@md).and_return('hello')
      end

      subject do
        TunnelBroker::APIResponse.new(
          MockResponse.new('badauth')
        ).send(:parse_response, 'badauth')
      end

      it { should be_an_instance_of String }

      it { should eql 'hello' }
    end

    context 'when given a change string' do
      before do
        m = TunnelBroker::APIResponse::CHANGE
        @md = m.match('good 127.0.0.1')
        allow_any_instance_of(TunnelBroker::APIResponse)
          .to receive(:change).with(@md).and_return('hi')
      end

      subject do
        TunnelBroker::APIResponse.new(
          MockResponse.new('good 127.0.0.1')
        ).send(:parse_response, 'good 127.0.0.1')
      end

      it { should be_an_instance_of String }

      it { should eql 'hi' }
    end

    context 'when given a no_change string' do
      before do
        m = TunnelBroker::APIResponse::NO_CHANGE
        @md = m.match('nochg 127.0.0.1')
        allow_any_instance_of(TunnelBroker::APIResponse)
          .to receive(:no_change).with(@md).and_return('wat')
      end

      subject do
        TunnelBroker::APIResponse.new(
          MockResponse.new('nochg 127.0.0.1')
        ).send(:parse_response, 'nochg 127.0.0.1')
      end

      it { should be_an_instance_of String }

      it { should eql 'wat' }
    end

    context 'when given a non-matching string' do
      subject do
        TunnelBroker::APIResponse.new(
          MockResponse.new('madness')
        )
      end

      it 'should not set a response value' do
        expect(subject.send(:parse_response, 'madness')).to be_nil
        expect(subject.response).to be_nil
      end
    end
  end

  describe '.changed?' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect { subject.changed?(nil) }.to raise_error ArgumentError
      end
    end

    context 'when @changed is true' do
      before do
        @t = TunnelBroker::APIResponse.new(MockResponse.new('good 127.0.0.1'))
      end
      subject { @t.changed? }

      it { should be_truthy }
    end

    context 'when @changed is false' do
      before do
        @t = TunnelBroker::APIResponse.new(MockResponse.new('nochg 127.0.0.1'))
      end
      subject { @t.changed? }

      it { should be_falsey }
    end

    context 'when @changed is not defined' do
      before do
        @t = TunnelBroker::APIResponse.new(MockResponse.new('good 127.0.0.1'))
        @t.remove_instance_variable(:@changed)
      end
      subject { @t.changed? }

      it { should be_falsey }
    end
  end

  describe '.successful?' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect { subject.successful?(nil) }.to raise_error ArgumentError
      end
    end

    context 'when @successful is true' do
      before do
        @t = TunnelBroker::APIResponse.new(MockResponse.new('good 127.0.0.1'))
      end
      subject { @t.successful? }

      it { should be_truthy }
    end

    context 'when @successful is false' do
      before do
        @t = TunnelBroker::APIResponse.new(MockResponse.new('badauth'))
      end
      subject { @t.successful? }

      it { should be_falsey }
    end

    context 'when @successful is not defined' do
      before do
        @t = TunnelBroker::APIResponse.new(MockResponse.new('good 127.0.0.1'))
        @t.remove_instance_variable(:@successful)
      end
      subject { @t.successful? }

      it { should be_falsey }
    end
  end

  describe '.new' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          TunnelBroker::APIResponse.new(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          TunnelBroker::APIResponse.new
        end.to raise_error ArgumentError
      end
    end

    context 'when given a response-like object' do
      subject do
        TunnelBroker::APIResponse.new(
          MockResponse.new('good 127.0.0.1')
        )
      end

      it { should be_an_instance_of TunnelBroker::APIResponse }

      it 'should call parse_response' do
        expect(subject.successful?).to be_truthy
        expect(subject.changed?).to be_truthy
        expect(subject.response).to be_an_instance_of Hash
      end
    end
  end
end
