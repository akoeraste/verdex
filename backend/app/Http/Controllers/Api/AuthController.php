<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'login' => 'required|string',
            'password' => 'required',
        ]);

        $login = $request->login;
        $field = filter_var($login, FILTER_VALIDATE_EMAIL) ? 'email' : 'username';
        $user = User::where($field, $login)->first();

        if (! $user) {
            throw ValidationException::withMessages([
                'login' => ['The provided credentials are not correct.'],
            ]);
        }

        $usedTempPass = false;
        // Check if temp_pass is set and not expired
        if ($user->temp_pass && $user->temp_pass_created_at && now()->diffInMinutes($user->temp_pass_created_at) <= 60) {
            if (Hash::check($request->password, $user->temp_pass)) {
                $usedTempPass = true;
                // Clear temp_pass after use
                $user->temp_pass = null;
                $user->temp_pass_created_at = null;
                $user->save();
            }
        }

        // If not using temp_pass, check main password
        if (!$usedTempPass && !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'login' => ['The provided credentials are not correct.'],
            ]);
        }

        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user,
            'used_temp_pass' => $usedTempPass,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logged out successfully']);
    }

    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|min:6|max:255|unique:users,username',
            'email' => 'required|email|unique:users,email',
            'password' => [
                'required',
                'string',
                'min:6',
                'confirmed',
                'regex:/[A-Z]/', // at least one capital letter
                'regex:/[0-9]/', // at least one number
            ],
        ], [
            'name.min' => 'Username must be at least 6 characters.',
            'name.unique' => 'Username already taken.',
            'password.regex' => 'Password must contain at least one number and one capital letter.',
        ]);

        $user = User::create([
            'username' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'avatar' => '/storage/avatars/default.png',
        ]);

        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user
        ], 201);
    }
} 