%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2014-4-14
%%% -------------------------------------------------------------------
-module(client_test).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {socket}).

%% ====================================================================
%% External functions
%% ====================================================================
start_link([]) ->
    gen_server:start({local, ?MODULE}, ?MODULE, [], []).


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
    {ok, Socket} = gen_tcp:connect("127.0.0.1", 8089, [{packet, 2}, binary]),
    io:format(">>>>>>>>>>>> ~p~n", [{?MODULE, ?LINE, Socket}]),
    {ok, #state{socket = Socket}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call(Request, From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Msg, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info({tcp, Port, BinData}, State) ->
	io:format("<<<<<<<<<<<<< handle data from server:~p~n", [{?MODULE, ?LINE, binary_to_term(BinData)}]),
    {noreply, State};

handle_info({send_data, Data}, #state{socket = Socket}=State) ->
    io:format(">>>>>>>>>>>>>>>> send data to server:~p~n", [{?MODULE, ?LINE, Data}]),
    BinData = erlang:term_to_binary(Data),
	erlang:port_command(Socket, BinData, [force]),
%%     gen_tcp:send(Socket, BinData),
    {noreply, State};

handle_info(Info, State) ->
	io:format(">>>>>>>>>>>>>> handle data from server:~p~n", [{?MODULE, ?LINE, Info}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(OldVsn, State, Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

