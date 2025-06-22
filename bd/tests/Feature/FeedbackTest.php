<?php

namespace Tests\Feature;

use App\Models\Plant;
use App\Models\User;
use App\Models\Feedback;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class FeedbackTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $user;
    protected $plant;
    protected $token;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::factory()->create();
        $this->plant = Plant::factory()->create();
        $this->token = $this->user->createToken('test-token')->plainTextToken;
    }

    public function test_user_can_submit_feedback()
    {
        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson('/api/feedback', [
                'plant_id' => $this->plant->id,
                'is_correct' => true,
                'comment' => 'Great identification!'
            ]);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'id',
                'user_id',
                'plant_id',
                'is_correct',
                'comment',
                'created_at',
                'updated_at'
            ]);

        $this->assertDatabaseHas('feedback', [
            'user_id' => $this->user->id,
            'plant_id' => $this->plant->id,
            'is_correct' => true,
            'comment' => 'Great identification!'
        ]);
    }

    public function test_can_submit_anonymous_feedback()
    {
        $response = $this->postJson('/api/feedback', [
            'plant_id' => $this->plant->id,
            'is_correct' => false,
            'comment' => 'Wrong identification'
        ]);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'id',
                'plant_id',
                'is_correct',
                'comment',
                'created_at',
                'updated_at'
            ]);

        $this->assertDatabaseHas('feedback', [
            'user_id' => null,
            'plant_id' => $this->plant->id,
            'is_correct' => false,
            'comment' => 'Wrong identification'
        ]);
    }

    public function test_can_list_feedback()
    {
        // Create some feedback entries
        Feedback::factory()->count(3)->create([
            'plant_id' => $this->plant->id
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->getJson('/api/feedback');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'user_id',
                        'plant_id',
                        'is_correct',
                        'comment',
                        'plant' => [
                            'id',
                            'slug',
                            'scientific_name'
                        ],
                        'created_at'
                    ]
                ],
                'meta' => [
                    'current_page',
                    'from',
                    'last_page',
                    'per_page',
                    'to',
                    'total'
                ]
            ])
            ->assertJsonCount(3, 'data');
    }

    public function test_can_filter_feedback_by_correctness()
    {
        // Create feedback entries with different correctness values
        Feedback::factory()->create([
            'plant_id' => $this->plant->id,
            'is_correct' => true
        ]);
        Feedback::factory()->create([
            'plant_id' => $this->plant->id,
            'is_correct' => false
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->getJson('/api/feedback?is_correct=true');

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.is_correct', true);
    }

    public function test_can_get_feedback_statistics()
    {
        // Create feedback entries with different characteristics
        Feedback::factory()->create([
            'plant_id' => $this->plant->id,
            'is_correct' => true,
            'comment' => 'Great!'
        ]);
        Feedback::factory()->create([
            'plant_id' => $this->plant->id,
            'is_correct' => false
        ]);
        Feedback::factory()->create([
            'plant_id' => $this->plant->id,
            'is_correct' => true
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->getJson('/api/feedback/stats');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'total',
                'correct',
                'incorrect',
                'with_comments'
            ])
            ->assertJson([
                'total' => 3,
                'correct' => 2,
                'incorrect' => 1,
                'with_comments' => 1
            ]);
    }

    public function test_cannot_submit_feedback_for_nonexistent_plant()
    {
        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson('/api/feedback', [
                'plant_id' => 99999,
                'is_correct' => true
            ]);

        $response->assertStatus(404);
    }

    public function test_cannot_submit_feedback_without_required_fields()
    {
        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson('/api/feedback', [
                'is_correct' => true
            ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['plant_id']);
    }
}
