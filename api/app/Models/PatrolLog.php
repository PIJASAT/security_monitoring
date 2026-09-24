<?php

namespace App\Models;

use App\Enums\AdminStatus;
use App\Enums\PatrolLogCondition;
use App\Enums\ValidationStatus;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'session_id', 
    'route_checkpoint_id', 
    'photo_path',
    'condition', 
    'note', 
    'scanned_at', 
    'validation_status', 
    'admin_action', 
    'admin_note',
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
            'condition' => PatrolLogCondition::class,
            'validation_status' => ValidationStatus::class,
            'admin_action' => AdminStatus::class,
        ];
    }

    public function session(): BelongsTo
    {
        return $this->belongsTo(PatrolSession::class);
    }

    public function routeCheckPoint(): BelongsTo
    {
        return $this->belongsTo(RouteCheckpoint::class);
    }
}
