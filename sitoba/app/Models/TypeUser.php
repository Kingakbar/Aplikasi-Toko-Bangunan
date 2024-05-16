<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TypeUser extends Model
{
    use HasFactory;

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'jabatan',
    ];

    /**
     * Relationship with User.
     */
    public function users()
    {
        return $this->hasMany(User::class, 'type_user');
    }
}
