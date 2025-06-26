<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\SendsPasswordResetEmails;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\Models\User;
use App\Mail\TempPasswordMail;

class ForgotPasswordController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Password Reset Controller
    |--------------------------------------------------------------------------
    |
    | This controller is responsible for handling password reset emails and
    | includes a trait which assists in sending these notifications from
    | your application to your users. Feel free to explore this trait.
    |
    */

    use SendsPasswordResetEmails;

    public function sendTempPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
        ]);

        $user = User::where('email', $request->email)->first();
        if (!$user) {
            return response()->json(['message' => 'User not found.'], 404);
        }

        $tempPassword = Str::random(10);
        $user->temp_pass = Hash::make($tempPassword);
        $user->temp_pass_created_at = now();
        $user->save();

        $expiresAt = now()->addHour();
        // Send beautiful email with the temp password
        Mail::to($user->email)->send(new TempPasswordMail($user, $tempPassword, $expiresAt));

        return response()->json(['message' => 'A temporary password has been sent to your email.'], 200);
    }
}
