@extends('layouts.sesilayouts')

@section('component')
<!-- ini adalah form login -->
<div class="login_form container py-5">
    <div class="login_box w-50 center border rounded px-3 py-3 mx-auto">
        @if($errors->any())
            <div class="alert alert-danger">
                <ul>
                    @foreach($errors->all() as $item )
                        <li>{{ $item }}</li>
                    @endforeach
                </ul>
            </div>
        @endif
        <h1>Login</h1>
        <p>Selamat Datang Kembali Silahkan Login!</p>
        <form action="" method="POST">
            @csrf
            <div class="mb-3 mt-5">
                <label for="username" class="form-label">Username</label>
                <input type="text" value="{{ old('username') }}" name="username" class="form-control">
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" name="password" class="form-control">
            </div>
            <div class="mb-3 d-grid">
                <button name="submit" type="submit" class="btn btn-primary  mt-3" style="width: 100%;">Login</button>
            </div>
        </form>

        <div class="mb-3 d-grid">
            <button name="submit" type="submit" class="btn register mt-1" style="width: 100%;">Register</button>
        </div>
    </div>
</div>
<!-- ini adalah akhir dari form login -->
@endsection
