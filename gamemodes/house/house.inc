#include <a_samp>
#include <a_mysql>

enum hInfo
{
    ORM: ORM_EV_ID,
    ID,
    OwnerDBID,
    OwnerName,
    bool:forSale,
    salePrice,
    address,
}

#define MAX_EV (1000)

new ev_count;

new Ev[MAX_EV][hInfo];

CMD:evtest(playerid, params[]){
    new string[128];
    format(string, 128, "owner db id %d", Ev[params[1]][OwnerDBID]);
    SendClientMessage(playerid, 0xFFFFFFFF, string);
}

