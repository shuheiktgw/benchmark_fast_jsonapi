# Benchmark for Netflix/fast_jsonapi

This is a sample Rails application to benchmark [Netflix/fast_jsonapi](https://github.com/Netflix/fast_jsonapi) in a real Rails environment. 

# How it works?
I created `Company has many employees` relationship with `AmsCompany.rb` and `AmsEmployee.rb` to test `ActiveModel::Serializer`,  and `FjaCompany.rb` and `FjaEmployee.rb` to test `FastJsonapi`.

Also, for `ActiveModel::Serializer` I used two adapters, `default adapter` and `json_api adapter`. `json_api adapter` formats the result in the similar form to Json:API.


All the benchmarks are taken in `spec/serializers/performance_with_json_api_adapter_spec.rb` and `performance_with_default_adapter_spec.rb`.  

# Results

### `FastJsonapi` (FJA) against`ActiveModel::Serializer` (AMS) with `json_api adapter`

|  | Serializer | 1 company | 25 companies |
|:-----------:|:------------:|:------------|:------------|
| 1 employee | AMS | 32.995999999911874 | 60.81799999992654 |
| 1 employee | FJA | 19.072999999934837 | 8.621999999832042 |
| 25 employees | AMS | 35.11500000013257 | 577.1009999998569 |
| 25 employees | FJA | 6.498000000192405 | 85.53800000026968 |
| 250 employees | AMS | 246.90600000030827 | 5089.174999999614 |
| 250 employees | FJA | 32.62899999981528 | 754.1630000000623 |

### `FastJsonapi` against`ActiveModel::Serializer` with `default adapter`

|  | Serializer | 1 company | 25 companies |
|:-----------:|:------------:|:------------|:------------|
| 1 employee | AMS | 15.873000000283355 | 24.73100000042905 |
| 1 employee | FJA | 16.28900000014255 | 8.800000000519503 |
| 25 employees | AMS | 7.133000000067113 | 134.71600000048056 |
| 25 employees | FJA | 6.07899999977235 | 84.16800000031799 |
| 250 employees | AMS | 52.87399999997433 | 855.4990000002363 |
| 250 employees | FJA | 31.502000000728003 | 1261.395999999877 |

The results above show two things.

1. `FastJsonapi` is about 4 - 7 times faster than`ActiveModel::Serializer` with `json_api adapter`.
2. `FastJsonapi` is about 1.5 times faster than`ActiveModel::Serializer` with `default adapter`. 

# How to take a benchmark?

Install dependencies first.

```
$ bundle install 
```

Then create tables.

```
$ bundle ex rake db:create
$ bundle ex rake db:migrate
$ bundle ex rake db:migrate RIALS_ENV=test 
```

Finally run spec.

```
$ bundle ex rspec
```
