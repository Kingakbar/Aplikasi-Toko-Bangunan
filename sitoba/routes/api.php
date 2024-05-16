<?php

use App\Http\Controllers\Api\BarangApiController;
use App\Http\Controllers\Api\BarangMasukApiController;
use App\Http\Controllers\Api\JenisBarangApiController;
use App\Http\Controllers\Api\KeuanganApiController;
use App\Http\Controllers\Api\SesiUserApiController;
use App\Http\Controllers\Api\SupplierApiController;
use App\Http\Controllers\Api\TransaksiApiController;
use App\Http\Controllers\Api\TransaksiDetailAPiController;
use App\Http\Controllers\Api\TypeUserApiController;
use App\Http\Controllers\SesiUserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/



Route::middleware('auth:sanctum')->group(function () {
    Route::post('logout', [SesiUserApiController::class, 'logout']);
});


Route::post('login', [SesiUserApiController::class, 'login']);
Route::apiResource('jenis_barang', JenisBarangApiController::class);
Route::apiResource('barang', BarangApiController::class);
Route::apiResource('supplier', SupplierApiController::class);
Route::apiResource('barang_masuk', BarangMasukApiController::class);
Route::apiResource('type_user', TypeUserApiController::class);
Route::post('register', [SesiUserApiController::class, 'register'])->name('register');
Route::get('users/{id}', [SesiUserApiController::class, 'show']);
Route::apiResource('detail_transaksi', TransaksiDetailAPiController::class);
Route::apiResource('keuangan', KeuanganApiController::class);
Route::apiResource('transaksi', TransaksiApiController::class);
Route::put('status_bayar/{id}', [TransaksiApiController::class, 'updateStatus']);
Route::get('detail_transaksi/{no_transaksi}', [TransaksiApiController::class, 'show']);
