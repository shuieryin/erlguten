all: compile

clean:
	@./rebar3 clean

nuke: clean
	@rm -rf deps

check: compile
	@rm -rf ebin && mkdir ebin && ./rebar3 eunit skip_deps=true

dependencies:
	@./rebar3 get-deps

compile: dependencies
	@./rebar3 compile

include install.mk
