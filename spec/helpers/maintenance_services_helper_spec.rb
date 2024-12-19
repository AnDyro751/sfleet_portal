require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MaintenanceServicesHelperHelper. For example:
#
# describe MaintenanceServicesHelperHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MaintenanceServicesHelper, type: :helper do
  describe "maintenance_service_status_badge" do
    it "returns a badge with the correct class for a pending status" do
      expect(helper.maintenance_service_status_badge("pending")).to eq("<div class=\"badge badge-neutral\">#{I18n.t("activerecord.attributes.maintenance_service.status_options.pending")}</div>")
    end

    it "returns a badge with the correct class for an in_progress status" do
      expect(helper.maintenance_service_status_badge("in_progress")).to eq("<div class=\"badge badge-primary\">#{I18n.t("activerecord.attributes.maintenance_service.status_options.in_progress")}</div>")
    end

    it "returns a badge with the correct class for a completed status" do
      expect(helper.maintenance_service_status_badge("completed")).to eq("<div class=\"badge badge-success\">#{I18n.t("activerecord.attributes.maintenance_service.status_options.completed")}</div>")
    end
  end
end
