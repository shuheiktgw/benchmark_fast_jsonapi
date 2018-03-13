# Benchmark for Netflix/fast_jsonapi

This is a sample Rails application to benchmark [Netflix/fast_jsonapi](https://github.com/Netflix/fast_jsonapi) in a real Rails environment. 

# How it works?
I created `Company has many employees` relationship with `AmsCompany.rb` and `AmsEmployee.rb` for `ActiveModel::Serializer` and `FjaCompany.rb` and `FjaEmployee.rb` for `FastJsonapi`.

All the benchmarks are taken in `spec/serializers/performance_spec.rb`. 

# Result

Fast_jsonapi (FJA) may not be as fast as it is expected to be compared to ActiveModel::Serializer (AMS) depending on situations...?

|  | Serializer | 1 company | 25 companies |
|:-----------:|:------------:|:------------|:------------|
| 1 employee | AMS | 15.811999997822568 | 31.31099999882281 |
| 1 employee | FJA | 13.44200001040008 | 9.640000003855675 |
| 25 employees | AMS | 8.14800000807736 | 111.75599999842234 |
| 25 employees | FJA | 5.560000005061738 | 91.2769999995362 |
| 250 employees | AMS | 54.18900000222493 | 794.873999999254 |
| 250 employees | FJA | 31.94699999585282 | 791.3709999993443 |

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
