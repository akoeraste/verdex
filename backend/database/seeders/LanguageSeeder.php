<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class LanguageSeeder extends Seeder
{
    public function run(): void
    {
        $languages = [
            ['code' => 'en', 'name' => 'English'],
            ['code' => 'fr', 'name' => 'French'],
            ['code' => 'pg', 'name' => 'Pidgin'],
            ['code' => 'gm', 'name' => 'Ngombale'],
            ['code' => 'bm', 'name' => 'Bambili'],
        ];
        foreach ($languages as $lang) {
            DB::table('languages')->updateOrInsert(
                ['code' => $lang['code']],
                ['name' => $lang['name']]
            );
        }
    }
} 