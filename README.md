# Strwatch

A rails gem for databing active-record models and querries to views.

## Installation

Add this line to your application's Gemfile:

    gem 'strwatch'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strwatch

## Usage

### This gem is currently still a work in progress
Currently the only bindings working are dirty_binding which check for new data at a given interval.(Oh how dirty)

### Instructions

Create the bindings in the controller actions and attached to a stream
```ruby
# app/controllers/event_controller.rb
...

include Strwatch::Controller

def show
  dirty_binding :event do
    Event.first
  end
end

def index
  dirty_binding :events do
    Event.all
  end
end

...
```
Add the bindings in the views
Currently supports [ Mustache.js ]( https://mustache.github.com ) templates

Note: erb cannot be used inside the streaming portion because that portion of the view is being rendered client side on each update.  Only the json data is streamed to the client not the html view.


```erb
# app/views/events/show.html.erb
<% stream(:event) do %>
    <div id="event">
        <h1>{{name}}</h1>
        ID: {{id}}
    </div>
<% end %>


# app/views/events/index.html.erb
<% stream(:events) do %>
    <table id="events">
    {{#events}} 
        <tr>name: {{name}}, ID:{{id}}</tr>
    {{/events}}
    </table>
<% end %>

```

## Design Decisions

This gem's design/syntax is very much a work in progress and I welcome any and all ideas/changes.

Goals to keep in mind are:
1. Simplicity.
2. Data-binding.  Not data streaming.
3. MVC-orientated. 

## Needs
  - Tests

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
