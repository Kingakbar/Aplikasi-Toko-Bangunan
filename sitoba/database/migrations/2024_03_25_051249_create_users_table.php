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
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('nama_user', 50);
            $table->string('jk_user', 9);
            $table->text('alamat_user');
            $table->string('no_telp_user', 13);
            $table->string('username', 20);
            $table->string('password', 255);
            $table->unsignedBigInteger('type_user'); // Menggunakan unsignedBigInteger() untuk tipe data yang sesuai
            $table->timestamps();
        
            // Set foreign key constraint
            $table->foreign('type_user')->references('id')->on('type_users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
