<?php

namespace App\Http\Controllers\Api;

use App\Models\Barang;
use App\Models\Keuangan;
use App\Models\BarangMasuk;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Http\Controllers\Controller;

class BarangMasukApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $barangMasuk = BarangMasuk::with(['supplier', 'barang'])->get();
        return response()->json(['data' => $barangMasuk], Response::HTTP_OK);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'kd_supplier' => 'required|string|max:6',
            'kd_barang' => 'required|string|max:9',
            'nama_barang' => 'required|string|max:50',
            'satuan' => 'required|string|max:25',
            'harga' => 'required|integer',
            'jumlah' => 'required|integer',
            'total_harga' => 'required|integer',
            'tanggal' => 'required|date',
        ]);

        // Buat entri barang masuk
        $barangMasuk = BarangMasuk::create($request->all());

        // Buat entri baru di tabel keuangan
        $keterangan = 'Pembelian ' . $barangMasuk->nama_barang;
        Keuangan::create([
            'tanggal' => $barangMasuk->tanggal,
            'jenis_keuangan' => $keterangan,
            'masuk' => 0,
            'keluar' => $barangMasuk->total_harga,
        ]);

        return response()->json(['message' => 'Barang masuk berhasil ditambahkan', 'data' => $barangMasuk], Response::HTTP_CREATED);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $kd_barang_masuk)
    {
        $barangMasuk = BarangMasuk::with(['supplier', 'barang'])->find($kd_barang_masuk);
        if (!$barangMasuk) {
            return response()->json(['message' => 'Barang Masuk Tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }

        return response()->json(['data' => $barangMasuk], Response::HTTP_OK);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $kd_barang_masuk)
    {
        $barangMasuk = BarangMasuk::find($kd_barang_masuk);
        if (!$barangMasuk) {
            return response()->json(['message' => 'Barang masuk tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $request->validate([
            'kd_supplier' => 'required|string|max:6',
            'kd_barang' => 'required|string|max:9',
            'nama_barang' => 'required|string|max:50',
            'satuan' => 'required|string|max:25',
            'harga' => 'required|integer',
            'jumlah' => 'required|integer',
            'total_harga' => 'required|integer',
            'tanggal' => 'required|date',
        ]);

        $oldJumlah = $barangMasuk->jumlah;
        $barangMasuk->update($request->all());

        $diffJumlah = $barangMasuk->jumlah - $oldJumlah;
        $barang = Barang::where('kd_barang', $barangMasuk->kd_barang)->first();
        if ($barang) {
            $barang->stok += $diffJumlah;
            $barang->save();
        }

        return response()->json(['message' => 'Barang masuk berhasil diperbarui', 'data' => $barangMasuk], Response::HTTP_OK);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $kd_barang_masuk)
    {
        $barangMasuk = BarangMasuk::find($kd_barang_masuk);
        if (!$barangMasuk) {
            return response()->json(['message' => 'Barang masuk tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $barang = Barang::where('kd_barang', $barangMasuk->kd_barang)->first();
        if ($barang) {
            $barang->stok -= $barangMasuk->jumlah;
            $barang->save();
        }

        $barangMasuk->delete();

        return response()->json(['message' => 'Barang masuk berhasil dihapus'], Response::HTTP_OK);
    }
}
