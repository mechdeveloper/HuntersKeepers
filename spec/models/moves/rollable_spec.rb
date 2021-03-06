# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moves::Rollable, type: :model do
  let(:rollable) { create(:moves_rollable) }

  describe '#roll' do
    subject { rollable.roll(hunter) }
    let(:hunter) { create :hunter }
    before { allow_any_instance_of(Random).to receive(:rand).and_return(1) }

    it { is_expected.to eq hunter.weird + 1 }
  end

  describe '#roll_results' do
    subject { rollable.roll_results(hunter) }
    let(:hunter) { create :hunter, weird: 1 }
    before { allow_any_instance_of(Random).to receive(:rand).and_return(roll_result) }

    context 'roll is 5' do
      let(:roll_result) { 5 }

      it {
        is_expected.to eq "Your total 6 resulted in #{rollable.six_and_under}"
      }
    end

    context 'roll is 7' do
      let(:roll_result) { 7 }

      it { is_expected.to eq "Your total 8 resulted in #{rollable.seven_to_nine}" }
    end

    context 'roll is 9' do
      let(:roll_result) { 9 }

      it { is_expected.to eq "Your total 10 resulted in #{rollable.ten_plus}" }
    end

    context 'roll is 11' do
      let(:roll_result) { 10 }

      it { is_expected.to eq "Your total 11 resulted in #{rollable.ten_plus}" }
    end
  end
end
