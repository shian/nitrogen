all: get-deps compile

compile:
	./rebar compile

get-deps:
	./rebar get-deps

update-deps:
	./rebar get-deps

clean:
	./rebar clean

shell:
	erl -sname nitrogen +K true +A 5 -sync sync_mode nitrogen \
	-pa $(shell pwd)/ebin $(wildcard deps/*/ebin) \
	-eval "application:load(simple_bridge)" \
	-eval "application:start(nitrogen)"
