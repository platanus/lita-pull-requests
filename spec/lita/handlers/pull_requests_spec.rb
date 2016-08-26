require "spec_helper"
require "pry"

describe Lita::Handlers::PullRequests, lita_handler: true do
  let(:username) { "blackjid" }
  let(:user) { Lita::User.create(1, name: "Poll User") }

  describe "show" do
    context "with a valid username" do
      it "should display a list of pull requests" do
        send_command("pr show #{username}", as: user)
        expect(replies.size).to eq(1)
      end
    end

    context "without an invalid username" do
      it "should display an error message" do
        send_command("pr show @#{username}", as: user)
        expect(replies.first).to eq(described_class::translate("commands.show.error"))
      end
    end
  end
end
