<?php

namespace App\Http\Controllers\Api;

use App\Models\Barang;
use App\Models\Transaksi;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Models\TransaksiDetail;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class TransaksiDetailAPiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $transaksiDetails = TransaksiDetail::with('barang')->get();
        return response()->json(['data' => $transaksiDetails], Response::HTTP_OK);
    }

    /**
     * Store a newly created resource in storage.
     */
    // public function store(Request $request)
    // {
    //     $validator = Validator::make($request->all(), [
    //         'no_transaksi' => 'required', // pastikan no_transaksi sudah disertakan
    //         'kd_barang' => 'required|string|max:9',
    //         'barang' => 'required|string|max:50',
    //         'harga' => 'required|integer',
    //         'banyak' => 'required|integer',
    //         'total' => 'required|integer',
    //     ]);

    //     if ($validator->fails()) {
    //         return response()->json(['error' => $validator->errors()], 400);
    //     }

    //     
    //     $data = $request->all();

    //     // Kurangi stok barang yang tersedia
    //     $barang = Barang::findOrFail($data['kd_barang']);
    //     $stok_sekarang = $barang->stok;
    //     $stok_terbaru = $stok_sekarang - $data['banyak'];

    //    
    //     if ($stok_terbaru < 0) {
    //         return response()->json(['error' => 'Stok barang tidak mencukupi'], 400);
    //     }

    //     // Simpan stok barang yang telah diperbarui
    //     $barang->update(['stok' => $stok_terbaru]);

    //    
    //     $transaksiDetail = TransaksiDetail::create($data);

    //     return response()->json(['message' => 'Transaksi detail created successfully', 'data' => $transaksiDetail], 201);
    // }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'kd_barang' => 'required|string|max:9',
            'barang' => 'required|string|max:50',
            'harga' => 'required|integer',
            'banyak' => 'required|integer',
            'total' => 'required|integer',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 400);
        }


        $latestTransaction = Transaksi::latest()->first();
        $no_transaksi = $latestTransaction ? $latestTransaction->no_transaksi : 0;

        $data = $request->all();


        $barang = Barang::findOrFail($data['kd_barang']);
        $stok_sekarang = $barang->stok;
        $stok_terbaru = $stok_sekarang - $data['banyak'];


        if ($stok_terbaru < 0) {
            return response()->json(['error' => 'Stok barang tidak mencukupi'], 400);
        }


        $barang->update(['stok' => $stok_terbaru]);


        $transaksiDetailData = $data;
        $transaksiDetailData['no_transaksi'] = $no_transaksi;
        $transaksiDetail = TransaksiDetail::create($transaksiDetailData);

        return response()->json(['message' => 'Transaksi detail created successfully', 'data' => $transaksiDetail], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $transaksiDetail = TransaksiDetail::findOrFail($id);
        return response()->json(['data' => $transaksiDetail], Response::HTTP_OK);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $transaksiDetail = TransaksiDetail::with('barang')->find($id);

        if (!$transaksiDetail) {
            return response()->json(['message' => 'Transaksi detail Tidak Di temukan'], 404);
        }


        $request->validate([
            'kd_barang' => 'required',
            'barang' => 'required',
            'harga' => 'required',
            'banyak' => 'required',
            'total' => 'required',
        ]);
        $transaksiDetail->update($request->all());
        return response()->json(['message' => 'Barang berhasil diperbarui', 'data' => $transaksiDetail], Response::HTTP_OK);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $transaksiDetail = TransaksiDetail::findOrFail($id);
        $transaksiDetail->delete();
        return response()->json(['message' => 'Transaksi detail berhasil dihapus'], Response::HTTP_NO_CONTENT);
    }
}
