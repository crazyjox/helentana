-module( helentana_account_manager ).
-author( "GROME <grome@helentana.ru>" ).

-mod_title( "Менеджер аккаунтов" ).
-mod_description( "Модуль, управляющий аккаунтами пользователей." ).
-mod_prio( 100 ).
-mod_depends( [base] ).
-mod_provides( [account_manager] ).

-export([
    create/2,
    login/3, 
    logoff/1,
    find/2,
    load/2,
    save/2,
    is_exists/2,
    count/1, count/2,
    foreach/2, foreach/3, foreach/4,
    get_session_account/1,
    set_session_account/2
]).

-include_lib( "zotonic.hrl" ).
-include( "helentana.hrl" ).

%% Создание нового аккаунта (регистрация)
create( Account, Context ) ->
    case is_exists( Account#account.email, Context ) of
        true -> { error, already_exist };
        false -> 
            % TODO: добавить запись в БД
            %Account = create_debug( Email, Password ),
            % Рассылаем уведомление о создании нового аккаунта
            z_notifier:foldl( notify_account_created, Account, Context ),
            { ok, Account }
    end.            

%% Вход аккаунта в текущей сессии
login( AccountId, Password, Context ) ->
    case z_session_manager:ensure_session( Context ) of
        { ok, Context1 } ->
            % Проверяем, залогинились ли в текущей сессии?
            case get_session_account( AccountId, Context1 ) of
                undefined ->
                    % Загружаем данные и сравниваем пароли
                    case load( AccountId, Context1 ) of
                        { error, Error } -> { error, Error };
                        Account ->
                            % Проверяем правильность ввода пароля
                            case Account#account.password of
                                P when P =:= Password ->
                                    Account1 = Account#account{ state=online, session_pid=Context1#context.session_pid },
                                    z_session:set( account, Account1, Context1 ),
                                    % Рассылаем уведомление о входе аккаунта
                                    z_notifier:foldl( notify_account_login, Account1, Context1 ),
                                    { ok, Context1 };
                                _ ->
                                    { error, invalid_password }
                            end
                    end;
                % В текущей сессии мы уже залогинились
                Account ->
                    Account1 = Account#account{ state=online, session_pid=Context1#context.session_pid },
                    z_session:set( account, Account1, Context1 ),
                    { ok, Context1 }
            end;
        Error -> Error
    end.
    
%% Отлкючение текущего аккаунта
logoff( Context ) ->
    Account = get_session_account( Context ),
    logoff( Account#account.id, Context ).
    
%% 
logoff( AccountId, Context ) ->
    Account = foreach( AccountId, 
        fun( Account, SessionPid ) ->
            ?DEBUG( Account ),
            Account1 = Account#account{ state=offline },
            z_session:set( account, undefined, SessionPid ),
            Account1
        end,
        Context
    ),
    case Account of
        undefined ->
            Context;
        _ ->
            % Рассылаем уведомление об отключении аккаунта
            % Пока нет упоминания о том, какой аккаунт отключается
            z_notifier:notify( notify_account_logoff, Context ),
            Context
    end.
    
%% @spec find( AccountId, Context ) -> Account#account | undefined
%% @doc  Поиск аккаунта среди активных сессий
find( AccountId, Context ) ->
    fold_sessions( 
        fun( SessionPid, Acc ) ->
            case Acc of
                undefined ->
                    get_session_account( AccountId, SessionPid );
                A -> A
            end
        end,
        Context
    ).

%% @spec load( AccountId, Context ) -> Account#account | undefined
%% @doc  Загрузка данных аккаунта из БД
load( AccountId, _Context ) ->
    if 
    AccountId =:= "1" orelse AccountId =:= "GROME@helentana.ru" ->
        #account{
            id=1, 
            email="GROME@helentana.ru", 
            name="GROME", 
            password="1234"
        };
    AccountId =:= "2" orelse AccountId =:= "SGA@helentana.ru" ->
            #account{
                id=2, 
                email="SGA@helentana.ru", 
                name="S.G.A.", 
                password="1234"
            };
    AccountId =:= "3" orelse AccountId =:= "crazyjox@helentana.ru" ->
            #account{
                id=3, 
                email="crazyjox@helentana.ru", 
                name="crazyjox", 
                password="1234"
            };
     true ->
            { error, account_not_found }
    end.

%% @spec save( Account, Context ) -> Account#account | undefined
%% @doc  Сохраняет данные аккаунта в БД
save( _Account, Context ) ->
    % TODO: Реализовать запись в БД
    Context.    
    

%% @spec is_exists( AccountId, Context ) -> bool
%% @doc  Проверяет, существует ли указанный аккаунт
is_exists( undefined, _Context ) ->
    false;
    
is_exists( AccountId, Context ) ->
    case find( AccountId, Context ) of 
        undefined -> 
            % среди активных не обнаружили - ищем в БД
            % TODO: реализовать поиск аккаунта в БД
            false;
        _ -> 
            true
    end.


%% @spec count( Context ) -> integer
%% @doc  Возвращает число активных аккаунтов
count( Context ) ->
    foreach( fun( _Account, _SessionPid, Count ) -> Count + 1 end, 0, Context ).

%% @spec count( AccountId, Context ) -> integer
%% @doc  Возвращает количество открытых сессий для указанного аккаунта
count( AccountId, Context ) ->
    foreach( AccountId, fun( _Account, _SessionPid, Count ) -> Count + 1 end, 0, Context ).



%% @spec foreach( Function, Context ) -> term() | undefined
%% @doc  Вызывает функцию для каждого активного аккаунта
foreach( Function, Context ) when is_function( Function ) ->
    foreach( Function, undefined, Context ).

%% @spec foreach( Function, Acc0, Context ) -> term() | Acc0
%% @doc  Вызывает функцию для каждого активного аккаунта
foreach( Function, Acc0, Context ) when is_function( Function ) ->
    fold_sessions( 
        fun( SessionPid, Acc ) ->
            case get_session_account( SessionPid ) of
                undefined ->
                    Acc;
                Account when is_record( Account, account ) -> 
                    if
                    is_function( Function, 2 ) ->
                        Function( Account, SessionPid );
                    is_function( Function, 3 ) ->
                        Function( Account, SessionPid, Acc )
                    end
            end
        end,
        Acc0,
        Context
    );
    
%% @spec foreach( AccountId, Function, Context ) -> term() | undefined
%% @doc  Вызывает функцию для каждой сессии указанного аккаунта
foreach( AccountId, Function, Context ) when is_function( Function ) ->
    foreach( AccountId, Function, undefined, Context ).
    
%% @spec foreach( AccountId, Function, Acc0, Context ) -> term() | Acc0
%% @doc  Вызывает функцию для каждой сессии указанного аккаунта
foreach( AccountId, Function, Acc0, Context ) when is_function( Function ) ->
    fold_sessions( 
        fun( SessionPid, Acc ) ->
            case get_session_account( AccountId, SessionPid ) of
                undefined ->
                    Acc;
                Account when is_record( Account, account ) -> 
                    if
                    is_function( Function, 2 ) ->
                        Function( Account, SessionPid );
                    is_function( Function, 3 ) ->
                        Function( Account, SessionPid, Acc )
                    end
            end
        end,
        Acc0,
        Context
    ).


%% @spec fold_sessions( Function, Context ) -> term() | undefined
%% @doc  Вызывает функцию для всех открытых сессий
fold_sessions( Function, Context ) ->
    fold_sessions( Function, undefined, Context ).
    
%% @spec fold_sessions( Function, Context ) -> term() | Acc0
%% @doc  Вызывает функцию для всех открытых сессий
fold_sessions( Function, Acc0, Context ) ->
    z_session_manager:fold( Function, Acc0, Context ).


%% @spec set_session_account( Context ) -> void()
%% @doc  Сохраняет данные об аккаунте в текущей сессии
set_session_account( Account, #context{session_pid=SessionPid} ) ->
    set_session_account( Account, SessionPid );
    
%% @spec set_session_account( Account, SessionPid ) -> void()
%% @doc  Сохраняет данные об аккаунте в указанной сессии
set_session_account( Account, SessionPid ) when is_pid( SessionPid ) ->
    z_session:set( account, Account, SessionPid ),
    Account.
    

%% @spec get_session_account( Context ) -> Account#account | undefined
%% @doc  Возвращает данные об аккаунте из текущей сессии
get_session_account( #context{session_pid=SessionPid} ) ->
    get_session_account( SessionPid );
    
%% @spec get_session_account( SessionPid ) -> Account#account | undefined
%% @doc  Возвращает данные об аккаунте из указанной сессии
get_session_account( SessionPid ) when is_pid( SessionPid ) ->
    z_session:get( account, SessionPid ).
    
%% @spec get_session_account( AccountId, Context ) -> Account#account | undefined
%% @doc  Возвращает данные об указанном аккаунте из текущей сессии
get_session_account( AccountId, #context{session_pid=SessionPid} ) ->
    get_session_account( AccountId, SessionPid );
    
%% @spec get_session_account( AccountId, SessionPid ) -> Account#account | undefined
%% @doc Возвращает данные об указанном аккаунте из указанной сессии
get_session_account( AccountId, SessionPid ) when is_pid( SessionPid ) ->
    case get_session_account( SessionPid ) of
        undefined -> 
            % в указанной сессии нет информации об аккаунте
            undefined;
        A when A#account.id =:= AccountId orelse A#account.email =:= AccountId ->
            % переданный AccountId может быть как идентификатором, так и адресом почты
            A;
        _ -> undefined
    end.


    
    
