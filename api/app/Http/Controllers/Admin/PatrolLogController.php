<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PatrolLog;
use Illuminate\Http\Request;

use function Illuminate\Support\now;

class PatrolLogController extends Controller
{
    public function index() {
        $patrollogs =PatrolLog::all();

        return response()->json([
            'status' => 'success',
            'message' => 'Get all Patrol Log successfully',
            'data' => $patrollogs
        ]);
    }

    public function show(string $id) {
        $patrollog =PatrolLog::where('id', $id)->first();

        if(!$patrollog) {
            return response()->json([
                'status' => 'error',
                'message' => 'Patrol log not found',
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Get Patrol Log successfully',
            'data' => $patrollog
        ]);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'session_id' => 'required',
            'route_checkpoint_id' => 'required',
            // 'photo_path' => 'required',
            'image' => 'required|file|image|mimes:png,jpg,jpeg',
            'condition' => 'required',
            'note' => 'required',
            'admin_note' => 'nullable'
        ]);

        $image = $request->file('image');
        $generateName = uniqid().'.'.$image->getClientOriginalExtension();
        $file = $image->storeAs('patrollog', $generateName, 'public');

       PatrolLog::create([
            'session_id' => $validated['session_id'],
            'route_checkpoint_id' => $validated['route_checkpoint_id'],
            'photo_path' => $file,
            'condition' => $validated['condition'],
            'note' => $validated['note'],
            'scanned_at' => now(),
            'admin_note' => $validated['admin_note'] ?? "",
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Added Patrol Log successfully'
        ], 201);
    }

    public function update(Request $request, string $id) {
        $validated = $request->validate([
            'session_id' => 'required',
            'checkpoint_id' => 'required',
            'photo_path' => 'required',
            'condition' => 'required',
            'note' => 'required',
            'scanned_at' => 'required',
            'validation_status' => 'required',
            'admin_action' => 'required',
            'admin_note' => 'required'
        ]);

        $patrollog =PatrolLog::where('id', $id)->first();

        if (!$patrollog) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found'
            ], 404);
        }

        $patrollog->update([
            'session_id' => $validated['session_id'],
            'checkpoint_id' => $validated['checkpoint_id'],
            'photo_path' => $validated['photo_path'],
            'condition' => $validated['condition'],
            'note' => $validated['note'],
            'scanned_at' => $validated['scanned_at'],
            'validation_status' => $validated['validation_status'],
            'admin_action' => $validated['admin_action'],
            'admin_note' => $validated['admin_note'],
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Updated Patrol Log successfully'
        ]);
    }

    public function destroy(string $id) {
        $patrollog =PatrolLog::where('id', $id)->first();

        if (!$patrollog) {
            return response()->json([
                'status' => 'error',
                'message' => 'Patrol Log not found'
            ], 404);
        }

        $patrollog->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Deleted Patrol Log successfully'
        ]);
    }
}
