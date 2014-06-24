module Support
  module ItunesReceipts

    def self.receipt
      Venice::Receipt.new raw
    end

    def self.parsed
      receipt.to_hash.with_indifferent_access
    end

    def self.response transaction_id=nil
      transaction_id ||= default_transaction_id
      {
        "status"=>0,
        "environment"=>"Production",
        "receipt" => {
          "receipt_type"=>"Production",
          "adam_id"=>123,
          "bundle_id"=>"com.foo.bar",
          "application_version"=>"1",
          "download_id"=>1,
          "request_date"=>"2014-06-04 23:20:47 Etc/GMT",
          "request_date_ms"=>"1401924047883",
          "request_date_pst"=>"2014-06-04 16:20:47 America/Los_Angeles",
          "original_purchase_date"=>"2014-05-17 02:09:45 Etc/GMT",
          "original_purchase_date_ms"=>"1400292585000",
          "original_purchase_date_pst"=>"2014-05-16 19:09:45 America/Los_Angeles",
          "original_application_version"=>"1",
          "in_app"=>[{
            "quantity"=>"1",
            "product_id"=>"com.foo.product",
            "transaction_id"=>transaction_id,
            "original_transaction_id"=>"4444",
            "purchase_date"=>"2014-05-28 14:47:53 Etc/GMT",
            "purchase_date_ms"=>"1401288473000",
            "purchase_date_pst"=>"2014-05-28 07:47:53 America/Los_Angeles",
            "original_purchase_date"=>"2014-05-28 14:47:53 Etc/GMT",
            "original_purchase_date_ms"=>"1401288473000",
            "original_purchase_date_pst"=>"2014-05-28 07:47:53 America/Los_Angeles",
            "is_trial_period"=>"false"
          }]
        }
      }.with_indifferent_access
    end

    def self.raw
      response[:receipt]
    end

    def self.default_transaction_id
      @default_transaction_id || 555
    end

    def self.default_transaction_id=(val)
      @default_transaction_id = val
    end

    module VerificationMock
      def stub_successful_itunes_receipt_verification
        allow_any_instance_of(Venice::Client).to receive(:verify!).and_return Support::ItunesReceipts.receipt
      end

      def stub_unsuccessful_itunes_receipt_verification
        error = Venice::Receipt::VerificationError.new(555555, nil)
        allow_any_instance_of(Venice::Client).to receive(:verify!).and_raise error
      end

      def itunes_transaction_id
        Support::ItunesReceipts.default_transaction_id
      end
    end

  end
end
