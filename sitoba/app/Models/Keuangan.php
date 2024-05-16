<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Keuangan extends Model
{
    use HasFactory;

    protected $table = 'keuangan';
    protected $primaryKey = 'id_keuangan';
    protected $fillable = [
        'tanggal',
        'jenis_keuangan',
        'masuk',
        'keluar',
    ];

    protected $dates = ['tanggal', 'waktu'];

    public $timestamps = false;
}
