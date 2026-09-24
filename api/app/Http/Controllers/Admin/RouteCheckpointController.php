<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\RouteCheckpoint;
use Illuminate\Http\Request;

class RouteCheckpointController extends Controller
{
    public function index() {
        $routecheckpoints = RouteCheckpoint::all();

        return response()->json([
            'status' => 'success',
            'message' => 'Get all Checkpoints successfully',
            'data' => $routecheckpoints
        ]);
    }

    public function show(string $id) {
        $routecheckpoint = RouteCheckpoint::where('id', $id)->first();

        if(!$routecheckpoint) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found',
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Get Checkpoint successfully',
            'data' => $routecheckpoint
        ]);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'route_id' => 'required',
            'checkpoint_id' => 'required',
            'sequence' => 'required',
            'max_minutes' => 'required'
        ]);

        RouteCheckpoint::create([
            'route_id' => $validated['route_id'],
            'checkpoint_id' => $validated['checkpoint_id'],
            'sequence' => $validated['sequence'],
            'max_minutes' => $validated['max_minutes'],
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Added Checkpoint successfully'
        ], 201);
    }

    public function update(Request $request, string $id) {
        $validated = $request->validate([
            'route_id' => 'required',
            'checkpoint_id' => 'required',
            'sequence' => 'required',
            'max_minutes' => 'required'
        ]);

        $routecheckpoint = RouteCheckpoint::where('id', $id)->first();

        if (!$routecheckpoint) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found'
            ], 404);
        }

        $routecheckpoint->update([
            'route_id' => $validated['route_id'],
            'checkpoint_id' => $validated['checkpoint_id'],
            'sequence' => $validated['sequence'],
            'max_minutes' => $validated['max_minutes'],
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Updated Checkpoint successfully'
        ]);
    }

    public function destroy(string $id) {
        $routecheckpoint = RouteCheckpoint::where('id', $id)->first();

        if (!$routecheckpoint) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found'
            ], 404);
        }

        $routecheckpoint->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Deleted Checkpoint successfully'
        ]);
    }
}
