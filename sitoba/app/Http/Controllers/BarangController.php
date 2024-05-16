<?php

namespace App\Http\Controllers;

use App\Models\Barang;
use App\Models\JenisBarang;
use Illuminate\Http\Request;

class BarangController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $barangs = Barang::with('jenisBarang')->get();
        return view('pages.barangpage.barang_page', compact('barangs'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $jenisBarang = JenisBarang::all();
        return view('pages.barangpage.create_barang', compact('jenisBarang'));
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

        try {

            $barang = new Barang([
                'nama_barang' => $request->nama_barang,
                'id_jenis' => $request->id_jenis,
                'satuan' => $request->satuan,
                'stok' => $request->stok,
                'harga_pokok' => $request->harga_pokok,
                'ppn' => $request->ppn,
                'harga_jual' => $request->harga_jual,
            ]);

            $barang->save();


            return redirect()->route('barang.index')->with('success', 'Barang berhasil disimpan');
        } catch (\Exception $e) {
            // Handle exception
            dd($e->getMessage()); // Menampilkan pesan error
            return back()->withInput()->withErrors(['error' => 'Gagal menyimpan data barang']);
        }
    }


    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
