<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use App\Models\Feedback;

class FeedbackSubmittedNotification extends Notification implements ShouldQueue
{
    use Queueable;

    protected $feedback;

    public function __construct(Feedback $feedback)
    {
        $this->feedback = $feedback;
    }

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        return [
            'type' => 'feedback_submitted',
            'title' => 'Feedback Received',
            'message' => 'Thank you for your feedback! We have received your message and will review it soon.',
            'feedback_id' => $this->feedback->id,
            'category' => $this->feedback->category,
            'submitted_at' => $this->feedback->created_at->toISOString(),
        ];
    }
} 