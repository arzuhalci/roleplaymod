#include <a_samp>
#include <streamer>
#include <zcmd>
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_timers>
#include <a_mysql>
#include <easyDialog>
#include <formatex>

//Kendi includelerim
#include <chat>
#include <player>
#include <fly>
#include <house>


#define MYSQL_HOST "localhost"
#define MYSQL_USER "root"
#define MYSQL_PASSWORD ""
#define MYSQL_DATABASE "youtube"


new MySQL: sqldb;


main() {
}

public OnGameModeInit()
{
    DisableInteriorEnterExits();
    sqldb = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);
    if(mysql_errno(sqldb) != 0)
    {
        print("MySQL connection failed.");
        return 1;
    }
    print("MySQL connection succesful.");

    mysql_tquery(sqldb, "SELECT * FROM evler", "OnEvDBLoaded");
    return 1;
}


public OnPlayerConnect(playerid){

    //test ve geli�tirme ama�l�, sonradan sil
    SetPlayerHealth(playerid, 99999999.0);
    InitFly(playerid);
    //test ve geli�tirme ama�l�, sonradan sil^^

    //Karakter orm mysql
    static const empty_player[E_Players];
    Player[playerid] = empty_player;


    GetPlayerName(playerid, Player[playerid][Name], MAX_PLAYER_NAME);

    new ORM: ormid = Player[playerid][ORM_ID] = orm_create("players", sqldb);

    orm_addvar_int(ormid, Player[playerid][ID], "id");
    orm_addvar_string(ormid, Player[playerid][Name], MAX_PLAYER_NAME, "player_name");
    orm_addvar_string(ormid, Player[playerid][pswd], 128, "password");
    orm_addvar_int(ormid, Player[playerid][cash], "cash");
    orm_setkey(ormid, "player_name");

    orm_load(ormid, "OnPlayerDataLoaded", "d", playerid);


    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    UpdatePlayerData(playerid);
}
public OnPlayerText(playerid, text[])
{
    localChat(playerid, 30, text);
    return 0;
}



forward OnPlayerDataLoaded(playerid);
public OnPlayerDataLoaded(playerid)
{
    new string[128];

    switch(orm_errno(Player[playerid][ORM_ID]))
    {
    case ERROR_OK:
        {
            format(string, 24, "Ho�geldin %p, sunucuda kay�tl�s�n. Devam etmek l�tfen �ifreni gir.", playerid);
            Dialog_Show(playerid, GirisEkrani, DIALOG_STYLE_PASSWORD, "Giri� Ekran�", string, "Giri� Yap", "��k��");
        }
    case ERROR_NO_DATA:
        {
            Dialog_Show(playerid, KayitEkrani, DIALOG_STYLE_PASSWORD, "Kay�t Ekran�", "Ho�geldin! G�r�n��e g�re sunucuda kay�tl� de�ilsin. �ifre girerek hesap olu�tur", "Kay�t Ol", "��k��");
        }
    }
    return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
    SetSpawnInfo(playerid, 0, 0, 1520, -1650, 15.36, 269.15, 26, 36, 28, 150, 0, 0 );
    SpawnPlayer(playerid);
}

forward OnPlayerLogIn(playerid);
public OnPlayerLogIn(playerid){
    SetSpawnInfo( playerid, 0, 0, 1520, -1650, 15.36, 269.15, 26, 36, 28, 150, 0, 0 );
    SpawnPlayer(playerid);
}

Dialog:GirisEkrani(playerid, response, listitem, inputtext[])
{
    new string[24];
    format(string, 24, "%s", Player[playerid][pswd]);
    if(strcmp(string, inputtext) == 0)
    {
        OnPlayerLogIn(playerid);
        SendClientMessage(playerid, 0xFFFFFF, "sunucuya giris basarili");
    }
    else{
        Kick(playerid);
    }
    return 1;
}

Dialog:KayitEkrani(playerid, response, listitem, inputtext[])
{
    new string[24];
    format(string, 24, inputtext);
    if(response == 1){
    Player[playerid][pswd] = string;

    orm_setkey(Player[playerid][ORM_ID], "id");

    orm_save(Player[playerid][ORM_ID], "OnPlayerRegister", "d", playerid);
    }
    else{
        orm_destroy(Player[playerid][ORM_ID]);
        Kick(playerid);
    }
}

forward UpdatePlayerData(playerid);
public UpdatePlayerData(playerid)
{
    orm_save(Player[playerid][ORM_ID]);
    orm_destroy(Player[playerid][ORM_ID]);

    
}

forward OnEvDataLoaded(i);
public OnEvDataLoaded(i){
    switch(orm_errno(Ev[i][ORM_EV_ID]))
    {
        case ERROR_OK:
        {
            print("Ev data'ları başarıyla yüklenmiştir.");
        }
        case ERROR_NO_DATA:
        {
            print("Ev data'ları yüklenirken bir hata oluştu, işlem başarısız.");
        }
    }
    return 1;
}

forward OnEvDBLoaded();
public OnEvDBLoaded(){
    cache_get_row_count(ev_count);
    for(new i = 1; i <= ev_count; i++)
    {
        Ev[i][ID] = i;
        new ORM: ev_ormid = Ev[i][ORM_EV_ID] = orm_create("evler",sqldb);
        orm_addvar_int(ev_ormid, Ev[i][ID], "id");
        orm_addvar_int(ev_ormid, Ev[i][OwnerDBID], "owner_db_id");
        orm_addvar_int(ev_ormid, Ev[i][forSale], "for_sale");
        orm_addvar_int(ev_ormid, Ev[i][salePrice], "sale_price");
        orm_addvar_string(ev_ormid, Ev[i][address], 128, "address");
        orm_setkey(ev_ormid, "id");
        orm_load(ev_ormid);
    }
    return 1;
}

