<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PatrolLog;
use Illuminate\Http\Request;

class PatrolLogController extends Controller
{
    public function index() {
        $patrollogs =PatrolLog::all();

        return response()->json([
            'status' => 'success',
            'message' => 'Get all Checkpoints successfully',
            'data' => $patrollogs
        ]);
    }

    public function show(string $id) {
        $patrollog =PatrolLog::where('id', $id)->first();

        if(!$patrollog) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found',
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Get Checkpoint successfully',
            'data' => $patrollog
        ]);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'session_id' => 'required',
            'checkpoint_id' => 'required',
            'photo_path' => 'required',
            'photo_hash' => 'required',
            'lat' => 'required',
            'ling' => 'required',
            'condition' => 'required',
            'note' => 'required',
            'scanned_at' => 'required',
            'validation_status' => 'required',
            'admin_status' => 'required',
            'admin_note' => 'required'
        ]);

       PatrolLog::create([
            'session_id' => $validated['session_id'],
            'checkpoint_id' => $validated['checkpoint_id'],
            'photo_path' => $validated['photo_path'],
            'photo_hash' => $validated['photo_hash'],
            'lat' => $validated['lat'],
            'ling' => $validated['ling'],
            'condition' => $validated['condition'],
            'note' => $validated['note'],
            'scanned_at' => $validated['scanned_at'],
            'validation_status' => $validated['validation_status'],
            'admin_status' => $validated['admin_status'],
            'admin_note' => $validated['admin_note'],
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Added Checkpoint successfully'
        ], 201);
    }

    public function update(Request $request, string $id) {
        $validated = $request->validate([
            'session_id' => 'required',
            'checkpoint_id' => 'required',
            'photo_path' => 'required',
            'photo_hash' => 'required',
            'lat' => 'required',
            'ling' => 'required',
            'condition' => 'required',
            'note' => 'required',
            'scanned_at' => 'required',
            'validation_status' => 'required',
            'admin_status' => 'required',
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
            'photo_hash' => $validated['photo_hash'],
            'lat' => $validated['lat'],
            'ling' => $validated['ling'],
            'condition' => $validated['condition'],
            'note' => $validated['note'],
            'scanned_at' => $validated['scanned_at'],
            'validation_status' => $validated['validation_status'],
            'admin_status' => $validated['admin_status'],
            'admin_note' => $validated['admin_note'],
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Updated Checkpoint successfully'
        ]);
    }

    public function destroy(string $id) {
        $patrollog =PatrolLog::where('id', $id)->first();

        if (!$patrollog) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found'
            ], 404);
        }

        $patrollog->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Deleted Checkpoint successfully'
        ]);
    }
}
