This page will serve as a directoy of specs for the new **generic** Spn.ee system.

For now I will outline key concepts of recent that we have discussed.

These concepts will eventually get merged into one of the other already
written specs.

####Authentication Tokens

Tokens are Ruby
[SecureRandom uuids]
(http://ruby-doc.org/stdlib-2.1.2/libdoc/securerandom/rdoc/SecureRandom.html#method-c-uuid)

We have all decided that the customer token that serves as our authentication
system will be **project** based.  Meaning that for each **project** inside of a customer
account id we will have a **different** token.

Account 1, Project 1, Token X11
Account 1, Project 2, Token X12

Account 2, Project 1, Token X21
Account 2, Project 2, Token X22
