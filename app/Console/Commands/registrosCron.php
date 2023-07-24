<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Http\Controllers\Frontend\RegistroController;

class registrosCron extends Command
{
    protected $signature = 'registros:cron';

    protected $description = 'Ejecuta la funcion registros todos los dias';

    public function __construct()
    {
        parent::__construct();
    }

    public function handle()
    {
        $controller = app()->make('App\Http\Controllers\Frontend\RegistroController');
        app()->call([$controller, 'actualizar']);
    }
}


