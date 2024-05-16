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
        Schema::create('barang_masuk', function (Blueprint $table) {
            $table->string('kd_barang_masuk', 11)->primary();
            $table->string('kd_supplier', 6);
            $table->string('kd_barang', 9);
            $table->string('nama_barang', 50);
            $table->string('satuan', 25);
            $table->integer('harga');
            $table->integer('jumlah');
            $table->integer('total_harga');
            $table->date('tanggal');
            $table->timestamps();

            $table->foreign('kd_supplier')->references('kd_supplier')->on('supplier')->onDelete('cascade');
            $table->foreign('kd_barang')->references('kd_barang')->on('barang')->onDelete('cascade');
        
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('barang_masuk');
    }
};
