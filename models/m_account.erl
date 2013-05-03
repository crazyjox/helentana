
-module( m_account ).
-author( "GROME" ).

-behaviour( gen_model ).

%% interface functions
-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

-include_lib( "zotonic.hrl" ).

m_find_value( email, #m{value=undefined}, Context ) ->
	helentana_account:get( email, Context );

m_find_value( name, #m{value=undefined}, Context ) ->
	helentana_account:get( name, Context );

m_find_value( is_online, #m{value=undefined}, Context ) ->
	helentana_account:is_online( Context ).


%% @doc Transform a m_config value to a list, used for template loops
%% @spec m_to_list(Source, Context) -> List
m_to_list(_, _Context) ->
    [].

%% @doc Transform a model value so that it can be formatted or piped through filters
%% @spec m_value(Source, Context) -> term()
m_value(#m{value=undefined}, _Context) ->
    undefined.
