<?php

use App\Http\Controllers\BarangController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\DetailTransaksiController;
use App\Http\Controllers\SesiUserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::middleware(['guest'])->group(function () {
    Route::get('/', [SesiUserController::class, 'index'])->name('login');
    Route::post('/', [SesiUserController::class, 'login'])->name('login');
});


Route::middleware(['auth'])->group(function () {
    Route::get('/home', [DashboardController::class, 'index'])->name('index');
    Route::get('/logout', [SesiUserController::class, 'logout'])->name('logout');

    Route::post('/store-transaksi', [DashboardController::class, 'store'])->name('store');
    Route::get('/store-transaksi', [DashboardController::class, 'add'])->name('add');
    Route::post('/process-payment', [DashboardController::class, 'processPayment'])->name('processPayment');
    Route::get('/barang/all', [DashboardController::class, 'all'])->name('barang.all');
    Route::get('/detail_test', [DetailTransaksiController::class, 'index'])->name('detail');
    Route::resource('/barang', BarangController::class);
});
