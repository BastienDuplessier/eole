# EoleProject

Simple JSON API which can register debit on accounts referenced by an IBAN. When an account have more than 10k€ of debit in less than 20 minutes, it will log a warning about this account.

## Usage
First, make sure you have Elixir (>= 1.5.2) installed.
Then clone this repository, and then you can run the project using `mix run --no-halt`

You'll be able to run some queries against the local API.
```bash
curl --request POST \
  --url http://localhost:5000/debit \
  --header 'content-type: application/json' \
  --data '{"iban": "AZERTTYUIP","amount": 1000}'
```

NOTE : No check is done on the IBAN. It can be any string.


## Design of the application.
For this, I used an umbrella project, which allowed me to split my application in two parts : "Business" and "API".
First one get all the logic about Accounts and Debits. Second one is just the JSON interface which use the business side.

References :
https://elixirschool.com/en/lessons/advanced/umbrella-projects/

https://www.youtube.com/watch?v=grcplpIL60I
https://github.com/tgautier/odot/
