<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\JenisBarang;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class JenisBarangApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $jenisBarangs = JenisBarang::all();
        return response()->json(['data' => $jenisBarangs], Response::HTTP_OK);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'nama_jenis' => 'required|string|max:255',
        ]);

        $jenisBarang = JenisBarang::create($request->all());

        return response()->json(['data' => $jenisBarang, 'message' => 'Jenis Barang Berhasil Disimpan'], Response::HTTP_OK);
    }


    /**
     * Display the specified resource.
     */
    public function show(string $id_jenis)
    {
        $jenisBarangs = JenisBarang::find($id_jenis);
        if (!$jenisBarangs) {
            return response()->json(['message' => 'Jenis Barang Tidak di temukan'], Response::HTTP_OK);
        }
        return response()->json(['data' => $jenisBarangs], Response::HTTP_OK);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id_jenis)
    {
        $request->validate([
            'nama_jenis' => 'required|string|max:255',
        ]);

        $jenisBarang = JenisBarang::find($id_jenis);
        if (!$jenisBarang) {
            return response()->json(['message' => 'Jenis Barang tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }
        $jenisBarang->update($request->all());

        return response()->json(['message' => 'Jenis Barang Berhasil diupdate', 'data' => $jenisBarang], Response::HTTP_OK);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id_jenis)
    {
        $jenisBarang = JenisBarang::find($id_jenis);
        if (!$jenisBarang) {
            return response()->json(['message' => 'Jenis barang tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $jenisBarang->delete();
        return response()->json(['message' => 'Jenis Barang berhasil dihapus'], Response::HTTP_OK);
    }
}
