<!-- resources/views/pages/test.blade.php -->

@extends('layouts.layouts')

@section('component')
<h1><a href="{{ route('index') }}">Lihat detail</a></h1>
<div class="card">
    <div class="card-body">
        <form id="transaksiForm">
            @csrf
            <div class="row mb-3">
                <div class="col">
                    <!-- Dropdown untuk memilih barang -->
                    <select class="form-control" id="selectBarang">
                        <option value="">Pilih Barang</option>
                        @foreach($barangs as $barang)
                            <option value="{{ $barang->kd_barang }}" data-kode="{{ $barang->kd_barang }}"
                                data-nama="{{ $barang->nama_barang }}" data-harga="{{ $barang->harga_jual }}">
                                {{ $barang->nama_barang }}
                            </option>
                        @endforeach
                    </select>
                </div>
                <div class="col">
                    <input type="text" class="form-control" id="kd_barang" placeholder="Kode Barang" readonly>
                </div>
                <div class="col">
                    <input type="text" class="form-control" id="barang" placeholder="Barang" readonly>
                </div>
                <div class="col">
                    <input type="text" class="form-control" id="harga" placeholder="Harga" readonly>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col">
                    <input type="text" class="form-control" id="banyak" placeholder="Banyak" oninput="updateTotal()">
                </div>
                <div class="col">
                    <!-- Tempat untuk menampilkan total -->
                    <input type="text" class="form-control" id="total" placeholder="Total" readonly>
                </div>
                <div class="col">
                    <button type="button" class="btn btn-primary" onclick="addTransaksi()">Tambah</button>
                    <button type="button" class="btn btn-danger" onclick="resetForm()">Reset</button>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="card mt-5">
    <div class="card-body">
        <h5 class="card-title">Pembayaran</h5>
        <div class="row">
            <div class="col">
                <input type="text" class="form-control" id="diskon" placeholder="Diskon (%)"
                    oninput="updateTotalAkhir()">
            </div>
            <div class="col">
                <input type="text" class="form-control" id="bayar" placeholder="Bayar" oninput="updateKembalian()">
            </div>
            <div class="col">
                <input type="text" class="form-control" id="kembalian" placeholder="Kembalian" readonly>
            </div>
            <div class="col">
                <button type="button" class="btn btn-success" onclick="processPayment()">Bayar</button>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col">
                <p>Total Akhir: <span id="total-akhir"></span></p>
            </div>
        </div>
    </div>
</div>

<table class="table mt-5 mb-5 table-dark" id="transaksiTable">
    <thead>
        <tr>
            <th scope="col">No</th>
            <th scope="col">Kode Barang</th>
            <th scope="col">Barang</th>
            <th scope="col">Harga</th>
            <th scope="col">Banyak</th>
            <th scope="col">Total</th>
        </tr>
    </thead>
    <tbody id="transaksiBody">
    </tbody>
</table>

<script>
    let transaksiData = [];

    function addTransaksi() {
        const kd_barang = document.getElementById('kd_barang').value;
        const barang = document.getElementById('barang').value;
        const harga = document.getElementById('harga').value;
        const banyak = document.getElementById('banyak').value;
        const total = document.getElementById('total').value;

        const transaksi = {
            kd_barang: kd_barang,
            barang: barang,
            harga: harga,
            banyak: banyak,
            total: total
        };

        // Menambahkan transaksi baru ke dalam array
        transaksiData.push(transaksi);
        updateTable();
        updatePaymentInput(); // Memperbarui input pembayaran
        updateTotalAkhir(); // Memperbarui total akhir setelah penambahan transaksi
    }

    function updateTable() {
        const transaksiBody = document.getElementById('transaksiBody');
        transaksiBody.innerHTML = ''; // Bersihkan isi tabel

        // Update isi tabel dengan data transaksi
        transaksiData.forEach((transaksi, index) => {
            const row = `<tr>
                            <td>${index + 1}</td>
                            <td>${transaksi.kd_barang}</td>
                            <td>${transaksi.barang}</td>
                            <td>${transaksi.harga}</td>
                            <td>${transaksi.banyak}</td>
                            <td>${transaksi.total}</td>
                        </tr>`;
            transaksiBody.insertAdjacentHTML('beforeend', row);
        });
    }

    function updatePaymentInput() {
        const totalBayar = transaksiData.reduce((acc, transaksi) => acc + parseInt(transaksi.total), 0);
        document.getElementById('bayar').value = totalBayar;
    }

    function processPayment() {
        const diskon = parseInt(document.getElementById('diskon').value) || 0;
        const bayar = parseInt(document.getElementById('bayar').value) || 0;

        const subtotal = transaksiData.reduce((acc, transaksi) => acc + parseInt(transaksi.total), 0);
        const totalAkhir = subtotal - ((diskon / 100) * subtotal); // Diskon dihitung sebagai persentase

        const kembalian = bayar - totalAkhir;

        if (kembalian >= 0) {
            alert('Pembayaran berhasil diproses.');
            // Reset form dan data transaksi setelah pembayaran berhasil
            window.location.href =
                "{{ route('index') }}"; // Redirect ke halaman lain setelah pembayaran berhasil
        } else {
            alert('Uang yang dibayarkan kurang.');
        }
    }


    function resetForm() {
        transaksiData = [];
        updateTable();
        document.getElementById('diskon').value = '';
        document.getElementById('bayar').value = '';
        document.getElementById('kembalian').value = ''; // Reset juga kembalian
        updateTotalAkhir(); // Reset juga total akhir
    }

    function updateTotal() {
        const harga = parseInt(document.getElementById('harga').value);
        const banyak = parseInt(document.getElementById('banyak').value);
        let total = isNaN(harga) || isNaN(banyak) ? '' : (harga * banyak);

        document.getElementById('total').value = total;
    }

    function updateTotalAkhir() {
        const totalTransaksi = transaksiData.reduce((acc, transaksi) => acc + parseInt(transaksi.total), 0);
        const diskon = parseInt(document.getElementById('diskon').value) || 0;
        const totalAkhir = totalTransaksi - ((diskon / 100) * totalTransaksi); // Diskon dihitung sebagai persentase

        // Format total akhir ke dalam format mata uang Rupiah (Rp) tanpa desimal
        const formattedTotalAkhir = new Intl.NumberFormat('id-ID', {
            style: 'currency',
            currency: 'IDR',
            maximumFractionDigits: 0 // Hilangkan angka desimal
        }).format(totalAkhir);

        document.getElementById('total-akhir').innerText = formattedTotalAkhir;

        // Perbarui kembalian setelah perubahan total akhir
        updateKembalian();
    }


    function updateKembalian() {
        const totalAkhirText = document.getElementById('total-akhir').innerText;
        const totalAkhir = parseInt(totalAkhirText.replace('Rp', '').replace(/\./g, '').replace(',', ''));

        const bayar = parseInt(document.getElementById('bayar').value) || 0;

        // Hitung kembalian (bayar - total akhir)
        let kembalian = bayar - totalAkhir;

        // Pastikan kembalian tidak negatif
        kembalian = Math.max(0, kembalian);

        // Format kembalian ke dalam format mata uang Rupiah (Rp)
        const formattedKembalian = new Intl.NumberFormat('id-ID', {
            style: 'currency',
            currency: 'IDR'
        }).format(kembalian);

        document.getElementById('kembalian').value = formattedKembalian;
    }







    document.getElementById('selectBarang').addEventListener('change', function () {
        const selectedOption = this.options[this.selectedIndex];
        const kodeBarang = selectedOption.dataset.kode;
        const namaBarang = selectedOption.dataset.nama;
        const hargaBarang = selectedOption.dataset.harga;

        document.getElementById('kd_barang').value = kodeBarang;
        document.getElementById('barang').value = namaBarang;
        document.getElementById('harga').value = hargaBarang;

        // Panggil fungsi updateTotal() setiap kali opsi barang dipilih
        updateTotal();
    });

</script>

@endsection
