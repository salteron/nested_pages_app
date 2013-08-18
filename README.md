Install & Run (ruby 1.9.2, Rails 3.1)
-------------------

    $ bundle install
    $ rake db:migrate
    $ rails server

Populate with sample data
-------------------

    $ rake db:populate

Tests
-------------------
    
    $ rspec spec/

Comments (russian)
-------------------

Для организации страниц в виде дерева используется гем 'ancestry'
(https://github.com/stefankroes/ancestry).