shared_examples_for "a continuous integration server" do

  describe "constructor" do

    subject { server }

    it "creates a http object with any provided http configuration options" do
      expect(BuildEval::Http).to receive(:new).with(constructor_args)

      subject
    end

  end

end
