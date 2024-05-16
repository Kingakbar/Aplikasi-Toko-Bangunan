@extends('layouts.layouts')

@section('component')

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="mb-0">Tambah Data Barang</h1>
    <div>
        <h5 class="mb-0">Tanggal: {{ \Carbon\Carbon::now('Asia/Jakarta')->format('d F Y') }}</h5>
        <h5 class="mb-0">Jam: {{ \Carbon\Carbon::now('Asia/Jakarta')->format('H:i') }}</h5>
    </div>
</div>
<hr>
<a href="{{ route('barang.index') }}" class="btn btn-danger mt-3 mb-3" style="border-radius: 20px; padding: 10px 20px; font-size: 16px;">
    <i class="fas fa-arrow-circle-left"></i> Kembali
</a>

<div class="card mb-5">
    <div class="card-body">
        @if ($errors->any())
        <div class="alert alert-danger">
            <ul>
                @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
        @endif

        <form action="{{ route('barang.store') }}" method="POST">
            @csrf

            <div class="row">
                <div class="col-lg-12">
                    <div class="form-group">
                        <label for="nama_barang">NAMA BARANG</label>
                        <input type="text" class="form-control" id="nama_barang" name="nama_barang" maxlength="50" required>
                    </div>
                </div>
                <div class="col-lg-12">
                    <div class="form-group">
                        <label for="jenis_barang">JENIS BARANG</label>
                        <select class="form-control" id="jenis_barang" name="id_jenis" required>
                            <option>Pilih Jenis Barang</option>
                            @foreach($jenisBarang as $jenis)
                            <option value="{{ $jenis->id_jenis }}">{{ $jenis->nama_jenis }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <div class="col-lg-12">
                    <div class="form-group">
                        <label for="satuan">SATUAN</label>
                        <input type="text" class="form-control" id="satuan" name="satuan" maxlength="25" required>
                    </div>
                </div>
                <div class="col-lg-12">
                    <div class="form-group">
                        <label for="stok">STOK</label>
                        <input type="number" class="form-control" id="stok" name="stok" min="0" required>
                    </div>
                </div>
                <div class="col-lg-12">
                    <div class="form-group">
                        <label for="harga_pokok">HARGA POKOK</label>
                        <input type="number" class="form-control" id="harga_pokok" name="harga_pokok" min="0" required>
                    </div>
                </div>
                <div class="col-lg-12">
                    <div class="form-group">
                        <label for="ppn">PPN</label>
                        <input type="number" class="form-control" id="ppn" name="ppn" min="0" required>
                    </div>
                </div>
                <div class="col-lg-12">
                    <div class="form-group">
                        <label for="harga_jual">HARGA JUAL</label>
                        <input type="number" class="form-control" id="harga_jual" name="harga_jual" min="0" required>
                    </div>
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Simpan</button>
        </form>
    </div>
</div>

@endsection