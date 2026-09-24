<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function register(Request $request) {
        $validated = $request->validate([
            'name' => 'required',
            'username' => 'required',
            'role' => 'required',
            'password' => 'required|min:6'
        ]);

        $checkAlready = User::where('username', $validated['username'])->exists();

        if ($checkAlready) {
            return response()->json([
                'status' => 'error',
                'message' => 'Username has already used'
            ], 403);
        }

        $user = User::create([
            'name' => $validated['name'],
            'role' => $validated['role'],
            'username' => $validated['username'],
            'password' => $validated['password']
        ]);

        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Register successfully',
            'data' => [
                'token' => $token,
                'user' => $user
            ]
        ], 201);
    }

    public function login(Request $request) {
        $validated = $request->validate([
            'username' => 'required',
            'password' => 'required|min:6'
        ]);

        $checkAlready = User::where('username', $validated['username'])->exists();

        if (!$checkAlready) {
            return response()->json([
                'status' => 'error',
                'message' => 'Username not found'
            ], 404);
        }

        $user = User::where('username', $validated['username'])->first();

        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Login successfully',
            'data' => [
                'token' => $token,
                'user' => $user
            ]
        ]);
    }

    public function logout(Request $request) {
        $user = $request->user();

        $user->tokens()->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Logout successfully'
        ]);
    }
}
