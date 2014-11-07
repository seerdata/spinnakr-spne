This page will serve as a directoy of specs

* [Event Spec](https://github.com/stormasm/spinnakr-generic-ds/blob/master/doc/eventspec.md)

* [Model Spec](https://github.com/stormasm/spinnakr-generic-ds/blob/master/README.md)

* [Calculation Spec](https://github.com/stormasm/spinnakr-generic-ds/blob/master/doc/calculationspec.md)

* [Object Spec](https://github.com/stormasm/spinnakr-generic-ds/blob/master/doc/storm-objects.md)

####Authentication Tokens

Tokens are Ruby
[SecureRandom uuids]
(http://ruby-doc.org/stdlib-2.1.2/libdoc/securerandom/rdoc/SecureRandom.html#method-c-uuid)

We have all decided that the customer token that serves as our authentication
system will be **project** based.  Meaning that for each **project** inside of a customer
account id we will have a **different** token.

If you need to test our system one can use these access tokens to authenticate
yourself.  Over time these tokens may change, so if for some reason
they don't work, please check back to this page to make sure the token
is still valid.

* [Access Tokens](https://github.com/spinnakr/Spn.ee/blob/master/doc/genevent/access_tokens.md)
