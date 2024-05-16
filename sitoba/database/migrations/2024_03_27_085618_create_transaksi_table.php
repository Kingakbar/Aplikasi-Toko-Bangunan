<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('transaksi', function (Blueprint $table) {
            $table->id();
            $table->string('no_transaksi');
            $table->date('tgl_transaksi');
            $table->timestamp('waktu')->useCurrent();
            $table->integer('subtotal');
            $table->integer('diskon');
            $table->integer('total_akhir');
            $table->integer('bayar');
            $table->integer('kembalian');
            $table->enum('status', ['sudah_bayar', 'belum_bayar'])->default('belum_bayar');
            $table->unsignedBigInteger('user_id');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transaksi');
    }
};
