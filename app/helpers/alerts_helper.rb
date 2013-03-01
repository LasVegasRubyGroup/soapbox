module AlertsHelper
  @@alert_classes = {
    error: 'alert-error',
    success: 'alert-success',
    info: 'alert-info'
  }

  def alert_box(message, type=:notice)
    classes = @@alert_classes.values_at(type.to_sym).compact
    render(partial: 'shared/alert_box', locals: {
      message: message,
      classes: classes
    })
  end
end
