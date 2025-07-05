<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Feedback;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class FeedbackControllerTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $token;

    protected function setUp(): void
    {
        parent::setUp();
        $this->user = User::factory()->create();
        $this->token = $this->user->createToken('test-token')->plainTextToken;
    }

    public function test_user_can_submit_feedback()
    {
        $feedbackData = [
            'message' => 'This is a test feedback message',
            'category' => 'bug',
            'rating' => 4,
            'contact' => 'test@example.com',
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/feedback', $feedbackData);

        $response->assertStatus(201)
            ->assertJson([
                'success' => true,
                'data' => [
                    'message' => 'This is a test feedback message',
                    'category' => 'bug',
                    'rating' => 4,
                ]
            ]);

        $this->assertDatabaseHas('feedback', [
            'user_id' => $this->user->id,
            'message' => 'This is a test feedback message',
            'category' => 'bug',
            'rating' => 4,
        ]);
    }

    public function test_user_can_submit_feedback_with_minimal_data()
    {
        $feedbackData = [
            'message' => 'This is a test feedback message',
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/feedback', $feedbackData);

        $response->assertStatus(201)
            ->assertJson([
                'success' => true,
                'data' => [
                    'message' => 'This is a test feedback message',
                ]
            ]);
    }

    public function test_feedback_has_correct_status()
    {
        $feedback = Feedback::factory()->create([
            'user_id' => $this->user->id,
            'comment' => null,
        ]);

        $this->assertEquals('pending', $feedback->status);

        $feedback->update(['comment' => 'Admin response']);
        $this->assertEquals('responded', $feedback->status);
    }

    public function test_feedback_rating_text_is_correct()
    {
        $feedback = Feedback::factory()->create([
            'rating' => 5,
        ]);

        $this->assertEquals('Excellent', $feedback->rating_text);

        $feedback->update(['rating' => 1]);
        $this->assertEquals('Poor', $feedback->rating_text);
    }

    public function test_feedback_belongs_to_user()
    {
        $feedback = Feedback::factory()->create([
            'user_id' => $this->user->id,
        ]);

        $this->assertEquals($this->user->id, $feedback->user->id);
    }

    public function test_feedback_can_belong_to_plant()
    {
        $plant = \App\Models\Plant::factory()->create();
        $feedback = Feedback::factory()->create([
            'plant_id' => $plant->id,
        ]);

        $this->assertEquals($plant->id, $feedback->plant->id);
    }

    public function test_unauthenticated_user_cannot_submit_feedback()
    {
        $feedbackData = [
            'message' => 'This is a test feedback message',
            'category' => 'bug',
        ];

        $response = $this->postJson('/api/feedback', $feedbackData);

        $response->assertStatus(401);
    }

    public function test_feedback_validation_works_correctly()
    {
        $invalidData = [
            'rating' => 10, // Invalid rating (should be 1-5)
        ];

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->token,
        ])->postJson('/api/feedback', $invalidData);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['rating']);
    }
} 