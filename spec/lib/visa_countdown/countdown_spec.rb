# frozen_string_literal: true

describe VisaCountdown::Countdown do
  describe "Situation: inside_ok" do
    context "with no trip overlaping 180 days ago" do
      let(:first_period)  { {first_day: Date.today - 50, last_day: Date.today - 40} }
      let(:second_period) { {first_day: Date.today - 30, last_day: Date.today - 20} }
      let(:latest_entry)  { Date.today - 10 }

      subject { described_class.new(periods: [first_period, second_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("inside_ok")
      end

      it "returns the correct time spent" do
        expect(subject.time_spent).to eq(33)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(57)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 57)
      end
    end

    context "with 1 trip overlaping 180 days ago" do
      let(:first_period) { {first_day: Date.today - 185, last_day: Date.today - 105} }
      let(:latest_entry) { Date.today - 10 }

      subject { described_class.new(periods: [first_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("inside_ok")
      end

      it "returns the correct time spent" do
        expect(subject.time_spent).to eq(86)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(79)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 79)
      end
    end

    context "with today inside a period, latest entry after this period" do
      let(:first_period) { {first_day: Date.today - 39, last_day: Date.today + 10} }
      let(:latest_entry) { Date.today + 20 }

      subject { described_class.new(periods: [first_period], latest_entry: latest_entry) }


      it "returns the correct situation" do
        expect(subject.situation).to eq("inside_ok")
      end

      it "returns the correct time spent" do
        expect(subject.time_spent).to eq(40)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(40)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 59)
      end
    end

    context "inside a period, no latest entry" do
      let(:first_period) { {first_day: Date.today - 39, last_day: Date.today + 10} }

      subject { described_class.new(periods: [first_period]) }


      it "returns the correct situation" do
        expect(subject.situation).to eq("inside_ok")
      end

      it "returns the correct time spent" do
        expect(subject.time_spent).to eq(40)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(40)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 50)
      end
    end
  end

  describe "Situation: outside_ok" do
    context "with latest entry in the future" do
      let(:first_period) { {first_day: Date.today - 98, last_day: Date.today - 11} }
      let(:latest_entry) { Date.today + 1 }

      subject { described_class.new(periods: [first_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("outside_ok")
      end

      it "returns the correct time spent" do
        expect(subject.time_spent).to eq(88)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(2)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 2)
      end
    end

    context "without any latest entry" do
      let(:first_period) { {first_day: Date.today - 50, last_day: Date.today - 11} }

      subject { described_class.new(periods: [first_period]) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("outside_ok")
      end

      it "returns the correct time spent" do
        expect(subject.time_spent).to eq(40)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(50)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 50)
      end
    end
  end

  describe "Situation: overstay" do
    context "latest entry earlier than 90 days ago" do
      let(:first_period) { {first_day: Date.today - 120, last_day: Date.today - 100} }
      let(:latest_entry) { Date.today - 90 }

      subject { described_class.new(periods: [first_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("overstay")
      end

      it "returns the correct time spent" do
        expect(subject.time_spent).to eq(112)
      end
    end

    context "in the middle of a period longer than 90 days" do
      let(:first_period)  { {first_day: Date.today - 95, last_day: Date.today + 5} }

      subject { described_class.new(periods: [first_period]) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("overstay")
      end

      it "returns the correct time spent" do
        expect(subject.time_spent).to eq(96)
      end
    end
  end

  describe "Situation: current_too_long" do
    context "with latest entry in the future" do
      let(:first_period) { {first_day: Date.today - 80, last_day: Date.today + 15} }
      let(:latest_entry) { Date.today + 30 }

      subject { described_class.new(periods: [first_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("current_too_long")
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(9)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 9)
      end
    end

    context "without any latest entry" do
      let(:first_period)  { {first_day: Date.today - 80, last_day: Date.today + 15} }

      subject { described_class.new(periods: [first_period]) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("current_too_long")
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(9)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 9)
      end
    end
  end

  describe "Situation: one_next_too_long" do
    context "with latest entry in the future" do
      let(:first_period)  { {first_day: Date.today - 80, last_day: Date.today -  5} }
      let(:second_period) { {first_day: Date.today +  5, last_day: Date.today + 25} }
      let(:latest_entry)  { Date.today + 30 }

      subject { described_class.new(periods: [first_period, second_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("one_next_too_long")
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(14)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 18)
      end
    end

    context "without any latest entry" do
      let(:first_period)  { {first_day: Date.today - 80, last_day: Date.today -  5} }
      let(:second_period) { {first_day: Date.today +  5, last_day: Date.today + 25} }

      subject { described_class.new(periods: [first_period, second_period]) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("one_next_too_long")
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(14)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 18)
      end
    end
  end

  describe "Situation: quota_will_be_used_can_enter" do
    context "User in zone, in the middle of a period" do
      let(:first_period) { {first_day: Date.today - 80, last_day: Date.today + 9} }
      let(:latest_entry) { Date.today + 120 }

      subject { described_class.new(periods: [first_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("quota_will_be_used_can_enter")
      end

      it "returns the correct day the quota is achieved" do
        expect(subject.quota_day).to eq(Date.today + 9)
      end

      it "returns the correct next entry date" do
        expect(subject.next_entry).to eq(Date.today + 100)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(90)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 209)
      end
    end

    context "User out of zone, one next period will use quota" do
      let(:first_period)  { {first_day: Date.today - 79, last_day: Date.today - 10} }
      let(:second_period) { {first_day: Date.today +  5, last_day: Date.today + 24} }
      let(:latest_entry)  { Date.today + 120 }

      subject { described_class.new(periods: [first_period, second_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("quota_will_be_used_can_enter")
      end

      it "returns the correct day the quota is achieved" do
        expect(subject.quota_day).to eq(Date.today + 24)
      end

      it "returns the correct next entry date" do
        expect(subject.next_entry).to eq(Date.today + 101)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(90)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 209)
      end
    end
  end

  describe "Situation: quota_will_be_used_cannot_enter" do
    context "User in zone, in the middle of a period" do
      let(:first_period) { {first_day: Date.today - 80, last_day: Date.today + 9} }
      let(:latest_entry) { Date.today + 60 }

      subject { described_class.new(periods: [first_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("quota_will_be_used_cannot_enter")
      end

      it "returns the correct day the quota is achieved" do
        expect(subject.quota_day).to eq(Date.today + 9)
      end

      it "returns the correct next entry date" do
        expect(subject.next_entry).to eq(Date.today + 100)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(90)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 189)
      end
    end

    context "User out of zone, one next period will use quota" do
      let(:first_period)  { {first_day: Date.today - 89, last_day: Date.today - 20} }
      let(:second_period) { {first_day: Date.today +  5, last_day: Date.today + 24} }
      let(:latest_entry)  { Date.today + 60 }

      subject { described_class.new(periods: [first_period, second_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("quota_will_be_used_cannot_enter")
      end

      it "returns the correct day the quota is achieved" do
        expect(subject.quota_day).to eq(Date.today + 24)
      end

      it "returns the correct next entry date" do
        expect(subject.next_entry).to eq(Date.today + 91)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(70)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 160)
      end
    end
  end

  describe "Situation: quota_will_be_used_no_entry" do
    context "User in zone, in the middle of a period" do
      let(:first_period) { {first_day: Date.today - 80, last_day: Date.today + 9} }

      subject { described_class.new(periods: [first_period]) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("quota_will_be_used_no_entry")
      end

      it "returns the correct day the quota is achieved" do
        expect(subject.quota_day).to eq(Date.today + 9)
      end

      it "returns the correct next entry date" do
        expect(subject.next_entry).to eq(Date.today + 100)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(90)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 189)
      end
    end

    context "User out of zone, one next period will use quota" do
      let(:first_period)  { {first_day: Date.today - 89, last_day: Date.today - 20} }
      let(:second_period) { {first_day: Date.today +  5, last_day: Date.today + 24} }

      subject { described_class.new(periods: [first_period, second_period]) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("quota_will_be_used_no_entry")
      end

      it "returns the correct day the quota is achieved" do
        expect(subject.quota_day).to eq(Date.today + 24)
      end

      it "returns the correct next entry date" do
        expect(subject.next_entry).to eq(Date.today + 91)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(70)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 160)
      end
    end
  end

  describe "Situation: quota_used_can_enter" do
    let(:first_period) { {first_day: Date.today - 109, last_day: Date.today - 20} }
    let(:latest_entry) { Date.today + 100 }

    subject { described_class.new(periods: [first_period], latest_entry: latest_entry) }

    it "returns the correct situation" do
      expect(subject.situation).to eq("quota_used_can_enter")
    end

    it "returns the correct day the quota is achieved" do
      expect(subject.quota_day).to eq(Date.today - 20)
    end

    it "returns the correct next entry date" do
      expect(subject.next_entry).to eq(Date.today + 71)
    end

    it "returns the correct remaining time" do
      expect(subject.remaining_time).to eq(90)
    end

    it "returns the correct exit day" do
      expect(subject.exit_day).to eq(Date.today + 189)
    end
  end

  describe "Situation: quota_used_cannot_enter" do
    let(:first_period) { {first_day: Date.today - 109, last_day: Date.today - 20} }
    let(:latest_entry) { Date.today + 10 }

    subject { described_class.new(periods: [first_period], latest_entry: latest_entry) }

    it "returns the correct situation" do
      expect(subject.situation).to eq("quota_used_cannot_enter")
    end

    it "returns the correct day the quota is achieved" do
      expect(subject.quota_day).to eq(Date.today - 20)
    end

    it "returns the correct next entry date" do
      expect(subject.next_entry).to eq(Date.today + 71)
    end

    it "returns the correct remaining time" do
      expect(subject.remaining_time).to eq(90)
    end

    it "returns the correct exit day" do
      expect(subject.exit_day).to eq(Date.today + 160)
    end
  end

  describe "Situation: quota_used_no_entry" do
    let(:first_period) { {first_day: Date.today - 109, last_day: Date.today - 20} }

    subject { described_class.new(periods: [first_period]) }

    it "returns the correct situation" do
      expect(subject.situation).to eq("quota_used_no_entry")
    end

    it "returns the correct day the quota is achieved" do
      expect(subject.quota_day).to eq(Date.today - 20)
    end

    it "returns the correct next entry date" do
      expect(subject.next_entry).to eq(Date.today + 71)
    end

    it "returns the correct remaining time" do
      expect(subject.remaining_time).to eq(90)
    end

    it "returns the correct exit day" do
      expect(subject.exit_day).to eq(Date.today + 160)
    end
  end

  describe "QA tester trying stuff" do
    context "latest entry in the middle of a period" do
      let(:first_period)  { {first_day: Date.today - 84, last_day: Date.today - 25} }
      let(:second_period) { {first_day: Date.today - 14, last_day: Date.today -  5} }
      let(:latest_entry)  { Date.today - 9 }

      subject { described_class.new(periods: [first_period, second_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("inside_ok")
      end

      it "returns the correct time spent" do
        expect(subject.time_spent).to eq(75)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(15)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 15)
      end
    end

    context "latest entry before a full period" do
      let(:first_period)  { {first_day: Date.today - 84, last_day: Date.today - 25} }
      let(:second_period) { {first_day: Date.today -  4, last_day: Date.today + 50} }
      let(:latest_entry)  { Date.today - 9 }

      subject { described_class.new(periods: [first_period, second_period], latest_entry: latest_entry) }

      it "returns the correct situation" do
        expect(subject.situation).to eq("inside_ok")
      end

      it "returns the correct time spent" do
        expect(subject.time_spent).to eq(70)
      end

      it "returns the correct remaining time" do
        expect(subject.remaining_time).to eq(20)
      end

      it "returns the correct exit day" do
        expect(subject.exit_day).to eq(Date.today + 20)
      end
    end
  end
end
