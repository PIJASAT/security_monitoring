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
            $table->foreignId('checkpoint_id')->nullable()->constrained()->nullOnDelete();
            $table->string('photo_path');
            $table->string('photo_hash');
            $table->decimal('lat', 10, 7);
            $table->decimal('lng', 10, 7);
            $table->enum('condition', ['ok', 'anomaly'])->default('ok');
            $table->text('note')->nullable();
            $table->timestamp('scanned_at');
            $table->enum('validation_status', ['pending', 'valid', 'invalid'])->default('pending');
            $table->enum('admin_status', ['pending', 'approved', 'rejected'])->nullable();
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
