require 'rails_helper'

describe FiremenHelper do

  describe "#grade_and_name with object" do

    subject { grade_and_name(fireman: fireman) }

    context "with grade" do

      let(:fireman) { create(:fireman, :status    => Fireman::STATUS['JSP'],
                                       :grade     => Grade::GRADE['JSP 1'],
                                       :firstname => 'foo',
                                       :lastname  => 'bar') }

      it { should == "JSP 1 foo bar" }
    end

    context "without grade" do

      let(:fireman) { Fireman.new(:firstname => 'foo',
                                  :lastname  => 'bar') }

      it { should == "foo bar" }
    end
  end

  describe "#grade_and_name with attributes" do

    subject { grade_and_name(firstname: 'foo', lastname: 'bar', grade: grade) }

    context "with grade" do

      let(:grade) { Grade::GRADE['JSP 1'] }

      it { should == "JSP 1 foo bar" }
    end

    context "without grade" do

      let(:grade) { nil }

      it { should == "foo bar" }
    end
  end

  describe "#active_accordion" do

    subject { active_accordion(fireman) }

    let(:fireman) { Fireman.new }

    context "without grade" do

      it { should == 4 }
    end

    context "with grade of Medecin category" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:current_grade).and_return(Grade.new(:kind => Grade::GRADE['Médecin capitaine']))
      end

      it { should == 0 }
    end

    context "with grade of Infirmier category" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:current_grade).and_return(Grade.new(:kind => Grade::GRADE['Infirmier chef']))
      end

      it { should == 1 }
    end

    context "with grade of Officier category" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:current_grade).and_return(Grade.new(:kind => Grade::GRADE['Capitaine']))
      end

      it { should == 2 }
    end

    context "with grade of Sous-officier category" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:current_grade).and_return(Grade.new(:kind => Grade::GRADE['Sergent']))
      end

      it { should == 3 }
    end

    context "with grade of Homme du rang category" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:current_grade).and_return(Grade.new(:kind => Grade::GRADE['Caporal']))
      end

      it { should == 4 }
    end

    context "with grade of JSP category" do

      before(:each) do
        allow_any_instance_of(Fireman).to receive(:current_grade).and_return(Grade.new(:kind => Grade::GRADE['JSP 3']))
      end

      it { should == 5 }
    end
  end

  describe "#ratio_interventions" do

    subject { ratio_interventions(nb_interventions, total) }

    context "with no interventions" do

      let(:total) { 0 }
      let(:nb_interventions) { 12 }

      it { should == 0 }
    end

    context "with interventions" do

      let(:total) { 12 }
      let(:nb_interventions) { 6 }

      it { should == 50 }
    end
  end
end
