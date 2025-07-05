<?php

namespace Tests\Unit;

use App\Models\User;
use App\Models\Plant;
use App\Models\Favorite;
use App\Models\Feedback;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_be_created_with_valid_attributes()
    {
        $user = User::factory()->create([
            'username' => 'testuser',
            'email' => 'test@example.com',
            'password' => bcrypt('password'),
            'language_preference' => 'en',
        ]);

        $this->assertDatabaseHas('users', [
            'username' => 'testuser',
            'email' => 'test@example.com',
            'language_preference' => 'en',
        ]);
    }

    public function test_user_has_fillable_attributes()
    {
        $user = new User();
        $fillable = $user->getFillable();

        $this->assertContains('username', $fillable);
        $this->assertContains('email', $fillable);
        $this->assertContains('password', $fillable);
        $this->assertContains('language_preference', $fillable);
        $this->assertContains('avatar', $fillable);
    }

    public function test_user_has_hidden_attributes()
    {
        $user = new User();
        $hidden = $user->getHidden();

        $this->assertContains('password', $hidden);
        $this->assertContains('remember_token', $hidden);
    }

    public function test_user_has_correct_casts()
    {
        $user = new User();
        $casts = $user->getCasts();

        $this->assertEquals('datetime', $casts['email_verified_at']);
    }

    public function test_user_can_have_favorites()
    {
        $user = User::factory()->create();
        $plant = Plant::factory()->create();
        
        $favorite = Favorite::factory()->create([
            'user_id' => $user->id,
            'plant_id' => $plant->id,
        ]);

        $this->assertTrue($user->favorites->contains($favorite));
    }

    public function test_user_can_have_feedback()
    {
        $user = User::factory()->create();
        $feedback = Feedback::factory()->create([
            'user_id' => $user->id,
        ]);

        $this->assertTrue($user->feedback->contains($feedback));
    }

    public function test_user_has_required_traits()
    {
        $user = User::factory()->create();
        
        // Test that user has the required traits
        $this->assertTrue(method_exists($user, 'roles'));
        $this->assertTrue(method_exists($user, 'createToken'));
        $this->assertTrue(method_exists($user, 'getActivitylogOptions'));
    }

    public function test_user_can_create_api_token()
    {
        $user = User::factory()->create();
        $token = $user->createToken('test-token');
        
        $this->assertNotNull($token);
        $this->assertNotNull($token->plainTextToken);
    }
} 