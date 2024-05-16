@extends('layouts.layouts')

@section('component')

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="mb-0">Table Data Pembayaran</h1>
    <div>
        <h5 class="mb-0">Tanggal: {{ \Carbon\Carbon::now('Asia/Jakarta')->format('d F Y') }}</h5>
        <h5 class="mb-0">Jam: {{ \Carbon\Carbon::now('Asia/Jakarta')->format('H:i') }}</h5>
    </div>
</div>
<hr>

<div class="mb-3">
    <input type="text" class="form-control col-4" id="searchInput" placeholder="Cari No Transaksi">
</div>
<div class="card mb-5">
    <div class="card-body">
        <table class="table table-stripped" id="myTable" style="width: 1000px;">
            <thead>
                <tr>
                    <th scope="col">No</th>
                    <th scope="col">No Transaksi</th>
                    <th scope="col">NAMA</th>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Subtotal</th>
                    <th scope="col">Diskon</th>
                    <th scope="col">Total Akhir</th>
                    <th scope="col">STATUS</th>
                    <th scope="col">Detail</th>
                </tr>
            </thead>
            <tbody>
                @foreach($transaksis as $index => $data)
                <tr>
                    <td>{{ $index + 1 }}</td>
                    <td>{{ $data->no_transaksi }}</td>
                    <td>{{ $data->user->nama_user }}</td>
                    <td>{{ $data->tgl_transaksi }}</td>
                    <td>{{ $data->subtotal }}</td>
                    <td>{{ $data->diskon }}</td>
                    <td>{{ $data->total_akhir }}</td>
                    <td> @if($data->status == 'belum_bayar')
                        <button type="button" class="btn btn-warning btn-sm">
                            <i class="fas fa-money-bill"></i> Belum Bayar
                        </button>
                        @elseif($data->status == 'sudah_bayar')
                        <button type="button" class="btn btn-success btn-sm" disabled>
                            <i class="fas fa-check"></i> Sudah Bayar
                        </button>
                        @endif
                    </td>
                    <td>
                        <div class="btn-group" role="group" aria-label="Action Buttons">
                            <button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#detailModal{{ $index }}">
                                <i class="fas fa-eye"></i> Detail
                            </button>
                            <a href="" type="button" class="btn btn-success btn-sm">
                                <i class="fa-solid fa-arrow-up-right-from-square"></i> Bayar
                            </a>
                        </div>
                    </td>
                </tr>
                <!-- Modal -->
                <div class="modal fade" id="detailModal{{ $index }}" role="dialog" aria-labelledby="detailModalLabel{{ $index }}" aria-hidden="true">
                    <div class="modal-dialog modal-md" role="document">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title" id="detailModalLabel{{ $index }}">Detail Transaksi</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <!-- Tampilkan detail transaksi menggunakan kartu -->
                                @foreach($data->transaksiDetail as $detail)
                                <div class="card mb-3">
                                    <div class="card-body">
                                        <h5 class="card-title">Kode Barang: {{ $detail->kd_barang }}</h5>
                                        <p class="card-text">Nama Barang: {{ $detail->barang }}</p>
                                        <p class="card-text">Harga: Rp
                                            {{ number_format($detail->harga, 0, ',', '.') }}
                                        </p>
                                        <p class="card-text">Banyak: {{ $detail->banyak }}</p>
                                        <p class="card-text">Total: Rp
                                            {{ number_format($detail->total, 0, ',', '.') }}
                                        </p>
                                    </div>
                                </div>
                                @endforeach
                            </div>
                            <!-- Informasi Total Akhir -->
                            <div class="modal-footer">
                                <h2 class="text-primary">Total Akhir: Rp
                                    {{ number_format($data->total_akhir, 0, ',', '.') }}
                                </h2>
                            </div>
                            <div class="modal-footer">
                                <h5 class="text-primary">Kembalian: Rp
                                    {{ number_format($data->kembalian, 0, ',', '.') }}
                                </h5>
                            </div>
                            <div class="modal-footer">
                                <!-- Tombol Close -->
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
                @endforeach
            </tbody>
        </table>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        $("#searchInput").on("keyup", function() {
            var value = $(this).val().toLowerCase();
            $("#myTable tbody tr").filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
        });
    });
</script>

@endsection