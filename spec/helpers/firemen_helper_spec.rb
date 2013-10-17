require 'spec_helper'

describe FiremenHelper do

  describe "#grade_and_name" do

    subject { grade_and_name(fireman) }

    context "with grade" do

      let(:fireman) { make_fireman_with_grades(:station   => Station.make,
                                               :firstname => 'foo',
                                               :lastname  => 'bar') }

      it { should == "2e classe foo bar" }
    end

    context "without grade" do

      let(:fireman) { Fireman.new(:firstname => 'foo',
                                  :lastname  => 'bar') }

      it { should == "foo bar" }
    end
  end

  describe "#style_for_grades" do

    subject { style_for_grades(fireman) }

    context "with status JSP" do

      let(:fireman) { Fireman.new(:status => 1) }

      it { should == "display:none;" }
    end

    context "with other status" do

      let(:fireman) { Fireman.new(:status => 0) }

      it { should == "" }
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
  end
end
