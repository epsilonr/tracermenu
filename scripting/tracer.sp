#include <sourcemod>
#include <sdktools>
#include <clientprefs>

#pragma semicolon 1

public Plugin myinfo =
{
	name = "Mermi Izleri",
	author = "Nokta",
	description = "",
	version = "1.0",
	url = "https://github.com/epsilonr"
};

Handle g_hClientCookie = INVALID_HANDLE;

int g_Renk[MAXPLAYERS + 1];

int g_iBeam = -1;

float g_cvarTracerLife = 0.3;
float g_cvarTracerWidth = 1.0;

bool g_Enabled[MAXPLAYERS + 1];

public void OnPluginStart()
{
	Precache();
	
	g_hClientCookie = RegClientCookie("Tracers", "Tracers", CookieAccess_Private);	
	
	HookEvent("bullet_impact", Event_BulletImpact);
	
	RegConsoleCmd("sm_tracers", Command_Tracers);
	RegConsoleCmd("sm_tracer", Command_Tracers);
	
	for (int i = 1; i <= MaxClients; ++i)
	{
		if (!AreClientCookiesCached(i))
		{
			continue;
		}
		
		OnClientCookiesCached(i);
	}
}

public void OnClientCookiesCached(int client)
{
	char sValue[8];
	char dValue[8];
	GetClientCookie(client, g_hClientCookie, sValue, sizeof(sValue));
	GetClientCookie(client, g_hClientCookie, dValue, sizeof(dValue));
	
	g_Renk[client] = StringToInt(sValue);
	g_Enabled[client] = (sValue[0] != '\0' && StringToInt(sValue));
}

public void OnMapStart()
{
	Precache();
}

public Action Event_BulletImpact(Event event ,const char[] name, bool dB)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if(GetClientTeam(client) == 3 && IsdsfPlayerVIP(client) && g_Renk[client] != -1)
	{
		float m_fOrigin[3];
		float m_fImpact[3];
		
		GetClientEyePosition(client, m_fOrigin);

		m_fImpact[0] = GetEventFloat(event, "x");
		m_fImpact[1] = GetEventFloat(event, "y");
		m_fImpact[2] = GetEventFloat(event, "z");
		
		int g_FRenk[4];
		g_FRenk[3] = 150;
		
		if(g_Renk[client] == 1)
		{
			g_FRenk[0] = 255;
			g_FRenk[1] = 0;
			g_FRenk[2] = 0;
		}
		
		if(g_Renk[client] == 2)
		{
			g_FRenk[0] = 255;
			g_FRenk[1] = 20;
			g_FRenk[2] = 147;
		}
		
		if(g_Renk[client] == 3)
		{
			g_FRenk[0] = 128;
			g_FRenk[1] = 0;
			g_FRenk[2] = 128;
		}
		
		if(g_Renk[client] == 4)
		{
			g_FRenk[0] = 255;
			g_FRenk[1] = 255;
			g_FRenk[2] = 255;
		}
		
		if(g_Renk[client] == 5)
		{
			g_FRenk[0] = 105;
			g_FRenk[1] = 105;
			g_FRenk[2] = 105;
		}
		
		if(g_Renk[client] == 6)
		{
			g_FRenk[0] = 255;
			g_FRenk[1] = 165;
			g_FRenk[2] = 0;
		}
		
		if(g_Renk[client] == 7)
		{
			g_FRenk[0] = 0;
			g_FRenk[1] = 0;
			g_FRenk[2] = 255;
		}

		if(g_Renk[client] == 8)
		{
			g_FRenk[0] = 0;
			g_FRenk[1] = 255;
			g_FRenk[2] = 0;
		}
		
		if(g_Renk[client] == 9)
		{
			float i = GetGameTime();
			float Frequency = 2.5;
			g_FRenk[0] = RoundFloat(Sine(Frequency * i + 0.0) * 127.0 + 128.0);
			g_FRenk[1] = RoundFloat(Sine(Frequency * i + 2.0943951) * 127.0 + 128.0);
			g_FRenk[2] = RoundFloat(Sine(Frequency * i + 4.1887902) * 127.0 + 128.0);
		}
		
		
		TE_SetupBeamPoints(m_fOrigin, m_fImpact, g_iBeam, 0, 0, 0, g_cvarTracerLife, g_cvarTracerWidth, g_cvarTracerWidth, 1, 0.0, g_FRenk, 0);
		TE_SendToAll();

		return Plugin_Continue;
	}
	
	return Plugin_Continue;
}

public Action Command_Tracers(int client, int args)
{
	if(!IsClientInGame(client))
		return Plugin_Handled;
		
	if(!IsdsfPlayerVIP(client))
	{
		PrintToChat(client, " \x04[Tracers]\x01 You must be \x07VIP\x01 to use this command.");
		return Plugin_Handled;
	}	
	
	AnaMenu(client);
	return Plugin_Handled;
}

/*
public Action Command_Mermi(int client, int args)
{
	if(!IsValidPlayer(client))
	{
		return Plugin_Handled;
	}

	if(g_Enabled[client] == true)
	{
		PrintToChat(client, " \x04[Tracers]\x01 Mermi izlerini artık görebilirsiniz.");
		g_SEnabled[client] = false;
		char sCookieValue[12];
		IntToString(0, sCookieValue, sizeof(sCookieValue));
		SetClientCookie(client, g_hClientCookie, sCookieValue);
		return Plugin_Handled;
	}
	
	if(g_Enabled[client] == false)
	{
		PrintToChat(client, " \x04[Tracers]\x01 Mermi izlerini gizlediniz.");
		g_SEnabled[client] = true;
		char sCookieValue[12];
		IntToString(1, sCookieValue, sizeof(sCookieValue));
		SetClientCookie(client, g_hClientCookie, sCookieValue);
		return Plugin_Handled;
	}
	return Plugin_Handled;
}
*/

void AnaMenu(int client)
{
	Menu menu = new Menu(Handler_Main);
	menu.SetTitle("[Mermi Izleri]\n ");
	menu.AddItem("kapat", "Reset Settings\n ");
	menu.AddItem("kir", "Red");
	menu.AddItem("yes", "Green");
	menu.AddItem("pem", "Pink");
	menu.AddItem("mor", "Purple");
	menu.AddItem("tur", "Orange");
	menu.AddItem("mav", "Blue");
	menu.AddItem("bey", "White");
	menu.AddItem("gri", "Grey");
	menu.AddItem("gok", "Rainbow\n ");
	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

public int Handler_Main(Menu menu, MenuAction action, int client, int itemNum)
{
	switch (action)
	{	

		case MenuAction_Display:
		{
			char buffer[255];
			Format(buffer, sizeof(buffer), "[Mermi Izleri]\n ", client);
			
			Panel panel = view_as<Panel>(itemNum);
			panel.SetTitle(buffer);
		}

		case MenuAction_Select:
		{
			char sCookieValue[8];
			char item[32];
			menu.GetItem(itemNum, item, sizeof(item));
			
			if (StrEqual(item, "kir"))
			{
				g_Renk[client] = 1;
				IntToString(g_Renk[client], sCookieValue, sizeof(sCookieValue));
				SetClientCookie(client, g_hClientCookie, sCookieValue);
			}
			if (StrEqual(item, "pem"))
			{
				g_Renk[client] = 2;
				IntToString(g_Renk[client], sCookieValue, sizeof(sCookieValue));
				SetClientCookie(client, g_hClientCookie, sCookieValue);
			}
			if (StrEqual(item, "mor"))
			{
				g_Renk[client] = 3;
				IntToString(g_Renk[client], sCookieValue, sizeof(sCookieValue));
				SetClientCookie(client, g_hClientCookie, sCookieValue);
			}
			if (StrEqual(item, "bey"))
			{
				g_Renk[client] = 4;
				IntToString(g_Renk[client], sCookieValue, sizeof(sCookieValue));
				SetClientCookie(client, g_hClientCookie, sCookieValue);
			}
			if (StrEqual(item, "gri"))
			{
				g_Renk[client] = 5;
				IntToString(g_Renk[client], sCookieValue, sizeof(sCookieValue));
				SetClientCookie(client, g_hClientCookie, sCookieValue);
			}
			if (StrEqual(item, "tur"))
			{
				g_Renk[client] = 6;
				IntToString(g_Renk[client], sCookieValue, sizeof(sCookieValue));
				SetClientCookie(client, g_hClientCookie, sCookieValue);
			}
			if (StrEqual(item, "mav"))
			{
				g_Renk[client] = 7;
				IntToString(g_Renk[client], sCookieValue, sizeof(sCookieValue));
				SetClientCookie(client, g_hClientCookie, sCookieValue);
			}
			if (StrEqual(item, "yes"))
			{
				g_Renk[client] = 8;
				IntToString(g_Renk[client], sCookieValue, sizeof(sCookieValue));
				SetClientCookie(client, g_hClientCookie, sCookieValue);
			}
			if (StrEqual(item, "gok"))
			{
				g_Renk[client] = 9;
				IntToString(g_Renk[client], sCookieValue, sizeof(sCookieValue));
				SetClientCookie(client, g_hClientCookie, sCookieValue);
			}
			
			if (StrEqual(item, "kapat"))
			{
				g_Renk[client] = -1;
				IntToString(g_Renk[client], sCookieValue, sizeof(sCookieValue));
				SetClientCookie(client, g_hClientCookie, sCookieValue);
			}
		}
		
		case MenuAction_End:
		{
			delete menu;
		}
	}
}

void Precache()
{
	g_iBeam = PrecacheModel("materials/sprites/laserbeam.vmt", true);
}

stock bool IsdsfPlayerVIP(int client)
{
	if(GetUserFlagBits(client) & ADMFLAG_RESERVATION) return true;
	if(CheckCommandAccess(client, "sm_slay", true))return true;
	return false;
}