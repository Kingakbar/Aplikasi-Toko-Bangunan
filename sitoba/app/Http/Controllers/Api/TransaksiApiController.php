<?php

namespace App\Http\Controllers\Api;

use App\Models\Keuangan;
use App\Models\Transaksi;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Models\TransaksiDetail;
use Illuminate\Validation\Rule;
use App\Http\Controllers\Controller;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class TransaksiApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $transaksis = Transaksi::with('transaksiDetail.barang', 'user')->get();

        return response()->json(['data' => $transaksis], Response::HTTP_OK);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'tgl_transaksi' => 'required|date',
            'subtotal' => 'required|integer',
            'diskon' => 'required|integer',
            'total_akhir' => 'required|integer',
            'bayar' => 'required|integer',
            'kembalian' => 'required|integer',
            'user_id' => 'required|integer'
        ]);


        $request->merge([
            'status' => 'belum_bayar',
        ]);


        $transaksi = Transaksi::create($request->all());


        $jenis_keuangan = 'Penjualan Barang';
        $masuk = $request->total_akhir;

        $keuangan = Keuangan::create([
            'tanggal' => $request->tgl_transaksi,
            'jenis_keuangan' => $jenis_keuangan,
            'masuk' => $masuk,
        ]);

        return response()->json(['message' => 'Transaksi berhasil disimpan', 'data' => $transaksi, 'data_keuangan' => $keuangan], Response::HTTP_CREATED);
    }



    /**
     * Display the specified resource.
     */
    public function show(string $no_transaksi)
    {
        $transaksi = Transaksi::with('transaksiDetail.barang', 'user')->findOrFail($no_transaksi);
        $barang_dijual = $transaksi->transaksiDetail;
        return response()->json(['data' => $transaksi], Response::HTTP_OK);
    }


    public function updateStatus(Request $request, string $no_transaksi)
    {
        $transaksi = Transaksi::find($no_transaksi);
        if (!$transaksi) {
            return response()->json(['message' => 'Transaksi Tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }
        $validatedData = $request->validate([
            'status' => 'required'
        ]);
        $transaksi->update($validatedData);
        return response()->json(['message' => 'Status Transaksi berhasil diubah'], Response::HTTP_OK);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $no_transaksi)
    {
        $transaksi = Transaksi::find($no_transaksi);
        if (!$transaksi) {
            return response()->json(['message' => 'Transaksi Tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }


        $validatedData = $request->validate([
            'tgl_transaksi' => 'required|date',
            'subtotal' => 'required|integer',
            'diskon' => 'required|integer',
            'total_akhir' => 'required|integer',
            'bayar' => 'required|integer',
            'kembalian' => 'required|integer',
            'id_user' => [
                'required',
                Rule::exists('users', 'id')
            ],
        ]);


        $transaksi->update($validatedData);

        return response()->json(['message' => 'Transaksi updated successfully', 'data' => $transaksi], Response::HTTP_OK);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $no_transaksi)
    {
        $transaksi = Transaksi::where('no_transaksi', $no_transaksi)->first();

        if (!$transaksi) {
            return response()->json(['message' => 'Transaksi Tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }


        $transaksi->delete();


        return response()->json(['message' => 'Transaksi deleted successfully'], Response::HTTP_OK);
    }
}
