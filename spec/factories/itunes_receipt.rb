FactoryGirl.define do

  factory :parsed_itunes_receipt, class: Venice::Receipt do
    # {
    #   bundle_id: "com.foo.bar",
    #   application_version: "2",
    #   original_application_version: "1",
    #   original_purchase_date: "Wed, 04 Jun 2014 23:20:47 GMT" ,
    #   expires_at: "Wed, 04 Jun 2014 23:20:47 GMT",
    #   receipt_type: "Production",
    #   adam_id: 7654321,
    #   download_id: 1234567,
    #   requested_at: "Wed, 04 Jun 2014 23:20:47 GMT",
    #   in_app: [
    #     {
    #       quantity: 1,
    #       product_id: "com.foo.product1",
    #       transaction_id: "1000000070107111",
    #       purchase_date: nil,
    #       original_transaction_id: "1000000061051111",
    #       original_purchase_date: nil,
    #       app_item_id: nil,
    #       version_external_identifier: nil,
    #       expires_at: "Thu, 01 Jan 1970 00:00:02 GMT",
    #       cancellation_at: nil
    #     }
    #   ],
    #   latest_receipt: nil
    # }.with_indifferent_access

    {
      "status"=>0,
      "environment"=>"Production",
      "receipt"=>{"receipt_type"=>"Production",
        "adam_id"=>664753504,
        "bundle_id"=>"com.teamtreehouse.Treehouse",
        "application_version"=>"1926",
        "download_id"=>34008348457320,
        "request_date"=>"2014-06-04 23:20:47 Etc/GMT",
        "request_date_ms"=>"1401924047883",
        "request_date_pst"=>"2014-06-04 16:20:47 America/Los_Angeles",
        "original_purchase_date"=>"2014-05-17 02:09:45 Etc/GMT",
        "original_purchase_date_ms"=>"1400292585000",
        "original_purchase_date_pst"=>"2014-05-16 19:09:45 America/Los_Angeles",
        "original_application_version"=>"1910",
        "in_app"=>[{"quantity"=>"1",
          "product_id"=>"com.teamtreehouse.iap.basic.1month",
          "transaction_id"=>"140000091867509",
          "original_transaction_id"=>"140000091867509",
          "purchase_date"=>"2014-05-28 14:47:53 Etc/GMT",
          "purchase_date_ms"=>"1401288473000",
          "purchase_date_pst"=>"2014-05-28 07:47:53 America/Los_Angeles",
          "original_purchase_date"=>"2014-05-28 14:47:53 Etc/GMT",
          "original_purchase_date_ms"=>"1401288473000",
          "original_purchase_date_pst"=>"2014-05-28 07:47:53 America/Los_Angeles",
          "is_trial_period"=>"false"
        }]
      }
    }

  end

end
