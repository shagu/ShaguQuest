-- Main Script file for Extended Questlog 3.6
-- Copyright © 2006 Daniel Rehn

-- Version text
ShaguQuest_QUESTLOG_VERSION = "v3.6.1";
ShaguQuest_QUESTS_DISPLAYED = 27; -- 6 lol
MAX_QUESTWATCH_LINES = 50;
MAX_WATCHABLE_QUESTS = 20;
ShaguQuest_Player = nil;

-- Options init
QuestlogOptions = {};
ShaguQuest_Temp = {};
ShaguQuest_Temp.QuestList = {};
ShaguQuest_Temp.AddTrack = nil;
ShaguQuest_Temp.updateTime = 0;
ShaguQuest_Temp.updateTarget = 30;
ShaguQuest_Temp.manageHeaders = nil;
ShaguQuest_Temp.hasManaged = nil;
ShaguQuest_Temp.movingWatchFrame = nil;

-- Organizing vars
ShaguQuest_Temp.GotQuestLogUpdate=nil;
ShaguQuest_Temp.savedQuestIDMap=nil;
ShaguQuest_Temp.lastExistingNumEntries = -1;
ShaguQuest_Temp.savedNumEntries=nil;
ShaguQuest_Temp.savedNumQuests=nil;
ShaguQuest_Temp.savedSelectedQuest=nil;
ShaguQuest_Temp.reportedNoQuests=nil;

-- Window handling
UIPanelWindows["ShaguQuest_QuestLogFrame"] =		{ area = "doublewide",	pushable = 0,	whileDead = 1 };





-- Options function
function QuestLog_Options_Toggle()
	-- Insert code to show and hide options frame
	if(ShaguQuest_OptionsFrame:IsVisible()) then
		ShaguQuest_OptionsFrame:Hide();
	else
		ShaguQuest_OptionsFrame:Show();
	end
end

ShaguQuest_TrackerLists = {};
ShaguQuest_TrackerLists[0] = {};
ShaguQuest_TrackerLists[0][0] = "1";
ShaguQuest_TrackerLists[0][1] = "2";
ShaguQuest_TrackerLists[0][2] = "3";
ShaguQuest_TrackerLists[0][3] = "4";
ShaguQuest_TrackerLists[0][4] = "5";
ShaguQuest_TrackerLists[0][5] = "6";
ShaguQuest_TrackerLists[0][6] = "7";
ShaguQuest_TrackerLists[0][7] = "8";
ShaguQuest_TrackerLists[0][8] = "9";
ShaguQuest_TrackerLists[0][9] = "10";

ShaguQuest_TrackerLists[1] = {};
ShaguQuest_TrackerLists[1][0] = "a";
ShaguQuest_TrackerLists[1][1] = "b";
ShaguQuest_TrackerLists[1][2] = "c";
ShaguQuest_TrackerLists[1][3] = "d";
ShaguQuest_TrackerLists[1][4] = "e";
ShaguQuest_TrackerLists[1][5] = "f";
ShaguQuest_TrackerLists[1][6] = "g";
ShaguQuest_TrackerLists[1][7] = "h";
ShaguQuest_TrackerLists[1][8] = "i";
ShaguQuest_TrackerLists[1][9] = "j";

ShaguQuest_TrackerLists[2] = {};
ShaguQuest_TrackerLists[2][0] = "A";
ShaguQuest_TrackerLists[2][1] = "B";
ShaguQuest_TrackerLists[2][2] = "C";
ShaguQuest_TrackerLists[2][3] = "D";
ShaguQuest_TrackerLists[2][4] = "E";
ShaguQuest_TrackerLists[2][5] = "F";
ShaguQuest_TrackerLists[2][6] = "G";
ShaguQuest_TrackerLists[2][7] = "H";
ShaguQuest_TrackerLists[2][8] = "I";
ShaguQuest_TrackerLists[2][9] = "J";

ShaguQuest_TrackerLists[3] = {};
ShaguQuest_TrackerLists[3][0] = "I";
ShaguQuest_TrackerLists[3][1] = "II";
ShaguQuest_TrackerLists[3][2] = "III";
ShaguQuest_TrackerLists[3][3] = "IV";
ShaguQuest_TrackerLists[3][4] = "V";
ShaguQuest_TrackerLists[3][5] = "VI";
ShaguQuest_TrackerLists[3][6] = "VII";
ShaguQuest_TrackerLists[3][7] = "VIII";
ShaguQuest_TrackerLists[3][8] = "IX";
ShaguQuest_TrackerLists[3][9] = "X";

ShaguQuest_TrackerSymbols = {};
ShaguQuest_TrackerSymbols[0] = "-";
ShaguQuest_TrackerSymbols[1] = "+";
ShaguQuest_TrackerSymbols[2] = "@";
ShaguQuest_TrackerSymbols[3] = ">";


-- Fix for escape button... should'nt mess with oRA any more...

ShaguQuest_old_CloseWindows = CloseWindows;

function CloseWindows(ignoreCenter)
	if ( ShaguQuest_QuestLogFrame:IsVisible() ) then
		HideUIPanel(ShaguQuest_QuestLogFrame);
		return ShaguQuest_QuestLogFrame;
	end
	
	return ShaguQuest_old_CloseWindows(ignoreCenter);
end





function decToHex(Dec, Length)
	local B, K, Hex, I, D = 16, "0123456789ABCDEF", "", 0;
	while Dec>0 do
		I=I+1;
		Dec, D = math.floor(Dec/B), math.mod(Dec,B)+1;
		Hex=string.sub(K,D,D)..Hex;
	end
	if( (Length ~= nil) and (string.len(Hex) < Length) ) then
		local temp, i = Length-string.len(Hex), 1;
		for i=1, temp, 1 do
			Hex = "0"..Hex;
		end
	end
	return Hex;
end

function ShaguQuest_ColorText(t, r, g, b)
	if ( t == nil ) then t = ""; end
	if ( r == nil ) then r = 0.0; end
	if ( g == nil ) then g = 0.0; end
	if ( b == nil ) then b = 0.0; end
	return "|CFF"..decToHex(r*255, 2)..decToHex(g*255, 2)..decToHex(b*255, 2)..t.."|r";
end
