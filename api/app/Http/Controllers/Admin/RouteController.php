<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Route;
use Illuminate\Http\Request;
use Laravel\Mcp\Enums\Role;

class RouteController extends Controller
{
    public function index() {
        $routes = Route::all();

        return response()->json([
            'status' => 'success',
            'message' => 'Get all routes successfully',
            'data' => $routes
        ]);
    }

    public function show(string $id) {
        $route = Route::where('id', $id)->first();

        if(!$route) {
            return response()->json([
                'status' => 'error',
                'message' => 'Route not found',
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Get route successfully',
            'data' => $route
        ]);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'name' => 'required',
            'description' => 'required',
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Added route successfully'
        ], 201);
    }

    public function update(Request $request, string $id) {
        $validated = $request->validate([
            'name' => 'nullable',
            'description' => 'nullable',
        ]);

        $route = Route::where('id', $id)->first();

        if (!$route) {
            return response()->json([
                'status' => 'error',
                'message' => 'Route not found'
            ], 404);
        }

        $route->update([
            'name' => $validated['name'],
            'description' => $validated['description']
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Updated route successfully'
        ]);
    }

    public function destroy(string $id) {
        $route = Route::where('id', $id)->first();

        if (!$route) {
            return response()->json([
                'status' => 'error',
                'message' => 'Route not found'
            ], 404);
        }

        $route->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Deleted route successfully'
        ]);
    }
}
