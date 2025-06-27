<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use App\Models\Feedback;

class FeedbackResponseNotification extends Notification implements ShouldQueue
{
    use Queueable;

    protected $feedback;

    /**
     * Create a new notification instance.
     */
    public function __construct(Feedback $feedback)
    {
        $this->feedback = $feedback;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['database', 'mail'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail(object $notifiable): MailMessage
    {
        $category = $this->getCategoryDisplayName($this->feedback->category);
        
        return (new MailMessage)
            ->subject('Response to your feedback - Verdex')
            ->greeting('Hello ' . ($notifiable->name ?? 'there') . '!')
            ->line('We have responded to your feedback submitted on ' . $this->feedback->created_at->format('M d, Y') . '.')
            ->line('**Category:** ' . $category)
            ->line('**Your feedback:** ' . $this->feedback->message)
            ->line('**Our response:** ' . $this->feedback->comment)
            ->action('View in App', url('/settings/notifications'))
            ->line('Thank you for helping us improve Verdex!')
            ->salutation('Best regards, The Verdex Team');
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
            'id' => $this->id,
            'type' => 'feedback_response',
            'title' => 'Response to your feedback',
            'message' => 'We have responded to your feedback about ' . $this->getCategoryDisplayName($this->feedback->category),
            'feedback_id' => $this->feedback->id,
            'feedback_category' => $this->feedback->category,
            'feedback_message' => $this->feedback->message,
            'response' => $this->feedback->comment,
            'submitted_at' => $this->feedback->created_at->toISOString(),
            'responded_at' => $this->feedback->updated_at->toISOString(),
            'read_at' => null,
        ];
    }

    /**
     * Get the database representation of the notification.
     */
    public function toDatabase(object $notifiable): array
    {
        return $this->toArray($notifiable);
    }

    /**
     * Get the category display name
     */
    private function getCategoryDisplayName($category): string
    {
        $categories = [
            'general_feedback' => 'General Feedback',
            'bug_report' => 'Bug Report',
            'feature_request' => 'Feature Request',
            'plant_identification' => 'Plant Identification',
            'user_interface' => 'User Interface',
            'performance' => 'Performance',
            'other' => 'Other'
        ];

        return $categories[$category] ?? $category;
    }
} 