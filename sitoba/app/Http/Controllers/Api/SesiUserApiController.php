<?php

namespace App\Http\Controllers\Api;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use PhpParser\Node\Stmt\Return_;

class SesiUserApiController extends Controller
{

    public function index()
    {
        return view('pages.login');
    }


    public function login(Request $request)
    {
        $request->validate([
            'username' => 'required',
            'password' => 'required|min:8'
        ]);

        $credentials = $request->only('username', 'password');

        if (!Auth::attempt($credentials)) {
            return response()->json([
                'data' => null,
                'meta' => [
                    'status' => 'error',
                    'message' => 'Unauthorized',
                ]
            ], 401);
        }

        $user = Auth::user();

        if (!Hash::check($request->password, $user->password)) {
            throw new \Exception('Invalid Credentials');
        }

        $tokenResult = $user->createToken('authToken')->plainTextToken;


        $data = [
            'access_token' => $tokenResult,
            'token_type' => 'Bearer',
            'user' => $user
        ];


        $meta = [
            'status' => 'success',
            'message' => 'Authenticated',
        ];

        return response()->json(['data' => $data, 'meta' => $meta], 200);
    }


    public function register(Request $request)
    {

        $request->validate([
            'nama_user' => 'required|string|max:50',
            'jk_user' => 'required|string|max:9',
            'alamat_user' => 'required|string',
            'no_telp_user' => 'required|string|max:13',
            'username' => 'required|string|max:20|unique:users',
            'password' => 'required|string|min:8',

        ]);


        $user = new User([
            'nama_user' => $request->nama_user,
            'jk_user' => $request->jk_user,
            'alamat_user' => $request->alamat_user,
            'no_telp_user' => $request->no_telp_user,
            'username' => $request->username,
            'password' => Hash::make($request->password),
            'type_user' => '1',
        ]);


        $user->save();

        $tokenResult = $user->createToken('authToken')->plainTextToken;


        $data = [
            'access_token' => $tokenResult,
            'token_type' => 'Bearer',
            'user' => $user,
        ];


        $meta = [
            'status' => 'success',
            'message' => 'User registered successfully',
        ];

        return response()->json(['data' => $data, 'meta' => $meta], 200);
    }



    public function show($id)
    {
        $user = User::with('typeUser')->find($id);

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        return response()->json(['user' => $user], 200);
    }


    public function logout(Request $request)
    {
        $token = $request->user()->currentAccessToken()->delete();

        return response()->json([
            'token' => $token,
            'message' => 'Token Revoked'
        ], 200);
    }
}
