%%% -------------------------------------------------------------------
%%% Author  : Eric.yu
%%% Description :
%%%
%%% Created : 2013-10-7
%%% -------------------------------------------------------------------
-module(role_processor_app_sup).

-behaviour(supervisor).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([start_link/1, start_child/1]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([
	 init/1
        ]).

%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------
-define(SERVER, ?MODULE).

%% --------------------------------------------------------------------
%% Records
%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================
start_link(_StartArgs) ->
	io:format("-----111:~p~n", [_StartArgs]),
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).


start_child(RoleInfo) ->
	io:format("-----12221:~p~n", [RoleInfo]),
	supervisor:start_child(?SERVER, RoleInfo).


%% ====================================================================
%% Server functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {error, Reason}
%% --------------------------------------------------------------------
init([]) ->
    AChild = {'role_processor_sup',{'role_processor_sup',start_link,[]},
	      permanent,2000,supervisor,['role_processor_sup']},
    {ok,{{simple_one_for_one,0,1}, [AChild]}}.

%% ====================================================================
%% Internal functions
%% ====================================================================

