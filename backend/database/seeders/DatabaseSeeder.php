<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call(PermissionTableSeeder::class);
        $this->call(CreateAdminUserSeeder::class);
        $this->call(RoleSeeder::class);
        $this->call(NormalUserSeeder::class);
        $this->call(LanguageSeeder::class);
        $this->call(PlantCategorySeeder::class);
        $this->call(PlantSeeder::class);
    }
}
