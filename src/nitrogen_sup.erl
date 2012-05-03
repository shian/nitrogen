%% -*- mode: nitrogen -*-
-module(nitrogen_sup).
-behaviour(supervisor).
-export([
    start_link/0,
    init/1
]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    %% Start the Process Registry...
    application:start(nprocreg),

    %% Start Mochiweb...
    application:load(mochiweb),
    {ok, BindAddress} = application:get_env(nitrogen, bind_address),
    {ok, Port} = application:get_env(nitrogen, port),
    {ok, ServerName} = application:get_env(nitrogen, server_name),

    io:format("Starting Mochiweb Server (~s) on ~s:~p", [ServerName, BindAddress, Port]),

    % Start Mochiweb...
    Options = [
        {name, ServerName},
        {ip, BindAddress}, 
        {port, Port},
        {loop, fun nitrogen_mochiweb:loop/1}
    ],
    mochiweb_http:start(Options),

    {ok, { {one_for_one, 5, 10}, []} }.

