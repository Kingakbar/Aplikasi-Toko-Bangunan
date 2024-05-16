<?php

namespace App\Http\Controllers\Api;

use App\Models\TypeUser;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Http\Controllers\Controller;

class TypeUserApiController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $typeUsers = TypeUser::all();
        return response()->json(['data' => $typeUsers], Response::HTTP_OK);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'jabatan' => 'required|string|max:7'
        ]);

        $typeUser = TypeUser::create($request->all());
        return response()->json(['message' => 'Type user berhasil ditambahkan', 'data' => $typeUser], Response::HTTP_CREATED);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $typeUser = TypeUser::find($id);
        if (!$typeUser) {
            return response()->json(['message' => 'Type user tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }
        return response()->json(['data' => $typeUser], Response::HTTP_OK);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $typeUser = TypeUser::find($id);
        if (!$typeUser) {
            return response()->json(['message' => 'Type user tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $request->validate([
            'jabatan' => 'required|string|max:7'
        ]);

        $typeUser->update($request->all());
        return response()->json(['message' => 'Type user berhasil diperbarui', 'data' => $typeUser], Response::HTTP_OK);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $typeUser = TypeUser::find($id);
        if (!$typeUser) {
            return response()->json(['message' => 'Type user tidak ditemukan'], Response::HTTP_NOT_FOUND);
        }

        $typeUser->delete();
        return response()->json(['message' => 'Type user berhasil dihapus'], Response::HTTP_OK);
    }
}
