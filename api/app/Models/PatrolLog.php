<?php

namespace App\Models;

use App\Enums\AdminStatus;
use App\Enums\PatrolLogCondition;
use App\Enums\ValidationStatus;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'session_id', 'checkpoint_id', 'photo_path', 'photo_hash', 'lat', 'lng',
    'condition', 'note', 'scanned_at', 'validation_status', 'admin_status', 'admin_note',
])]
class PatrolLog extends Model
{
    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'lat' => 'decimal:7',
            'lng' => 'decimal:7',
            'scanned_at' => 'datetime',
            'condition' => PatrolLogCondition::class,
            'validation_status' => ValidationStatus::class,
            'admin_status' => AdminStatus::class,
        ];
    }

    public function session(): BelongsTo
    {
        return $this->belongsTo(PatrolSession::class);
    }

    public function checkpoint(): BelongsTo
    {
        return $this->belongsTo(Checkpoint::class);
    }
}
