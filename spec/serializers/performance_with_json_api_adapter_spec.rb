require 'rails_helper'

describe 'Serializers Performance with json_api adapter' do
  before(:all) do
    ActiveModel::Serializer.config.adapter = :json_api

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
      puts "#{ company_count } companies"
      puts "#{ employee_count } employees"

      print 'FastJsonapi:              '
      puts Benchmark.measure { FjaCompanySerializer.new(FjaCompany.preload(:fja_employees).all, include: [:fja_employees]).serialized_json }.real * 1000

      print 'ActiveModel::Serializer: '
      puts Benchmark.measure { ActiveModelSerializers::SerializableResource.new(AmsCompany.preload(:ams_employees).all, include: [:ams_employees]).to_json }.real * 1000
    end
  end

  context '1 companies' do
    let(:company_count) { 1 }

    context '1 employees' do
      let(:employee_count) { 1 }

      it_behaves_like 'serialize record'
    end

    context '25 employees' do
      let(:employee_count) { 25 }

      it_behaves_like 'serialize record'
    end

    context '250 employees' do
      let(:employee_count) { 250 }

      it_behaves_like 'serialize record'
    end
  end

  context '25 companies' do
    let(:company_count) { 25 }

    context '1 employees' do
      let(:employee_count) { 1 }

      it_behaves_like 'serialize record'
    end

    context '25 employees' do
      let(:employee_count) { 25 }

      it_behaves_like 'serialize record'
    end

    context '250 employees' do
      let(:employee_count) { 250 }

      it_behaves_like 'serialize record'
    end
  end
end
