require 'rails_helper'

RSpec.describe "AntiFrauds", type: :request do
  describe "POST /anti_frauds" do
    context 'when transactions is valid' do
      before do
        create(:score_anti_fraud)
        Transaction.destroy_all
      end

      let(:params) do
        {
          transactions: [
            {
              transaction_id: 21320398,
              merchant_id: 29744,
              user_id: 97051,
              card_number: "434505******9116",
              transaction_date: Time.now.change(hour: 21, min: 00, sec: 0).to_s,
              transaction_amount: 374.56,
              device_id: 285475
            }
          ]
        }
      end

      it "returns approve" do
        post anti_frauds_url, params: params

        expect(JSON.parse(response.body))
        .to eq({ 
          "data" => [
            {
              "transaction_id" => "21320398",
              "recommendation" => "approve"
            }
          ]
        })
      end
    end

    context 'when user is trying too many transactions in a row' do
      let(:params) do
        {
          transactions: [
            {
              transaction_id: 2342358,
              merchant_id: 29744,
              user_id: 97052,
              card_number: "434505******9116",
              transaction_date: Time.now.change(hour: 13, min: 00, sec: 0).to_s,
              transaction_amount: 51,
              device_id: 285475
            },
            {
              transaction_id: 2342378,
              merchant_id: 29744,
              user_id: 97052,
              card_number: "434505******9116",
              transaction_date: Time.now.change(hour: 13, min: 00, sec: 0).to_s,
              transaction_amount: 50,
              device_id: 285475
            }
          ]
        }
      end

      it "returns deny" do
        post anti_frauds_url, params: params

        expect(JSON.parse(response.body))
        .to eq({ 
          "data" => [
            {
              "transaction_id" => "2342358",
              "recommendation" => "deny"
            },
            {
              "transaction_id" => "2342378",
              "recommendation" => "deny"
            }
          ]
        })
      end
    end

    context 'when transactions above a certain amount in a given period' do
      let(:params) do
        {
          transactions: [
            {
              transaction_id: 2342390,
              merchant_id: 29744,
              user_id: 97053,
              card_number: "434505******9116",
              transaction_date: Time.now.change(hour: 1, min: 00, sec: 0).to_s,
              transaction_amount: 2000,
              device_id: 285475
            }
          ]
        }
      end

      it "returns deny" do
        post anti_frauds_url, params: params

        expect(JSON.parse(response.body))
        .to eq({ 
          "data" => [
            {
              "transaction_id" => "2342390",
              "recommendation" => "deny"
            }
          ]
        })
      end
    end

    context 'when user had a chargeback before' do
      before do
        create(:transaction, user_id: 97091, has_cbk: 'TRUE')
      end

      let(:params) do
        {
          transactions: [
            {
              transaction_id: 2343990,
              merchant_id: 29744,
              user_id: 97091,
              card_number: "434505******9116",
              transaction_date: Time.now.change(hour: 14, min: 00, sec: 0).to_s,
              transaction_amount: 2000,
              device_id: 285475
            }
          ]
        }
      end

      it "returns deny" do
        post anti_frauds_url, params: params

        expect(JSON.parse(response.body))
        .to eq({ 
          "data" => [
            {
              "transaction_id" => "2343990",
              "recommendation" => "deny"
            }
          ]
        })
      end
    end

    context 'when transactions had score above of median validation' do
      before do
        create(:score_anti_fraud)
      end

      let(:params) do
        {
          transactions: [
            {
              transaction_id: 2342390,
              merchant_id: 29744,
              user_id: 97054,
              card_number: "434505******9116",
              transaction_date: Time.now.change(hour: 13, min: 00, sec: 0).to_s,
              transaction_amount: 2000,
              device_id: 285475
            }
          ]
        }
      end

      it "returns deny" do
        post anti_frauds_url, params: params

        expect(JSON.parse(response.body))
        .to eq({ 
          "data" => [
            {
              "transaction_id" => "2342390",
              "recommendation" => "deny"
            }
          ]
        })
      end
    end
  end
end
