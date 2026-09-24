<?php

use App\Http\Controllers\Admin\AuthController;
use App\Http\Controllers\Admin\RouteController;
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

    Route::get('/routes', [RouteController::class, 'index']);
    Route::get('/routes/{id}', [RouteController::class, 'show']);
    Route::post('/routes', [RouteController::class, 'store']);
    Route::put('/routes/{id}', [RouteController::class, 'update']);
    Route::delete('/routes/{id}', [RouteController::class, 'destroy']);
});
