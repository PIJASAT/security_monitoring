<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PatrolSession;
use Illuminate\Http\Request;

class PatrolSessionController extends Controller
{
    public function index() {
        $patrolsessions =PatrolSession::all();

        return response()->json([
            'status' => 'success',
            'message' => 'Get all Patrol Session successfully',
            'data' => $patrolsessions
        ]);
    }

    public function show(string $id) {
        $patrolsession =PatrolSession::where('id', $id)->first();

        if(!$patrolsession) {
            return response()->json([
                'status' => 'error',
                'message' => 'Patrol Session not found',
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Get Patrol Session successfully',
            'data' => $patrolsession
        ]);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'schedule_id' => 'required',
            'started_at' => 'required',
            'finished_at' => 'required',
            'status' => 'required',
        ]);

       PatrolSession::create([
            'schedule_id' => $validated['schedule_id'],
            'started_at' => $validated['started_at'],
            'finished_at' => $validated['finished_at'],
            'status' => $validated['status']
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Added Patrol Session successfully'
        ], 201);
    }

    public function update(Request $request, string $id) {
        $validated = $request->validate([
            'schedule_id' => 'required',
            'started_at' => 'required',
            'finished_at' => 'required',
            'status' => 'required',
        ]);

        $patrolsession =PatrolSession::where('id', $id)->first();

        if (!$patrolsession) {
            return response()->json([
                'status' => 'error',
                'message' => 'Patrol Session not found'
            ], 404);
        }

        $patrolsession->update([
            'schedule_id' => $validated['schedule_id'],
            'started_at' => $validated['started_at'],
            'finished_at' => $validated['finished_at'],
            'status' => $validated['status']
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Updated Patrol Session successfully'
        ]);
    }

    public function destroy(string $id) {
        $patrolsession =PatrolSession::where('id', $id)->first();

        if (!$patrolsession) {
            return response()->json([
                'status' => 'error',
                'message' => 'Patrol Session not found'
            ], 404);
        }

        $patrolsession->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Deleted Patrol Session successfully'
        ]);
    }
}
