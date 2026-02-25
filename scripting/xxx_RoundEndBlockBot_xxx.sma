/*

    RoundEndBlockBot
    Author: xxxVVLxxx

    Requirements:
        AMX Mod X 1.9+
        Modules:
            fakemeta
            hamsandwich
            cstrike

*/
#include <amxmodx>
#include <fakemeta>
#include <fakemeta_const>
#include <cstrike>
#include <hamsandwich>

new botteam[3]

static const botnames[3][] = {
    "NULL", 
    "T Team",             //Change Terrorist Bot Name
    "CT Team"    //Change CT Bot name
    }

public plugin_init() 
{
    register_plugin("xxx_RoundEndBlockBot_xxx", "1.3", "xxxVVLxxx")
    register_event("HLTV","StartRound","a","1=0","2=0")
	RegisterHam(Ham_Spawn, "player", "BlockSpawn", 0)
    createBots()
}

public StartRound()
    set_task(0.5, "PostStartRound", 0)

public PostStartRound()
{
    for(new x=1; x<3; x++)
    {
        new id = botteam[x]
        if(!is_user_connected(id))
            continue

        // invisible
        set_pev(id, pev_effects, pev(id, pev_effects) | EF_NODRAW)

        // no collision
        set_pev(id, pev_solid, SOLID_NOT)

        // no movement
        set_pev(id, pev_movetype, MOVETYPE_NONE)

        // immortal
        set_pev(id, pev_takedamage, DAMAGE_NO)

        // freeze position
        set_pev(id, pev_flags, pev(id, pev_flags) | FL_FROZEN)
    }
}

createBots()
{
    new bot, x
    for(x = 1; x<3; x++) 
    {
        //is bot in server already?
        bot = find_player("bli", botnames[x] )
        if(bot) {
            botteam[x] = bot
            continue
        }
        
        //bot not in server, create them.
        bot = engfunc(EngFunc_CreateFakeClient, botnames[x])
        botteam[x] = bot
        new ptr[128]
        dllfunc(DLLFunc_ClientConnect, bot, botnames[x], "127.0.0.1", ptr )
        dllfunc(DLLFunc_ClientPutInServer, bot)
		set_pev(bot, pev_deadflag, DEAD_DEAD)
		set_pev(bot, pev_health, 0.0)
        select_model(bot, x)
    }
}

select_model(id,team)
    switch(team) {
        case 1: cs_set_user_team(id, CS_TEAM_T, CS_T_TERROR)
        case 2: cs_set_user_team(id, CS_TEAM_CT, CS_CT_URBAN)
    } 

public BlockSpawn(id)
{
    for(new x = 1; x < 3; x++)
    {
        if(id == botteam[x])
        {
            return HAM_SUPERCEDE
        }
    }

    return HAM_IGNORED
}