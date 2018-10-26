<?php

/*
|--------------------------------------------------------------------------
| Model Factories
|--------------------------------------------------------------------------
|
| Here you may define all of your model factories. Model factories give
| you a convenient way to create models for testing and seeding your
| database. Just tell the factory how a default model should look.
|
*/

use App\Flipper\AttributeValues\AttributeValue;

/** @var \Illuminate\Database\Eloquent\Factory $factory */
$factory->define(AttributeValue::class, function (Faker\Generator $faker) {
    return [
        'value' => $faker->unique()->word,
        'attribute_id' => 1,
        'item_id'=>1,
        'branch_id'=>1
    ];
});