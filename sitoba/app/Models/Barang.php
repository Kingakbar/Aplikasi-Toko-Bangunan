<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Barang extends Model
{
    use HasFactory;

    protected $table = 'barang';

    protected $primaryKey = 'kd_barang';

    public $incrementing = false;

    protected $fillable = [
        'kd_barang',
        'nama_barang',
        'id_jenis',
        'satuan',
        'stok',
        'harga_pokok',
        'ppn',
        'harga_jual',
    ];

    protected static function booted()
    {
        static::creating(function ($barang) {
            $barang->kd_barang = 'BRG' . str_pad(Barang::count() + 1, 6, '0', STR_PAD_LEFT);
        });
    }

    public function jenisBarang()
    {
        return $this->belongsTo(JenisBarang::class, 'id_jenis', 'id_jenis');
    }
}
