<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Schedule;
use Illuminate\Http\Request;

class ScheduleController extends Controller
{
    public function index() {
        $schedules =Schedule::all();

        return response()->json([
            'status' => 'success',
            'message' => 'Get all Checkpoints successfully',
            'data' => $schedules
        ]);
    }

    public function show(string $id) {
        $schedule =Schedule::where('id', $id)->first();

        if(!$schedule) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found',
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Get Checkpoint successfully',
            'data' => $schedule
        ]);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'user_id' => 'required',
            'route_id' => 'required',
            'date' => 'required',
            'shift_start' => 'required',
            'shift_end' => 'required'
        ]);

       Schedule::create([
            'user_id' => $validated['user_id'],
            'route_id' => $validated['route_id'],
            'date' => $validated['date'],
            'shift_start' => $validated['shift_start'],
            'shift_end' => $validated['shift_end'],
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Added Checkpoint successfully'
        ], 201);
    }

    public function update(Request $request, string $id) {
        $validated = $request->validate([
            'user_id' => 'required',
            'route_id' => 'required',
            'date' => 'required',
            'shift_start' => 'required',
            'shift_end' => 'required'
        ]);

        $schedule =Schedule::where('id', $id)->first();

        if (!$schedule) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found'
            ], 404);
        }

        $schedule->update([
            'user_id' => $validated['user_id'],
            'route_id' => $validated['route_id'],
            'date' => $validated['date'],
            'shift_start' => $validated['shift_start'],
            'shift_end' => $validated['shift_end'],
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Updated Checkpoint successfully'
        ]);
    }

    public function destroy(string $id) {
        $schedule =Schedule::where('id', $id)->first();

        if (!$schedule) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found'
            ], 404);
        }

        $schedule->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Deleted Checkpoint successfully'
        ]);
    }
}
