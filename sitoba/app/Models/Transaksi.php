<?php

namespace App\Models;

use Illuminate\Validation\Rule;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Transaksi extends Model
{
    use HasFactory;
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';
    protected $table = 'transaksi';
    protected $fillable = [
        'no_transaksi',
        'tgl_transaksi',
        'subtotal',
        'diskon',
        'total_akhir',
        'bayar',
        'kembalian',
        'status',
        'user_id',

    ];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($transaksi) {
            $transaksi->no_transaksi = static::generateNoTransaksi();
        });
    }

    public function transaksiDetail()
    {
        return $this->hasMany(TransaksiDetail::class, 'no_transaksi', 'no_transaksi')->with('barang');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }


    private static function generateNoTransaksi()
    {
        $lastTransaction = static::latest()->first();
        if ($lastTransaction) {
            $lastNumber = (int) substr($lastTransaction->no_transaksi, -3);
            $newNumber = $lastNumber + 1;
            $formattedNumber = str_pad($newNumber, 3, '0', STR_PAD_LEFT);
            return now()->format('dmY') . $formattedNumber;
        } else {
            return now()->format('dmY') . '001';
        }
    }
}
