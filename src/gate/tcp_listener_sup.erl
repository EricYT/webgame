%% The contents of this file are subject to the Mozilla Public License
%% Version 1.1 (the "License"); you may not use this file except in
%% compliance with the License. You may obtain a copy of the License
%% at http://www.mozilla.org/MPL/
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and
%% limitations under the License.
%%
%% The Original Code is RabbitMQ.
%%
%% The Initial Developer of the Original Code is GoPivotal, Inc.
%% Copyright (c) 2007-2014 GoPivotal, Inc.  All rights reserved.
%%

-module(tcp_listener_sup).

-behaviour(supervisor).

-export([start_link/5]).

-export([init/1]).

%%----------------------------------------------------------------------------

%%----------------------------------------------------------------------------
start_link(Port, OnStartup, OnShutdown, AcceptCallback, AcceptorCount) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, {Port, OnStartup, OnShutdown, AcceptCallback, AcceptorCount}).

init({Port, OnStartup, OnShutdown, AcceptCallback, ConcurrentAcceptorCount}) ->
    %% This is gross. The tcp_listener needs to know about the
    %% tcp_acceptor_sup, and the only way I can think of accomplishing
    %% that without jumping through hoops is to register the
    %% tcp_acceptor_sup.
%%     Name = tcp_util:tcp_name(tcp_acceptor_sup, IPAddress, Port),
    {ok, {{one_for_all, 10, 10},
          [{tcp_acceptor_sup, {tcp_acceptor_sup, start_link,
                               [AcceptCallback]},
            transient, infinity, supervisor, [tcp_acceptor_sup]},
           {tcp_listener, {tcp_listener, start_link,
                           [Port, ConcurrentAcceptorCount, OnStartup, OnShutdown]},
            transient, 16#ffffffff, worker, [tcp_listener]}]}}.