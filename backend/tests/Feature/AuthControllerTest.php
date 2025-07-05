<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AuthControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register_with_valid_data()
    {
        $userData = [
            'name' => 'testuser123',
            'email' => 'test@example.com',
            'password' => 'Password123',
            'password_confirmation' => 'Password123',
        ];

        $response = $this->postJson('/api/register', $userData);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'access_token',
                'token_type',
                'user' => [
                    'id',
                    'username',
                    'email',
                    'created_at',
                    'updated_at',
                ],
            ]);

        $this->assertDatabaseHas('users', [
            'username' => 'testuser123',
            'email' => 'test@example.com',
        ]);
    }

    public function test_user_cannot_register_with_invalid_data()
    {
        $userData = [
            'name' => 'short',
            'email' => 'invalid-email',
            'password' => 'weak',
            'password_confirmation' => 'different',
        ];

        $response = $this->postJson('/api/register', $userData);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['name', 'email', 'password']);
    }

    public function test_user_cannot_register_with_duplicate_email()
    {
        User::factory()->create(['email' => 'test@example.com']);

        $userData = [
            'name' => 'testuser123',
            'email' => 'test@example.com',
            'password' => 'Password123',
            'password_confirmation' => 'Password123',
        ];

        $response = $this->postJson('/api/register', $userData);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['email']);
    }

    public function test_user_can_login_with_valid_credentials()
    {
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => Hash::make('Password123'),
        ]);

        $loginData = [
            'login' => 'test@example.com',
            'password' => 'Password123',
        ];

        $response = $this->postJson('/api/login', $loginData);

        $response->assertStatus(200)
            ->assertJsonStructure([
                'access_token',
                'token_type',
                'user' => [
                    'id',
                    'username',
                    'email',
                ],
            ]);
    }

    public function test_user_can_login_with_username()
    {
        $user = User::factory()->create([
            'username' => 'testuser',
            'password' => Hash::make('Password123'),
        ]);

        $loginData = [
            'login' => 'testuser',
            'password' => 'Password123',
        ];

        $response = $this->postJson('/api/login', $loginData);

        $response->assertStatus(200)
            ->assertJsonStructure([
                'access_token',
                'token_type',
                'user',
            ]);
    }

    public function test_user_cannot_login_with_invalid_credentials()
    {
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => Hash::make('Password123'),
        ]);

        $loginData = [
            'login' => 'test@example.com',
            'password' => 'wrongpassword',
        ];

        $response = $this->postJson('/api/login', $loginData);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['login']);
    }

    public function test_user_can_logout()
    {
        $user = User::factory()->create();
        $token = $user->createToken('test-token')->plainTextToken;

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->postJson('/api/logout');

        $response->assertStatus(200)
            ->assertJson(['message' => 'Logged out successfully']);

        // Verify token is deleted
        $this->assertDatabaseMissing('personal_access_tokens', [
            'tokenable_id' => $user->id,
        ]);
    }

    public function test_unauthenticated_user_cannot_logout()
    {
        $response = $this->postJson('/api/logout');

        $response->assertStatus(401);
    }
} 