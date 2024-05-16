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
        Schema::create('transaksi_details', function (Blueprint $table) {
            $table->id();
            $table->string('no_transaksi', 11);
            $table->string('kd_barang', 9);
            $table->string('barang', 50);
            $table->integer('harga');
            $table->integer('banyak');
            $table->integer('total');
            $table->timestamps();
        
            // Set foreign key constraint to relate to the barang table
            $table->foreign('kd_barang')->references('kd_barang')->on('barang')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transaksi_details');
    }
};
