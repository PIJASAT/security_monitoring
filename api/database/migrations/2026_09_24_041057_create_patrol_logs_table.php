<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('patrol_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('session_id')->constrained('patrol_sessions')->cascadeOnDelete();
            $table->foreignId('route_checkpoint_id')->nullable()->constrained()->nullOnDelete();
            $table->string('photo_path');
            $table->enum('condition', ['ok', 'anomaly'])->default('ok');
            $table->text('note')->nullable();
            $table->timestamp('scanned_at');
            $table->enum('validation_status', ['pending', 'valid', 'invalid'])->default('pending');
            $table->enum('admin_action', ['pending', 'approved', 'rejected'])->default('pending');
            $table->text('admin_note')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('patrol_logs');
    }
};
