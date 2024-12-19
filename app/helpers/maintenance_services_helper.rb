module MaintenanceServicesHelper
  def maintenance_service_status_badge(status)
    content_tag(:div, class: "badge #{maintenance_service_status_color(status)}") do
      I18n.t("activerecord.attributes.maintenance_service.status_options.#{status}")
    end
  end

  def maintenance_service_status_color(status)
    {
      "pending" => "badge-neutral",
      "in_progress" => "badge-primary",
      "completed" => "badge-success"
    }[status]
  end
end
