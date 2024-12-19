require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  it "default_queue_name" do
    expect(ApplicationJob.queue_name.class).to eq(Proc)
  end
end
