# encoding: utf-8
#
require 'spec_helper'

describe Phony do

  describe 'regression' do
    it 'best effort #152' do
      described_class.split('39694805123').should eql ['39', '694805123', []]
      described_class.format('39694805123').should eql '+39 694805123 '
    end
  end

  describe 'OO interface' do
    describe '[]' do
      it '' do
        us = described_class['1']
        us.plausible?('4159224711').should be_true
        us.normalize('4159224711').should eql '4159224711'
      end
    end
  end

  describe 'formatted' do
    it 'is an alias of format' do
      Phony.formatted('41443643532').should eql '+41 44 364 35 32'
    end
  end

  describe 'format' do
    describe 'exceptions' do
      it 'raises on nil' do
        expect {
          Phony.format nil
        }.to raise_error(ArgumentError, 'Phone number cannot be nil. Use e.g. number && Phony.format(number).')
      end
    end
    describe 'default' do
      it 'should format Swiss numbers' do
        Phony.format('41443643532').should eql '+41 44 364 35 32'
      end
      it 'should format Swiss national numbers' do
        Phony.format('41443643532', :format => :national).should eql '044 364 35 32'
      end
      # TODO
      #
      it 'should format Swiss service numbers' do
        Phony.format('41800112233').should eql '+41 800 112 233'
      end
      it 'should format Austrian numbers' do
        Phony.format('43198110').should eql '+43 1 98110'
      end
      it 'should format American numbers' do
        Phony.format('18705551122').should eql '+1 870 555 1122'
      end
      it 'should format New Zealand 021 6-digit mobile numbers' do
        Phony.format('6421123456').should eql '+64 21 123 456'
      end
      it 'should format New Zealand 021 7-digit mobile numbers' do
        Phony.format('64211234567').should eql '+64 21 123 4567'
      end
      it 'should format New Zealand 021 8-digit mobile numbers' do
        Phony.format('642112345678').should eql '+64 21 12 345 678'
      end
      it 'should format New Zealand landline numbers' do
        Phony.format('6493791234').should eql '+64 9 379 1234'
      end
      it 'should format Indian numbers' do
        Phony.format('914433993939').should eql '+91 44 339 93 939'
      end
      it 'should format Russian numbers' do
        Phony.format(Phony.normalize('+370 800 12345'), :format => :international).should eql '+370 800 12 345'
      end
      it 'should format Russian numbers' do
        Phony.format(Phony.normalize('+7 812 123 4567'), :format => :international).should eql '+7 812 123 4567'
      end
      it 'should format Russian numbers' do
        Phony.format(Phony.normalize('+370 800 12345'), :format => :national).should eql '8800 12 345'
      end
      it 'should format Russian numbers' do
        Phony.format(Phony.normalize('+7 812 123 4567'), :format => :national).should eql '8812 123 4567'
      end
    end
    describe 'international' do
      it 'should format north american numbers' do
        Phony.format('18091231234', :format => :international).should eql '+1 809 123 1234'
      end
      it 'should format austrian numbers' do
        Phony.format('43198110', :format => :international).should eql '+43 1 98110'
      end
      it 'should format austrian numbers' do
        Phony.format('43198110', :format => :international_absolute).should eql '+43 1 98110'
      end
      it 'should format french numbers' do
        Phony.format('33142278186', :format => :+).should eql '+33 1 42 27 81 86'
      end
      it 'should format austrian numbers' do
        Phony.format('43198110', :format => :international_relative).should eql '0043 1 98110'
      end
      it 'should format liechtensteiner numbers' do
        Phony.format('4233841148', :format => :international_relative).should eql '00423 384 11 48'
      end
      context 'with no spaces' do
        it 'should format north american numbers' do
          Phony.format('18091231234', :format => :international, :spaces => '').should eql '+18091231234'
        end
        it 'should format austrian numbers' do
          Phony.format('43198110', :format => :international, :spaces => '').should eql '+43198110'
        end
        it 'should format austrian numbers' do
          Phony.format('43198110', :format => :international_absolute, :spaces => '').should eql '+43198110'
        end
        it 'should format french numbers' do
          Phony.format('33142278186', :format => :+, :spaces => '').should eql '+33142278186'
        end
        it 'should format austrian numbers' do
          Phony.format('43198110', :format => :international_relative, :spaces => '').should eql '0043198110'
        end
        it 'should format liechtensteiner numbers' do
          Phony.format('4233841148', :format => :international_relative, :spaces => '').should eql '004233841148'
        end
      end
      context 'with special spaces' do
        it 'should format swiss numbers' do
          Phony.format('41443643532', :format => :international).should eql '+41 44 364 35 32'
        end
        it 'should format north american numbers' do
          Phony.format('18091231234', :format => :international, :spaces => :-).should eql '+1-809-123-1234'
        end
        it 'should format austrian numbers' do
          Phony.format('43198110', :format => :international, :spaces => :-).should eql '+43-1-98110'
        end
        it 'should format austrian numbers' do
          Phony.format('43198110', :format => :international_absolute, :spaces => :-).should eql '+43-1-98110'
        end
        it 'should format french numbers' do
          Phony.format('33142278186', :format => :+, :spaces => :-).should eql '+33-1-42-27-81-86'
        end
        it 'should format austrian numbers' do
          Phony.format('43198110', :format => :international_relative, :spaces => :-).should eql '0043-1-98110'
        end
        it 'should format liechtensteiner numbers' do
          Phony.format('4233841148', :format => :international_relative, :spaces => :-).should eql '00423-384-11-48'
        end
      end
      describe "'unsupported' countries" do
        it 'should format as a single block' do
          Phony.format('88132155605220').should eql '+881 32155605220'
        end
        it 'should format as a single block, regardless of format' do
          Phony.format('8811819372205', :format => :international).should eql '+881 1819372205'
        end
        it 'should format as a single block, respecting custom spaces' do
          Phony.format('8811819372205', :spaces => :-).should eql '+881-1819372205'
        end
        it 'should format as a single block, even without spaces' do
          Phony.format('8811819372205', :spaces => '').should eql '+8811819372205'
        end
      end
    end
    describe 'national' do
      it 'should format swiss numbers' do
        Phony.format('41443643532', :format => :national).should eql '044 364 35 32'
      end
      # TODO
      #
      it 'should format swiss service numbers' do
        Phony.format('41800112233', :format => :national).should eql '0800 112 233'
      end
      it 'should format austrian numbers' do
        Phony.format('43198110', :format => :national).should eql '01 98110'
      end
      it 'should format US numbers with a leading trunk 1' do
        Phony.format('14159224711', :format => :national).should eql '1 415 922 4711'
      end
      it 'should format Dutch numbers with a trunk code' do
        Phony.format('311012341234', :format => :national).should eql '010 123 41234'
      end
    end
    describe 'local' do
      it 'should format swiss numbers' do
        Phony.format('41443643532', :format => :local).should eql '364 35 32'
      end
      it 'should format german numbers' do
        Phony.format('493038625454', :format => :local).should eql '386 25454'
      end
    end
  end

  context 'minimal cases' do
    context 'splitting' do
      describe 'exceptions' do
        it 'should raise on split nil' do
          expect {
            Phony.split nil
          }.to raise_error(ArgumentError, 'Phone number cannot be nil. Use e.g. number && Phony.split(number).')
        end
      end
      it 'handles completely missing numbers well enough' do
        Phony.split('4144').should eql ['41', '44', '']
      end
      it 'handles a missing number part' do
        Phony.split('4144364').should eql ['41', '44', '364']
      end
      it 'handles a missing number part' do
        Phony.split('414436435').should eql ['41', '44', '364', '35']
      end
    end
    context 'formatting' do
      it 'handles completely missing numbers well enough' do
        Phony.format('4144').should eql '+41 44 '
      end
      it 'handles a missing number part' do
        Phony.format('4144364').should eql '+41 44 364'
      end
      it 'handles a missing number part' do
        Phony.format('414436435').should eql '+41 44 364 35'
      end
    end
    context "'unsupported' countries" do
      it 'handles formatting' do
        Phony.format('88132155605220').should eql '+881 32155605220'
      end
      it 'handles normalizing' do
        Phony.normalize('+881-321 5560 5220').should eql '88132155605220'
      end
    end
  end

  context 'speed' do
    before(:each) do
      @phone_numbers = [
        '41443643532',
        '18091231234',
        '43198110',
        '33142278186',
        '4233841148'
      ]
    end
    describe 'split' do
      it 'is fast' do
        number = @phone_numbers.first
        performance_of { Phony.split(number) }.should < 0.00005
      end
      it 'is fast' do
        performance_of { @phone_numbers.each { |number| Phony.split(number) } }.should < 0.00015
      end
    end
    describe 'normalize' do
      it 'is fast' do
        number = @phone_numbers.first
        performance_of { Phony.normalize(number) }.should < 0.0001
      end
      it 'is fast' do
        performance_of { @phone_numbers.each { |number| Phony.normalize(number) } }.should < 0.00016
      end
    end
    describe 'format' do
      it 'is fast' do
        number = @phone_numbers.first
        performance_of { Phony.format(number) }.should < 0.000075
      end
      it 'is fast' do
        performance_of { @phone_numbers.each { |number| Phony.format(number) } }.should < 0.00016
      end
    end
  end

  describe 'vanity' do
    describe 'vanity_number?' do
      it {Phony.vanity?('41800 WEGGLI').should be_true}
      it {Phony.vanity?('41800WEGGLI').should be_true}
      it {Phony.vanity?('41848 SUCCESSMATCH').should be_true}
      it {Phony.vanity?('4180 NO NO NO').should be_false}
      it {Phony.vanity?('41900 KURZ').should be_false}
      it {Phony.vanity?('41 44 364 35 32').should be_false}
    end

    describe 'vanity_to_number' do
      it {Phony.vanity_to_number('41800WEGGLI').should eql '41800934454'}
      it {Phony.vanity_to_number('41800weggli').should eql '41800934454'}
      # it {Phony.vanity_to_number('41800SUCCESSMATCH').should eql '41800782237'} # Cut off according to the swiss norms.
      it {Phony.vanity_to_number('41800SUCCESSMATCH').should eql '41800782237762824'} # Allow for call-through numbers (>= 1.6.0)
      it {Phony.vanity_to_number('4180BLA').should eql '4180252'} # Does not check for validity of number.
    end
  end

end
