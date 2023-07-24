<?php
namespace App\Console;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{	
	protected $commands = [
        Commands\registrosCron::class,
    ];

    protected function schedule(Schedule $schedule)
    {
        
		$schedule->command('registros:cron')->dailyAt('00:00');
		$schedule->command('registros:cron')->dailyAt('03:00');
		$schedule->command('registros:cron')->dailyAt('06:00');
		$schedule->command('registros:cron')->dailyAt('09:00');
		$schedule->command('registros:cron')->dailyAt('12:00');
		$schedule->command('registros:cron')->dailyAt('15:00');
		$schedule->command('registros:cron')->dailyAt('18:00');
		$schedule->command('registros:cron')->dailyAt('21:00');
		
    }

    protected function commands()
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
	
}
