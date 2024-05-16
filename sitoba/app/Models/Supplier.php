<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Supplier extends Model
{
    use HasFactory;

    protected $table = 'supplier';

    protected $primaryKey = 'kd_supplier';

    public $incrementing = false;

    protected $fillable = [
        'kd_supplier',
        'nama_supplier',
        'alamat_supplier',
        'no_telp_supplier',
    ];

    protected static function booted()
    {
        static::creating(function ($supplier) {
            $lastSupplier = static::orderBy('kd_supplier', 'desc')->first();
            $lastCode = $lastSupplier ? intval(substr($lastSupplier->kd_supplier, 3)) : 0;
            $supplier->kd_supplier = 'SPL' . str_pad($lastCode + 1, 3, '0', STR_PAD_LEFT);
        });
    }
}
