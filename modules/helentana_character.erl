-module( helentana_character ).
-author( "GROME <grome@helentana.ru>" ).

-mod_title( "Helentana Character Module" ).
-mod_description( "Модуль для описания персонажа.").
-mod_prio( 100 ).
-mod_depends( [base] ).
-mod_provides( [character] ).

%-export([
%    create/3,
%    login/2, 
%    logoff/1,
%    get/2,
%    get/3,
%    set/3,
%    is_online/1
%]).

-include_lib( "zotonic.hrl" ).
-include( "helentana.hrl" ).

%% Module API

