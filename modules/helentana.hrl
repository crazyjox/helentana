
-record( event, {
    type=undefined,
    name=undefined,
    params=[]
}).

-record( character, {
    id=0,
    name="",
    state=0
}).

-record( account, {
	id=0,
	email="",
	name="GROME",
	session_pid=undefined,
	password="",
	state=offline,
	character_id=undefined
}).


