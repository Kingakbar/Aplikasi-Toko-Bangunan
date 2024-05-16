@extends('layouts.layouts')

@section('component')
@if(Auth::check() && Auth::user()->type_user == '1')
<h1>Selamat Datang Admin</h1>
@elseif(Auth::check() && Auth::user()->type_user == '2')
<h1>Selamat Datang Manager</h1>
@elseif(Auth::check() && Auth::user()->type_user == '3')
<h1>Selamat Datang Kasir</h1>
@endif
<hr>
<div class="row">
    <div class="col-md-3 mt-4">
        <div class="card">
            <div class="card-body">
                <div class="circle_box">
                    <h5 class="card-title text-center"><span class="ic_box"><i class="fas fa-box fa-5x"></i></span></h5>
                </div>
                <h6 class="text-center mt-2">Informasi Barang</h6>
                <hr>
                <h6 class="card_subtitle">Total barang</h6>
                <h5 class="angka_barang text-center mt-3">{{ $totalBarang }}</h5>


            </div>
            <div class="link_detail">
                <a href="{{ route('barang.index') }}" class="btn-detail">Lihat Detail <i class="fa-solid fa-arrow-right float-right"></i></a>
            </div>
        </div>
    </div>

    <div class="col-md-3 mt-4">
        <div class="card">
            <div class="card-body">
                <div class="circle_up">
                    <h5 class="card-title text-center"><span class="ic_up"><i class="fa-solid fa-arrow-trend-up fa-5x"></i></i></span></h5>
                </div>
                <h6 class="text-center mt-2">Informasi Pendapatan</h6>
                <hr>
                <h6 class="card_subtitle">Total Pendapatan</h6>
                <h5 class="angka_barang text-center mt-3">
                    Rp
                    {{ number_format($totalPendapatan, 0, ',', '.') }}
                </h5>


            </div>
            <div class="link_detail">
                <a href="#" class="btn-detail">Lihat Detail <i class="fa-solid fa-arrow-right float-right"></i></a>
            </div>
        </div>
    </div>

    <div class="col-md-3 mt-4">
        <div class="card">
            <div class="card-body">
                <div class="circle_down">
                    <h5 class="card-title text-center"><span class="ic_down"><i class="fa-solid fa-arrow-trend-down fa-5x"></i></i></span></h5>
                </div>
                <h6 class="text-center mt-2">Informasi Pengeluaran</h6>
                <hr>
                <h6 class="card_subtitle"><span>Total Pengeluaran</span></h6>
                <h5 class="angka_barang text-center mt-3">
                    <span> Rp
                        {{ number_format($totalPengeluaran, 0, ',', '.') }}</span>
                </h5>


            </div>
            <div class="link_detail">
                <a href="#" class="btn-detail">Lihat Detail <i class="fa-solid fa-arrow-right float-right"></i></a>
            </div>
        </div>
    </div>

    <div class="col-md-3 mt-4">
        <div class="card">
            <div class="card-body">
                <div class="circle_user">
                    <h5 class="card-title text-center"><span class="ic_user"><i class="fa-solid fa-user fa-5x"></i></i></span></h5>
                </div>
                <h6 class="text-center mt-2">Informasi User</h6>
                <hr>
                <h6 class="card_subtitle">Total User</h6>
                <h5 class="angka_barang text-center mt-3">
                    {{ $totalUser }}
                </h5>
            </div>
            <div class="link_detail">
                <a href="#" class="btn-detail">Lihat Detail <i class="fa-solid fa-arrow-right float-right"></i></a>
            </div>
        </div>
    </div>
</div>
@endsection