@component('mail::message')
# Password Reset Request

Hi {{ $user->name ?? $user->username ?? 'there' }},

We received a request to reset your Verdex account password. Here is your **temporary password**:

@component('mail::panel')
## {{ $tempPassword }}
@endcomponent

**This password will expire at {{ $expiresAt->format('H:i A, M d, Y') }} (in 1 hour).**

---

**How to use your temporary password:**
1. Open the Verdex app or website.
2. Log in with your username/email and the temporary password above.
3. You will be prompted to set a new password for your account.

If you did not request this, you can safely ignore this email.

Thanks for using Verdex!

@component('mail::subcopy')
If you're having trouble, contact our support team.
@endcomponent

Regards,<br>
{{ config('app.name') }} Team
@endcomponent
