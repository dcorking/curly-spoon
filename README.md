## Set up development environment

Prerequisites:
- nix
- direnv

nix installs postgres and .envrc (direnv) makes a project local
datastore for it

create the database with
```
rails db:setup
```

## Start development server

start the database with
```
pg_ctl -D ./postgres -l ./postgres/logfile start
```
