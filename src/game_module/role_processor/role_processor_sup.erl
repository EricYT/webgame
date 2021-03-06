%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2013-10-7
%%% -------------------------------------------------------------------
-module(role_processor_sup).

-behaviour(supervisor).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([start_link/1]).

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
start_link(Args) ->
	io:format("-----1223333321:~p~n", [Args]),
	RoleProcessor = role_util:make_role_processor_sup_name(Args),
	supervisor:start_link({local, RoleProcessor}, ?MODULE, [Args]).


%% ====================================================================
%% Server functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {error, Reason}
%% --------------------------------------------------------------------
init([RoleId]) ->
	io:format("role_processor_sup:~p~n", [RoleId]),
    AChild = {'role_processor',{'role_processor',start_link,[RoleId]},
	      permanent,2000,worker,['role_processor']},
    {ok,{{one_for_all,0,1}, [AChild]}}.

%% ====================================================================
%% Internal functions
%% ====================================================================

