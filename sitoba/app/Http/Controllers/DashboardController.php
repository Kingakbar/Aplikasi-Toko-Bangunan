<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Barang;
use App\Models\Keuangan;
use App\Models\Transaksi;
use Illuminate\Http\Request;
use App\Models\TransaksiDetail;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class DashboardController extends Controller
{
    public function index()
    {
        // Mengambil total pendapatan masuk dari tabel keuangan
        $totalPendapatan = Keuangan::whereNotNull('masuk')->sum('masuk');
        $totalPengeluaran = Keuangan::whereNotNull('keluar')->sum('keluar');
        // Mengambil total barang dari tabel barang
        $totalBarang = Barang::count();
        $totalUser = User::count();

        // Meneruskan total pendapatan dan total barang ke view
        return view('pages.index', [
            'totalPendapatan' => $totalPendapatan,
            'totalPengeluaran' => $totalPengeluaran,
            'totalBarang' => $totalBarang,
            'totalUser' => $totalUser,
        ]);
    }





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

        $transaksiDetail = TransaksiDetail::create($request->all());

        return response()->json(['message' => 'Transaksi berhasil ditambahkan.', 'transaksi' => $transaksiDetail]);
    }

    public function tampildata()
    {
        $barangs = Barang::all();


        return view('pages.tampildatabarnag', compact('barangs'));
    }

    public function add()
    {

        $barangs = Barang::all();


        $detailtransaksi = TransaksiDetail::all();

        return view('pages.test', compact('barangs', 'detailtransaksi'));
    }

    public function processPayment(Request $request)
    {

        $transaksiData = $request->input('transaksiData');
        $diskon = $request->input('diskon');
        $bayar = $request->input('bayar');
        $kembalian = $request->input('kembalian');


        DB::beginTransaction();

        try {

            $transaksi = Transaksi::create([
                'tgl_transaksi' => now(),
                'subtotal' => $this->calculateSubtotal($transaksiData),
                'diskon' => $diskon,
                'total_akhir' => $this->calculateTotalAkhir($transaksiData, $diskon),
                'bayar' => $bayar,
                'kembalian' => $kembalian,
            ]);


            foreach ($transaksiData as $data) {
                $transaksiDetail = new TransaksiDetail([
                    'kd_barang' => $data['kd_barang'],
                    'barang' => $data['barang'],
                    'harga' => $data['harga'],
                    'banyak' => $data['banyak'],
                    'total' => $data['total'],
                ]);


                $this->reduceStock($data['kd_barang'], $data['banyak']);


                $transaksi->transaksiDetail()->save($transaksiDetail);
            }


            DB::commit();


            return response()->json(['message' => 'Pembayaran berhasil diproses.', 'no_transaksi' => $transaksi->no_transaksi]);
        } catch (\Exception $e) {

            DB::rollBack();


            return response()->json(['error' => 'Gagal memproses pembayaran.'], 500);
        }
    }


    private function reduceStock($kd_barang, $banyak)
    {
        $barang = Barang::findOrFail($kd_barang);
        $stok_sekarang = $barang->stok;
        $stok_terbaru = $stok_sekarang - $banyak;


        if ($stok_terbaru < 0) {
            throw new \Exception('Stok barang tidak mencukupi');
        }


        $barang->update(['stok' => $stok_terbaru]);
    }


    private function calculateSubtotal($transaksiData)
    {
        $subtotal = 0;
        foreach ($transaksiData as $data) {
            $subtotal += $data['total'];
        }
        return $subtotal;
    }


    private function calculateTotalAkhir($transaksiData, $diskon)
    {

        $subtotal = $this->calculateSubtotal($transaksiData);


        $totalAkhir = $subtotal - ($diskon / 100) * $subtotal;

        return $totalAkhir;
    }
    public function detailTransaksi()
    {
        return view('pages.test2');
    }
}
