<?php

namespace App\Policies;

use App\Models\Feedback;
use App\Models\User;

class FeedbackPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return $user->hasRole('admin') || $user->hasPermissionTo('view feedback');
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Feedback $feedback): bool
    {
        return $user->hasRole('admin') || $user->hasPermissionTo('view feedback');
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return true; // Any authenticated user can create feedback
    }

    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Feedback $feedback): bool
    {
        return $user->hasRole('admin') || $user->hasPermissionTo('edit feedback');
    }

    /**
     * Determine whether the user can respond to the feedback.
     */
    public function respond(User $user, Feedback $feedback): bool
    {
        return $user->hasRole('admin') || $user->hasPermissionTo('respond to feedback');
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Feedback $feedback): bool
    {
        return $user->hasRole('admin') || $user->hasPermissionTo('delete feedback');
    }
} 