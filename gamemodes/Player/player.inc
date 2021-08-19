#include <a_samp>
#include <streamer>
#include <zcmd>
#include <YSI_Data\y_iterate>
#include <a_mysql>
#include <easyDialog>
#include <formatex>

enum E_Players
{
    ORM: ORM_ID,
    ID,
    Name[MAX_PLAYER_NAME],
    pswd[24],
    cash,

    bool:IsLoggedIn,

}

new Player[MAX_PLAYERS][E_Players];

