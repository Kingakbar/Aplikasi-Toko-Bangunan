@extends('layouts.layouts')

@section('component')

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="mb-0">Table Data Barang</h1>
    <div>
        <h5 class="mb-0">Tanggal: {{ \Carbon\Carbon::now('Asia/Jakarta')->format('d F Y') }}</h5>
        <h5 class="mb-0">Jam: {{ \Carbon\Carbon::now('Asia/Jakarta')->format('H:i') }}</h5>
    </div>
</div>
<hr>
<a href="{{ route('barang.create') }}" class="btn btn-success mt-3 mb-3" style="border-radius: 20px; padding: 10px 20px; font-size: 16px;">
    <i class="fas fa-plus-circle"></i> Tambah Data Barang
</a>
<div class="card mb-5">



    <div class="card-body">
        <div class="table-responsive">
            <table class="table" id="myTable">
                <thead>
                    <tr>
                        <th scope="col">No</th>
                        <th scope="col">KD BARANG</th>
                        <th scope="col">NAMA BARANG</th>
                        <th scope="col">JENIS BARANG</th>
                        <th scope="col">SATUAN</th>
                        <th scope="col">STOK</th>
                        <th scope="col">HARGA POKOK</th>
                        <th scope="col">PPN</th>
                        <th scope="col">HARGA JUAL</th>
                        <th scope="col">ACTION</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($barangs as $index => $data)
                    <tr>
                        <td>{{ $index + 1 }}</td>
                        <td>{{ $data->kd_barang }}</td>
                        <td>{{ $data->nama_barang }}</td>
                        <td>{{ $data->jenisBarang->nama_jenis }}</td>
                        <td>{{ $data->satuan }}</td>
                        <td>{{ $data->stok }}</td>
                        <td>{{ $data->harga_pokok }}</td>
                        <td>{{ $data->ppn }}</td>
                        <td>{{ $data->harga_jual }}</td>
                        <td>
                            <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="#" class="btn btn-primary btn-sm mr-1">Edit</a>
                                <a href="#" class="btn btn-danger btn-sm">Hapus</a>
                            </div>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    @if(Session::has('success'))
    toastr.success("{{ Session::get('success') }}")
    @endif
</script>

@endsection