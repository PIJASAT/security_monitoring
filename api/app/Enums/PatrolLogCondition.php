<?php

namespace App\Enums;

enum PatrolLogCondition: string
{
    case Ok = 'ok';
    case Anomaly = 'anomaly';
}
