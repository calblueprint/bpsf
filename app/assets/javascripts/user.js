var customer;
$(document).ready(function() {
       Stripe.setPublishableKey($("meta[name='stripe-key']").attr('content'));
       customer.setupForm();
});

customer = {
       setupForm: function() {
                         $('#edit_user').submit(function() {
                                $("input[type=submit]").attr("disabled", true);
                                if ($("#card_number").length && $("#card_number").val().length > 0) {
                                customer.processCustomer();
                         return false;
                                } else {
                                $("input[type=submit]").attr("disabled", false);
                                       return false;
                                }
                         });
                  },
       processCustomer: function() {
                               var card;
                               card = {
                                      name: $("#card_name").val(),
                                      number: $("#card_number").val(),
                                      cvc: $("#card_code").val(),
                                      expMonth: $("#card_month").val(),
                                      expYear: $("#card_year").val(),
                                      address_line1: $("#address_line1").val(),
                                      address_line2: $("#address_line2").val(),
                                      address_city: $("#address_city").val(),
                                      address_zip: $("#address_zip").val(),
                                      address_state: $("#address_state").val(),
                                      address_country: $("#address_country").val()
                               };
                               Stripe.createToken(card, customer.stripeResponseHandler);
                        },
       stripeResponseHandler: function(status, response) {
                                     if (status == 200) {
                                            $("#stripe_token").val(response.id);
                                            $("input[type=submit]").attr("disabled", false);
                                            return $("#edit_user")[0].submit();
                                     } else {
                                            $("#stripe-error").text(response.error.message);
                                            return $("input[type=submit]").attr("disabled", false);
                                     }
                              }
};

