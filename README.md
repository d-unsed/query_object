# QueryObject


A simple :green_heart: super-lightweight :green_heart: implementation of Query Objects for ActiveRecord.
Query objects allow you to extract complex ActiveRecord queries out of your models. Each object can represent one or more business rules.

You can get the general idea at this great article: [7 Patterns to Refactor Fat ActiveRecord Models](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/)

But... the key differences and benefits of current implementation are:
 - No need to delegate relation's methods to Query object (see `find_each` method in the article);
 - You are able to combine your queries all the ways you want (see "Usage" section below)

## Installation

Add this line to your application's Gemfile:

    gem 'query_object'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install query_object

## Usage

### Simple query

Let's start with an example from the article.

You should get all accounts with abandoned trials. This kind of query looks like

```ruby
# abandoned_trial_query.rb
class AbandonedTrialQuery < QueryObject
  def initialize
    super do
      Account.
        where(plan: nil).
        where(invites_count: 0)
    end
  end
end
```

Then you can get its `ActiveRecord::Relation` by calling `QueryObject#relation`

```ruby
AbandonedTrialQuery.new.relation.find_each do |account|
  account.send_offer_for_support
end
```

Yeah, pretty staightforward. This one can be done as an ordinary model scope. So why Query objects?..

### Complex queries

Now imagine you are asked to implement one more business rule. It says that the application
should send email notifications to:
 - all active users registered via Twitter
 - who has abandoned trial account (already implemented)
 - and whose credit card is acceptable by your merchant.

So you decide to create the rules (queries) for users and credit cards.

```ruby
# active_twitter_users_query.rb
class ActiveTwitterUsersQuery < QueryObject
  def initialize
    super do
      User.
        # chaining some User's scopes
        with_many_friends.
        with_more_than_100_messages.
        with_smartphone.
        with_any_other_conditions.
        # etc....
        where(banned: false).
        where.not(twitter_id: nil)
    end
  end
end
```

```ruby
# acceptable_credit_cards_query.rb
class AcceptableCreditCardsQuery
  def initialize
    super do
      CreditCard.
        mastercard_and_visa.
        exclude_expired.
        exclude_bad_banks.
        emitted_in('USA').
        where.not(cvv2: nil)
    end
  end
end
```

And the only thing left is to merge all the queries above and tell ActiveRecord
how to join your models in a proper way.

```ruby
# twitter_users_to_charge_query.rb
class TwitterUsersToChargeQuery < QueryObject
  def initialize
    super do
      ActiveTwitterUsersQuery.new.
        merge_with(AbandonedTrialQuery.new).
        merge_with(AcceptableCreditCardsQuery.new).
        relation.
        joins(accounts: :credit_card)
    end
  end
end
```

Send notifications

```ruby
TwitterUsersToChargeQuery.new.relation.find_each do |user|
  user.send_credit_card_charge_notification
end
```

### Unlimited merge!

And finally your task is to create the following:

First 10 users of the list below

- all active users registered via Twitter (already implemented)
- who has abandoned trial account (already implemented)
- and whose credit card is acceptable by your merchant (already implemented)
- and who likes "Columbo" TV film series

should be gifted a free subscription.

No problem. First create a new rule for Columbo's likes.

```ruby
# users_who_like_columbo_query.rb
class UsersWhoLikeColumboQuery < QueryObject
  def initialize
    super do
      User.
        joins(:likes).
        where(likes: { tv_film: 'Columbo' })
    end
  end
end
```

And compose it with the existing `TwitterUsersToChargeQuery`

```ruby
# twitter_users_to_gift_query.rb
class TwiterUsersToGiftQuery < QueryObject
  def initialize
    super do
      TwitterUsersToChargeQuery.new.
        merge_with(UsersWhoLikeColumboQuery.new).
        relation.
        limit(10)
    end
  end
end
```

### Enjoy!


## Contributing

1. Fork it ( https://github.com/d-unseductable/query_object/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Your contributions are welcome! :heart:
