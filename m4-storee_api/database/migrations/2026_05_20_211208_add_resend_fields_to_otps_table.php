<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('otps', function (Blueprint $table) {

            $table->integer('resend_count')
                ->default(0);

            $table->timestamp('blocked_until')
                ->nullable();

        });
    }

    public function down(): void
    {
        Schema::table('otps', function (Blueprint $table) {

            $table->dropColumn('resend_count');

            $table->dropColumn('blocked_until');

        });
    }
};