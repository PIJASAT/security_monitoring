<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Checkpoint;
use Illuminate\Http\Request;

class CheckpointController extends Controller
{
    public function index() {
        $checkpoints = Checkpoint::all();

        return response()->json([
            'status' => 'success',
            'message' => 'Get all Checkpoints successfully',
            'data' => $checkpoints
        ]);
    }

    public function show(string $id) {
        $checkpoint = Checkpoint::where('id', $id)->first();

        if(!$checkpoint) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found',
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Get Checkpoint successfully',
            'data' => $checkpoint
        ]);
    }

    public function store(Request $request) {
        $validated = $request->validate([
            'name' => 'required',
            'lat' => 'required',
            'ing' => 'required',
            'radius' => 'required',
            'qr_code' => 'required',
        ]);

        Checkpoint::create([
            'name' => $validated['name'],
            'lat' => $validated['lat'],
            'ing' => $validated['ing'],
            'radius' => $validated['radius'],
            'qr_code' => $validated['qr_code']
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Added Checkpoint successfully'
        ], 201);
    }

    public function update(Request $request, string $id) {
        $validated = $request->validate([
            'name' => 'required',
            'lat' => 'required',
            'ing' => 'required',
            'radius' => 'required',
            'qr_code' => 'required',
        ]);

        $checkpoint = Checkpoint::where('id', $id)->first();

        if (!$checkpoint) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found'
            ], 404);
        }

        $checkpoint->update([
            'name' => $validated['name'],
            'lat' => $validated['lat'],
            'ing' => $validated['ing'],
            'radius' => $validated['radius'],
            'qr_code' => $validated['qr_code']
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Updated Checkpoint successfully'
        ]);
    }

    public function destroy(string $id) {
        $checkpoint = Checkpoint::where('id', $id)->first();

        if (!$checkpoint) {
            return response()->json([
                'status' => 'error',
                'message' => 'Checkpoint not found'
            ], 404);
        }

        $checkpoint->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Deleted Checkpoint successfully'
        ]);
    }
}
