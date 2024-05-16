<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Barang;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class BarangApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $barangs = Barang::with(['jenisBarang' => function ($query) {
            $query->select('id_jenis', 'nama_jenis');
        }])->get(['kd_barang', 'nama_barang', 'id_jenis', 'satuan', 'stok', 'harga_pokok', 'ppn', 'harga_jual']);

        return response()->json(['data' => $barangs], Response::HTTP_OK);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'nama_barang' => 'required|string|max:50',
            'id_jenis' => 'required|exists:jenis_barang,id_jenis',
            'satuan' => 'required|string|max:25',
            'stok' => 'required|integer',
            'harga_pokok' => 'required|integer',
            'ppn' => 'required|integer',
            'harga_jual' => 'required|integer',
        ]);

        $barang = Barang::create($request->all());
        return response()->json(['message' => 'Barang Berhasil Di Simpan', 'data' => $barang], Response::HTTP_CREATED);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $kd_barang)
    {
        $barang = Barang::with('jenisBarang')->where('kd_barang', $kd_barang)->first();
        if (!$barang) {
            return response()->json(['message' => 'barang tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }
        return response()->json(['data' => $barang], Response::HTTP_OK);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $kd_barang)
    {
        $barang = Barang::where('kd_barang', $kd_barang)->first();
        if (!$barang) {
            return response()->json(['message' => 'Barang Tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $request->validate([
            'nama_barang' => 'required|string|max:50',
            'id_jenis' => 'required|exists:jenis_barang,id_jenis',
            'satuan' => 'required|string|max:25',
            'stok' => 'required|integer',
            'harga_pokok' => 'required|integer',
            'ppn' => 'required|integer',
            'harga_jual' => 'required|integer',
        ]);

        $barang->update($request->all());

        return response()->json(['message' => 'Barang berhasil diperbarui', 'data' => $barang], Response::HTTP_OK);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $kd_barang)
    {
        $barang = Barang::where('kd_barang', $kd_barang)->first();
        if (!$barang) {
            return response()->json(['message' => 'Barang Tidak Ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $barang->delete();
        return response()->json(['message' => 'Barang Berhasil Dihapus'], Response::HTTP_OK);
    }
}
