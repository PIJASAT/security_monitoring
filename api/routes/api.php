<?php

use App\Http\Controllers\Admin\AuthController;
use App\Http\Controllers\Admin\CheckpointController;
use App\Http\Controllers\Admin\PatrolLogController;
use App\Http\Controllers\Admin\PatrolSessionController;
use App\Http\Controllers\Admin\RouteCheckpointController;
use App\Http\Controllers\Admin\RouteController;
use App\Http\Controllers\Admin\ScheduleController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::prefix('/v1')->group(function () {
    Route::prefix('/auth')->group(function () {
        Route::post('/register', [AuthController::class, 'register']);
        Route::post('/login', [AuthController::class, 'login']);
        Route::middleware('auth:sanctum')->group(function () {
            Route::post('/logout', [AuthController::class, 'logout']);
        });
    });

    Route::middleware(['auth:sanctum', 'admin'])->group(function() {
        Route::get('/routes', [RouteController::class, 'index']);
        Route::get('/routes/{id}', [RouteController::class, 'show']);
        Route::post('/routes', [RouteController::class, 'store']);
        Route::put('/routes/{id}', [RouteController::class, 'update']);
        Route::delete('/routes/{id}', [RouteController::class, 'destroy']);

        Route::get('/route-checkpoints', [RouteCheckpointController::class, 'index']);
        Route::get('/route-checkpoints/{id}', [RouteCheckpointController::class, 'show']);
        Route::post('/route-checkpoints', [RouteCheckpointController::class, 'store']);
        Route::put('/route-checkpoints/{id}', [RouteCheckpointController::class, 'update']);
        Route::delete('/route-checkpoints/{id}', [RouteCheckpointController::class, 'destroy']);

        Route::get('/schedules', [ScheduleController::class, 'index']);
        Route::get('/schedules/{id}', [ScheduleController::class, 'show']);
        Route::post('/schedules', [ScheduleController::class, 'store']);
        Route::put('/schedules/{id}', [ScheduleController::class, 'update']);
        Route::delete('/schedules/{id}', [ScheduleController::class, 'destroy']);

        Route::get('/patrol-sessions', [PatrolSessionController::class, 'index']);
        Route::get('/patrol-sessions/{id}', [PatrolSessionController::class, 'show']);
        Route::post('/patrol-sessions', [PatrolSessionController::class, 'store']);
        Route::put('/patrol-sessions/{id}', [PatrolSessionController::class, 'update']);
        Route::delete('/patrol-sessions/{id}', [PatrolSessionController::class, 'destroy']);

        Route::get('/patrol-log', [PatrolLogController::class, 'index']);
        Route::get('/patrol-log/{id}', [PatrolLogController::class, 'show']);
        Route::post('/patrol-log', [PatrolLogController::class, 'store']);
        Route::put('/patrol-log/{id}', [PatrolLogController::class, 'update']);
        Route::delete('/patrol-log/{id}', [PatrolLogController::class, 'destroy']);
    });
});
