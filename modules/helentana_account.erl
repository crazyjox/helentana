-module( helentana_account ).
-author( "GROME <grome@helentana.ru>" ).

-mod_title( "Helentana Account module" ).
-mod_description( "User account support.").
-mod_prio(100).
-mod_depends( [base, account_manager] ).
-mod_provides( [account] ).

-export([
    create/3,
    login/3, 
    logoff/1,
    me/1,
    get/2,
    get/3,
    set/3,
    is_online/1,
    
    event/2,
    
    observe_notify_account_login/3
]).

-include_lib( "zotonic.hrl" ).
-include( "helentana.hrl" ).

%% Module API

%% Создание нового аккаунта (регистрация)
create( _Email, _Password, _Context ) ->
    %helentana_account_manager:create().
    { error, not_yet_implemented }.
    
    
%% Вход под своим аккаунтом
login( Email, Password, Context ) ->
    helentana_account_manager:login( Email, Password, Context ).


%% Загружает данные об аккаунте
me( Context ) ->
    helentana_account_manager:get_session_account( Context ).
    
%% Возвращает указанный параметр аккаунта
get( Key, Context ) ->
    get( Key, undefined, Context ).
    
%% Возвращает указанный параметр аккаунта.
%% Если не найден, то возвращает значение по умолчанию.
get( Key, DefaultValue, Context ) ->
    Account = me( Context ),
    case Account of
        undefined -> 
            undefined;
        Acc when is_record( Acc, account ) ->
            case Key of
                id -> Acc#account.id;
                name -> Acc#account.name;
                email -> Acc#account.email;
                state -> Acc#account.state;
                character_id -> Acc#account.character_id;
                _ -> DefaultValue
            end;
        _ ->
            undefined
    end.


%% @spec set( Key, Value, Context ) -> #account
%% @doc  Изменяет указанный параметр текущего аккаунта
set( Key, Value, Context ) when is_record( Context, context ) ->
    Account = me( Context ),
    Account1 = set( Key, Value, Account ),
    helentana_account_manager:set_session_account( Account1, Context );
    
%% @spec modify( Account, Key, Value ) -> #account
%% @doc  Изменяет указанный параметр аккаунта
set( Key, Value, Account ) ->
    case Key of
        email ->
            Account#account{email=Value};
        name ->
            Account#account{name=Value};
        state ->
            Account#account{state=Value};
        password ->
            Account#account{password=Value};
        _ -> 
            Account
    end.

logoff( Context ) ->
    helentana_account_manager:logoff( Context ).
    
is_online( Context ) ->
    case get( state, Context ) of
        online -> true;
        _ -> false
    end.
    


event( #submit{ message={login_account, _Args}, form=_Form}, Context ) ->
    Email = z_context:get_q_validated( "email", Context ),
    Password = z_context:get_q_validated( "password", Context ),
    case login( Email, Password, Context ) of
        { ok, Context1 } ->
            AccountId = get( id, Context1 ),
            ?DEBUG( AccountId ),
            Context1;
        Error ->
            ?DEBUG( Error),
            z_render:growl( "Что-то пошло не так", Context )
   end;

event( #postback{ message={logoff_account, _Args}, trigger=_TriggerId, target=_TargetId}, Context ) ->
    logoff( Context ),
    z_render:wire({ redirect, [{dispatch, home}] }, Context ).

observe_notify_account_login( notify_account_login, Account, Context ) ->
    z_render:growl( "Вы успешно вошли! Ваш id=" ++ z_convert:to_list( Account#account.id ), Context ).
    %Context2 = z_render:wire({ redirect, [{dispatch, profile}] }, Context1 ),
    
