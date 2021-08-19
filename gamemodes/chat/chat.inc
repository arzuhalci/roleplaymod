#include <a_samp>
#include <zcmd>
#include <YSI_Data\y_iterate>
#include <a_mysql>
#include <easyDialog>
#include <strlib>
#include <YSI_Server\y_colours>


#include <player>

#define     COLOR_PURPLE        0xC2A2DAAA

#define COLOR_FADE1 0xFFFFFFFF
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_WHITE 0xFFFFFFFF


/* ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5)
{
    new Float:pPositionX[3], Float:oPositionX[3];
    GetPlayerPos(playerid, pPositionX[0], pPositionX[1], pPositionX[2]);

    new nameWithoutTire[24];
    new initialMessage[128];
    format(nameWithoutTire, 24, "%s", Player[playerid][Name]);
    strreplace(nameWithoutTire, "_", " ");
    format(initialMessage, 128, "%s: ", nameWithoutTire);
    strcat(initialMessage, string, 128);
    strcopy(string, initialMessage, 128);
    foreach(new i : Player)
    {
        GetPlayerPos(i, oPositionX[0], oPositionX[1], oPositionX[2]);
        if(IsPlayerInRangeOfPoint(i, radi / 16, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col1, string); }
        else if(IsPlayerInRangeOfPoint(i, radi / 8, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col2, string); }
        else if(IsPlayerInRangeOfPoint(i, radi / 4, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col3, string); }
        else if(IsPlayerInRangeOfPoint(i, radi / 2, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col4, string); }
        else if(IsPlayerInRangeOfPoint(i, radi, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col5, string); }
    }
    return 1;
} */

/* forward nearbyPlayers(playerid, range);
public nearbyPlayers(playerid, range)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    

    foreach(new i : Player)
    {
        if(GetPlayerDistanceFromPoint(i, x, y, z) < range/16){
            Iter_Add(nearbies[playerid][1], i);
        }else if(GetPlayerDistanceFromPoint(i, x, y, z) < range/8){
            Iter_Add(nearbyPlayers[playerid][2], i)
        }else if(GetPlayerDistanceFromPoint(i, x, y, z) < range/4)
    }
    
} */
forward localChat(playerid, radi, message[]);
public localChat(playerid, radi, message[])
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new nameWithoutTire[24];
    new initialMessage[128];
    format(nameWithoutTire, 24, "%s", Player[playerid][Name]);
    strreplace(nameWithoutTire, "_", " ");
    format(initialMessage, 128, "%s: ", nameWithoutTire);
    strcat(initialMessage, message, 128);

    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, radi / 16, x, y, z)){
            SendClientMessage(i, COLOR_FADE1, initialMessage);
        }else if(IsPlayerInRangeOfPoint(i, radi / 8, x, y, z)){
            SendClientMessage(i, COLOR_FADE2, initialMessage);
        }else if(IsPlayerInRangeOfPoint(i, radi / 4, x, y, z)){
            SendClientMessage(i, COLOR_FADE3, initialMessage);
        }else if(IsPlayerInRangeOfPoint(i, radi / 2, x, y, z)){
            SendClientMessage(i, COLOR_FADE4, initialMessage);
        }else if(IsPlayerInRangeOfPoint(i, radi, x, y, z)){
            SendClientMessage(i, COLOR_FADE5, initialMessage);
        }
    }
}

CMD:me(playerid, params[]){
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new nameWithoutTire[24];
    new initialMessage[128];
    format(nameWithoutTire, 24, "%s", Player[playerid][Name]);
    strreplace(nameWithoutTire, "_", " ");
    format(initialMessage, 128, "%s ", nameWithoutTire);
    strcat(initialMessage, params, 128);

    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, 30, x, y, z))
        SendClientMessage(i, COLOR_PURPLE, initialMessage);
        
    }
    return 1;
}