require 'rails_helper'
require 'profiler'
require 'rblineprof'
require 'rblineprof-report'

describe 'Serializers Performance with default adapter' do
  before(:all) do
    class AmsCompanySerializer < ActiveModel::Serializer
      attributes :name, :updated_at, :created_at

      has_many :ams_employees
    end

    class AmsEmployeeSerializer < ActiveModel::Serializer
      attributes :name, :position, :age, :updated_at, :created_at

      belongs_to :ams_company
    end

    class FjaCompanySerializer
      include FastJsonapi::ObjectSerializer

      attributes :name, :updated_at, :created_at

      has_many :fja_employees
    end

    class FjaEmployeeSerializer
      include FastJsonapi::ObjectSerializer

      attributes :name, :position, :age, :updated_at, :created_at

      belongs_to :fja_company
    end
  end

  before(:all) { GC.disable }
  after(:all) { GC.enable }

  before do
    ams_companies = create_list(:ams_company, company_count)
    ams_companies.each do |ams_company|
      create_list(:ams_employee, employee_count, ams_company: ams_company)
    end

    fja_companies = create_list(:fja_company, company_count)
    fja_companies.each do |fja_company|
      create_list(:fja_employee, employee_count, fja_company: fja_company)
    end
  end

  shared_examples 'serialize record' do
    it 'should serialize record' do
      puts '--------------------------------------------------------------------------------------------------------'
      puts
      puts
      puts 'FastJsonapi'

      puts (Benchmark.measure { FjaCompanySerializer.new(FjaCompany.preload(:fja_employees).all, include: [:fja_employees]).serialized_json }.real * 1000).to_s + ' ms'

      puts
      puts
      puts '--------------------------------------------------------------------------------------------------------'
      puts
      puts
      puts 'ActiveModelSerializers with default adaptor'

      ActiveModel::Serializer.config.adapter = :attributes
      puts (Benchmark.measure { ActiveModelSerializers::SerializableResource.new(AmsCompany.preload(:ams_employees).all, include: [:ams_employees]).to_json }.real * 1000).to_s + ' ms'

      puts
      puts
      puts '--------------------------------------------------------------------------------------------------------'
      puts
      puts
      puts 'ActiveModelSerializers with json_api adaptor'

      ActiveModel::Serializer.config.adapter = :json_api
      puts (Benchmark.measure { ActiveModelSerializers::SerializableResource.new(AmsCompany.preload(:ams_employees).all, include: [:ams_employees]).to_json }.real * 1000).to_s + ' ms'
    end
  end

  shared_examples 'serialize record with profiler' do
    it 'should serialize record' do
      puts
      puts
      puts '--------------------------------------------------------------------------------------------------------'
      puts
      puts
      puts 'FastJsonapi'

      Profiler__::start_profile
      FjaCompanySerializer.new(FjaCompany.preload(:fja_employees).all, include: [:fja_employees]).serialized_json
      Profiler__::print_profile(STDERR)
      Profiler__::stop_profile


      puts
      puts
      puts '--------------------------------------------------------------------------------------------------------'
      puts
      puts
      puts 'ActiveModelSerializers with default adaptor'

      ActiveModel::Serializer.config.adapter = :attributes
      Profiler__::start_profile
      ActiveModelSerializers::SerializableResource.new(AmsCompany.preload(:ams_employees).all).to_json
      Profiler__::print_profile(STDERR)
      Profiler__::stop_profile

      puts
      puts
      puts '--------------------------------------------------------------------------------------------------------'
      puts
      puts
      puts 'ActiveModelSerializers with json_api adaptor'

      ActiveModel::Serializer.config.adapter = :json_api
      Profiler__::start_profile
      ActiveModelSerializers::SerializableResource.new(AmsCompany.preload(:ams_employees).all).to_json
      Profiler__::print_profile(STDERR)
      Profiler__::stop_profile
    end
  end

  shared_examples 'serialize record with line profiler' do
    it 'should serialize record' do
      puts
      puts
      puts '--------------------------------------------------------------------------------------------------------'
      puts
      puts
      puts 'FastJsonapi'

      fja_profile = lineprof(/./) do
        FjaCompanySerializer.new(FjaCompany.preload(:fja_employees).all, include: [:fja_employees]).serialized_json
      end

      LineProf.report(fja_profile)

      puts
      puts
      puts '--------------------------------------------------------------------------------------------------------'
      puts
      puts
      puts 'ActiveModelSerializers with default adaptor'


      ActiveModel::Serializer.config.adapter = :attributes

      asm_profile_default = lineprof(/./) do
        ActiveModelSerializers::SerializableResource.new(AmsCompany.preload(:ams_employees).all).to_json
      end

      LineProf.report(asm_profile_default)

      puts
      puts
      puts '--------------------------------------------------------------------------------------------------------'
      puts
      puts
      puts 'ActiveModelSerializers with json_api adaptor'

      ActiveModel::Serializer.config.adapter = :json_api
      asm_profile_json = lineprof(/./) do
        ActiveModelSerializers::SerializableResource.new(AmsCompany.preload(:ams_employees).all).to_json
      end

      LineProf.report(asm_profile_json)
    end
  end

  context '1 companies' do
    let(:company_count) { 1 }

    context '250 employees' do
      let(:employee_count) { 250 }

      it_behaves_like 'serialize record'
      it_behaves_like 'serialize record with profiler'
      it_behaves_like 'serialize record with line profiler'
    end
  end
end
