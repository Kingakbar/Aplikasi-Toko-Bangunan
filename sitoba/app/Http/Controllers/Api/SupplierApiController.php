<?php

namespace App\Http\Controllers\Api;

use App\Models\Supplier;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Http\Controllers\Controller;

class SupplierApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $suppliers = Supplier::all();
        return response()->json(['data' => $suppliers], Response::HTTP_OK);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'nama_supplier' => 'required|string|max:255',
            'alamat_supplier' => 'required|string|max:255',
            'no_telp_supplier' => 'required|string|max:15',
        ]);

        $supplier = Supplier::create($request->all());
        return response()->json(['message' => 'Supplier berhasil ditambahkan', 'data' => $supplier], Response::HTTP_CREATED);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $kd_supplier)
    {
        $supplier = Supplier::find($kd_supplier);
        if (!$supplier) {
            return response()->json(['message' => 'Supplier Tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }
        return response()->json(['data' => $supplier], Response::HTTP_OK);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $kd_supplier)
    {
        $supplier = Supplier::find($kd_supplier);
        if (!$supplier) {
            return response()->json(['message' => 'Supplier Tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $request->validate([
            'nama_supplier' => 'required|string|max:255',
            'alamat_supplier' => 'required|string|max:255',
            'no_telp_supplier' => 'required|string|max:15',
        ]);

        $supplier->update($request->all());

        return response()->json(['message' => 'Supplier berhasil diperbarui', 'data' => $supplier], Response::HTTP_OK);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $kd_supplier)
    {
        $supplier = Supplier::find($kd_supplier);
        if (!$supplier) {
            return response()->json(['message' => 'Supplier Tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $supplier->delete();
        return response()->json(['message' => 'Supplier berhasil dihapus'], Response::HTTP_OK);
    
    }
}
