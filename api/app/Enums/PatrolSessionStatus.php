<?php

namespace App\Enums;

enum PatrolSessionStatus: string
{
    case InProgress = 'in_progress';
    case Completed = 'completed';
    case Cancelled = 'cancelled';
}
