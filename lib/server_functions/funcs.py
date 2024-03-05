def send_notification(data, context):
  """Sends a notification when a new document is added to the database."""

  # Get the notification title and body.
  title = data['title']
  body = data['body']

  # Send the notification.
  fcm.send_message(
      to='/topics/all',
      notification={
          'title': title,
          'body': body,
      })