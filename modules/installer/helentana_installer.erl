%% @author GROME <grome@helentana.ru>
%% @copyright 2013 Marunin Alexey
%% Date: 2013-04-21
%%
%% @doc This server will install the database when started. It will always return ignore to the supervisor.
%% This server should be started after the database pool but before any database queries will be done.

-module( helentana_installer ).
-author( "GROME <grome@helentana.ru" ).

%% gen_server exports
-export( [start_link/1] ).

-include_lib( "zotonic.hrl" ).


%%====================================================================
%% API
%%====================================================================
%% @spec start_link(SiteProps) -> {ok,Pid} | ignore | {error,Error}
%% @doc Install zotonic on the databases in the PoolOpts, skips when already installed.
start_link( SiteProps ) when is_list( SiteProps ) ->
%    install_check( SiteProps ),
    ?DEBUG( SiteProps ),
    ignore.
