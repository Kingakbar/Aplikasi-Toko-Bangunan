<?php

namespace App\Http\Controllers\Api;

use App\Models\Keuangan;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Http\Controllers\Controller;

class KeuanganApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $keuangan = Keuangan::all();
        return response()->json(['data' => $keuangan], Response::HTTP_OK);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'tanggal' => 'required|date',
            'jenis_keuangan' => 'required|string',
            'masuk' => 'nullable|integer',
            'keluar' => 'nullable|integer',
        ]);

        $keuangan = Keuangan::create($request->all());

        return response()->json(['data' => $keuangan], Response::HTTP_CREATED);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id_keuangan)
    {
        $keuangan = Keuangan::find($id_keuangan);
        if (!$keuangan) {
            return response()->json(['Data Keuangan Tidak Dapat ditemukan'], Response::HTTP_NOT_FOUND);
        }
        return response()->json(['data' => $keuangan], Response::HTTP_OK);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id_keuangan)
    {
        $keuangan = Keuangan::find($id_keuangan);
        if (!$keuangan) {
            return response()->json(['Data Keuangan Tidak Dapat ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $request->validate([
            'tanggal' => 'required|date',
            'jenis_keuangan' => 'required|string',
            'masuk' => 'nullable|integer',
            'keluar' => 'nullable|integer',
        ]);

        $keuangan->update($request->all());
        return response()->json(['message' => 'Data Keuangan Berhasl di Update', 'data' => $keuangan], Response::HTTP_OK);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id_keuangan)
    {
        $keuangan = Keuangan::find($id_keuangan);
        if (!$keuangan) {
            return response()->json(['Data Keuangan Tidak Dapat ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $keuangan->delete();
        return response()->json(['message' => 'Data Keuangan berhasil dihapus'], Response::HTTP_OK);
    }
}
