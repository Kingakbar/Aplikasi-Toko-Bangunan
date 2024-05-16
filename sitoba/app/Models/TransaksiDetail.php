<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TransaksiDetail extends Model
{
    use HasFactory;

    protected $fillable = [
        'no_transaksi',
        'kd_barang',
        'barang',
        'harga',
        'banyak',
        'total',
    ];

   

    // Override method boot untuk menetapkan nomor transaksi saat transaksi detail dibuat
    // protected static function boot()
    // {
    //     parent::boot();

    //     static::creating(function ($transaksiDetail) {
          
                
    //             $transaksiDetail->no_transaksi = $transaksiDetail->generateNoTransaksi();
        
    //     });
    // }

    // // Method untuk menghasilkan nomor transaksi standar
    // private static function generateNoTransaksi()
    // {
    //     $lastTransaction = static::latest()->first();
    //     if ($lastTransaction) {
    //         $lastNumber = (int) substr($lastTransaction->no_transaksi, -3);
    //         $newNumber = $lastNumber + 1;
    //         $formattedNumber = str_pad($newNumber, 3, '0', STR_PAD_LEFT);
    //         return now()->format('dmY') . $formattedNumber;
    //     } else {
    //         return now()->format('dmY') . '001';
    //     }
    // }

    // Mendefinisikan relasi dengan tabel Barang
    public function barang()
    {
        return $this->belongsTo(Barang::class, 'kd_barang', 'kd_barang');
    }

    // Definisikan relasi dengan model Transaksi
    public function transaksi()
    {
        return $this->belongsTo(Transaksi::class, 'no_transaksi', 'no_transaksi');
    }
}
