<?php 

namespace App\Http\Controllers\Frontend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Registro;

class RegistroController extends Controller
{
    public function actualizar(){
		
		ini_set('max_execution_time', 1200); // 20 minutes

		$registro_model = new Registro;
		
		$registro_model->procesar_registros(array());

	}
	
}
