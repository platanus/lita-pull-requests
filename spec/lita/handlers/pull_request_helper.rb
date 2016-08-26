require "spec_helper"
require "pry"
require_relative "./../../../lib/lita/handlers/pull_request_helper.rb"

describe PullRequestHelper do
  let(:username) { "blackjid" }
  let(:helper) { described_class.new(username) }

  describe "retrieve" do
    context "with valid credentials" do
      it "should retrieve a list of open pull requests" do
        helper.retrieve
        
      end
    end

    context "with invalid credentials" do
      it "should complain about the credentials" do

      end
    end
  end
end
