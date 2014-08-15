# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Fireman do

  let(:fireman) { Fireman.new(:firstname => 'Test', :lastname => 'Test') }
  let(:station) { Station.make! }
  let(:fireman_with_grades) { station.firemen.new(:firstname => 'Test',
                                                  :lastname => 'Test',
                                                  :incorporation_date => Date.yesterday) }
  let(:fireman_resigned) { make_fireman_with_grades(:station => Station.make!,
                                                    :incorporation_date => Date.yesterday,
                                                    :resignation_date => Date.today) }

  before do
    fireman_with_grades.grades.last.date = Date.today - 3.weeks
  end

  it "initialize status to actif" do
    expect(fireman.status).to eq Fireman::STATUS['Actif']
  end

  it "initialize grades" do
    expect(fireman.grades.size).to eq Grade::GRADE.size
  end

  describe ".current_grade" do

    context "with no grades" do

      it "return nil for current_grade" do
        expect(fireman.current_grade).to be_nil
      end
    end

    context "with grades" do

      it "return current_grade" do
        expect(fireman_with_grades.current_grade.kind).to eq Grade::GRADE['2e classe']
      end
    end
  end

  describe ".max_grade_date" do

    context "with no grades" do

      it "return nil for max_grade_date" do
        expect(fireman.max_grade_date).to be_nil
      end
    end

    context "with grades" do

      it "return max_grade_date" do
        expect(fireman_with_grades.max_grade_date).to eq (Date.today - 3.weeks)
      end
    end
  end

  before do
    fireman_with_grades.save
  end

  describe ".grade" do

    it "return current grade" do
      expect(fireman_with_grades.grade).to eq Grade::GRADE['2e classe']
    end
  end

  describe ".grade_category" do

    it "return current grade category" do
      expect(fireman_with_grades.grade_category).to eq Grade::GRADE_CATEGORY['Homme du rang']
    end
  end

  describe ".resignation_date" do

    context "set" do

      before do
        fireman_with_grades.update_attributes(:resignation_date => Date.today)
      end

      it "set warnings" do
        expect(fireman_with_grades.warnings).to eq "Attention, cette personne est désormais dans la liste des hommes radiés."
      end
    end

    context "unset" do

      before do
        fireman_resigned.update_attributes(:resignation_date => nil)
      end

      it "set warnings" do
        expect(fireman_resigned.warnings).to eq "Attention, cette personne est désormais dans la liste des hommes."
      end
    end
  end

  describe "#destroy" do

    subject { fireman_with_grades.destroy }

    context "and not used in an intervention" do

      it { should be_truthy }
    end

    context "and used in an intervention" do

      before { make_intervention_with_firemen(:firemen => [fireman_with_grades],
                                              :station => station) }

      it { should be_falsey }
    end

    context "and not used in a convocation" do

      it { should be_truthy }
    end

    context "and used in a convocation" do

      before { make_convocation_with_firemen(:firemen => [fireman_with_grades],
                                             :station => station) }

      it { should be_falsey }
    end

    context "and no trainings" do

      it { should be_truthy }
    end

    context "and a training" do

      before { fireman_with_grades.fireman_trainings
                                  .create(:achieved_at => Date.today,
                                          :training_id => station.trainings.make!.id) }

      it { should be_falsey }
    end
  end

  describe ".valid?" do

    context "not JSP and no grade" do

      it "is false" do
        expect(fireman.valid?).to be_falsey
      end
    end

    context "not JSP and a grade" do

      subject { fireman_with_grades.valid? }

      context "intervention_editable_at will not be updated" do

        before(:each) do
          allow_any_instance_of(Station).to receive(:confirm_intervention_editable_at?).and_return(false)
        end

        it { should be_truthy }
      end

      before(:each) do
        allow_any_instance_of(Station).to receive(:confirm_intervention_editable_at?).and_return(true)
      end

      context "intervention_editable_at will be updated but validate_grade_update is not set" do

        before do
          fireman_with_grades.validate_grade_update = nil
        end

        it { should be_falsey }
      end

      context "intervention_editable_at will be updated but validate_grade_update is set" do

        before do
          fireman_with_grades.validate_grade_update = 1
        end

        it { should be_truthy }
      end
    end
  end
end
