<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Spatie\Permission\Models\Role;

class NormalUserSeeder extends Seeder
{
    public function run(): void
    {
        $user = User::firstOrCreate(
            [
                'username' => 'prime',
            ],
            [
                'email' => 'primerenny@gmail.com',
                'password' => bcrypt('Prime123'),
                'email_verified_at' => now(),
            ]
        );
        $role = Role::firstOrCreate(['name' => 'user']);
        if (!$user->hasRole('user')) {
            $user->assignRole($role);
        }
    }
} 