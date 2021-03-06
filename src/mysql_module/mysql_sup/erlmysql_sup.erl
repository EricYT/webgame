%%% -------------------------------------------------------------------
%%% Author  : Eric.yutao
%%% Description :
%%%
%%% Created : 2013-12-31
%%% -------------------------------------------------------------------
-module(erlmysql_sup).

-behaviour(supervisor).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(SERVER_NAME, 'mysql_name_server').

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([
		 start_link/0,
		 start_mysql/1,
         log/4
		]).

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
-spec start_link() -> ignore.
start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).


-spec start_mysql(ServerName) -> {ok, Pid} when
											 ServerName :: atom(),
											 Pid :: pid().
start_mysql(ServerName) ->
	[PoolId, WHost, WProt, WUser, WPwd, WDB, WEncoding, _WRunNode] = mysql_util:get_w_conf(),
	WriteArgs = [ServerName, PoolId, WHost, WProt, WUser, WPwd, WDB, fun log/4, WEncoding],
	Spec = {ServerName, {mysql, start_link, WriteArgs},
			transient, 2000, worker, [ServerName]},
	{ok, Pid} = supervisor:start_child(?MODULE, Spec),
	debug:info("Start mysql(master) ~p~n", [Pid]),
	{ok, Pid}.

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
    NameChild = {'mysql_name_server',{'mysql_name_server',start_link,[]},
	      permanent,2000,worker,['mysql_name_server']},
    {ok,{{one_for_one,10,100}, [NameChild]}}.

%% ====================================================================
%% Internal functions
%% ====================================================================

log(_, _, _, _) ->
    %%TODO:
    todo.

