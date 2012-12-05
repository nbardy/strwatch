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

Create the bindings in the controller actions and attached to a stream
```ruby
# app/controllers/event_controller.rb
...

def show
  event_binding = bind_one :event do
    Event.find(params[:id])
  end

  # Renders 'views/event' with event_binding
  render_stream "events/show", event_binding
end

def index
  events_binding = bind_one :events, Event do
    Event.all
  end

  # Renders 'views/events' with events_binding
  render_stream "events/index", events_binding
end
...
```
Add the bindings in the views

```erb
# app/views/events/show.html.erb
<% live_stream(:event) do |event| %>
    <div id="event">
        <h1><%= event.name %></h1>
        ID:<%= event.id %>
    </div>
<% end %>


# app/views/events/index.html.erb
<% live_stream(:events) do |events| %>
    <table id="event">
    <% events.each do |event| %>
        <tr>
        <%= event.name %></h1>
        ID:<%= event.id %>
    <% end %>
    </table>
<% end %>

```

## Desgin Decisions

This gem's design/syntax is very much a work in progress and I welcome any and all ideas/changes the

Goals to keep in mind are:
1. Simplicity.
2. Data-binding.  Not data streaming.
3. MVC-orientated. 

######Notes on ActiveRecord Dependencies
I've built it with activerecord dependency because it was made to take use of Rails 4 Streaming and because of the rails dependenancy the ActiveRecord Dependency is there. A big factor in the tight integration with AR is the ability to data-bind using AR callbacks to eliminate the need to frequently check for updates.

I find it much nicer to be listening for changes as opposed to frequently checking for them.

## Needs
  - Tests
  - Better way to bind multiple thing(bind_many)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
