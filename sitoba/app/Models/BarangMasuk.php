<?php

namespace App\Models;

use Illuminate\Support\Facades\DB;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BarangMasuk extends Model
{
    use HasFactory;

    protected $table = 'barang_masuk';
    protected $primaryKey = 'kd_barang_masuk';
    public $incrementing = false;
    protected $fillable = [
        'kd_barang_masuk',
        'kd_supplier',
        'kd_barang',
        'nama_barang',
        'satuan',
        'harga',
        'jumlah',
        'total_harga',
        'tanggal',
    ];

    public function supplier()
    {
        return $this->belongsTo(Supplier::class, 'kd_supplier', 'kd_supplier');
    }

    public function barang()
    {
        return $this->belongsTo(Barang::class, 'kd_barang', 'kd_barang');
    }

    protected static function booted()
    {
        static::creating(function ($barangMasuk) {
            // Generate standar kode barang masuk (bulan/tanggal/BELI001)
            $bulanTahun = date('ym'); // Ambil tahun 2 digit dan bulan
            $lastKode = self::where('kd_barang_masuk', 'like', $bulanTahun . '%')->max('kd_barang_masuk');
            $lastNumber = $lastKode ? intval(substr($lastKode, -3)) : 0;
            $nextNumber = $lastNumber + 1;
            $nextKode = str_pad($nextNumber, 3, '0', STR_PAD_LEFT);
            $barangMasuk->kd_barang_masuk = $bulanTahun . 'BELI' . $nextKode;

            // Perbarui stok barang di tabel 'barang'
            DB::table('barang')
                ->where('kd_barang', $barangMasuk->kd_barang)
                ->increment('stok', $barangMasuk->jumlah);
        });
    }
}
