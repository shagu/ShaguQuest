ShaguQuest_MAP_NOTES = {};
ShaguQuest_QuestZoneInfo = {};
cMark = "Star";

function ShaguQuest_Init()
	this:RegisterEvent("VARIABLES_LOADED");
	SlashCmdList["SHAGU"] = Shagu_Slash;
	SLASH_SHAGU1 = "/shagu";
end

function ShaguQuest_Event(event)
	if (event == "VARIABLES_LOADED") then
		ShaguQuestDB = {}; ShaguQuestDBH = {};
		Cartographer_Notes:RegisterNotesDatabase("ShaguQuest",ShaguQuestDB,ShaguQuestDBH);
	end
	ShaguQuest_Print("|cff33ff88ShaguQuest|cffffffff oooVersionooo|caaaaaaaa [oooLocaleooo]");
end

function Shagu_Slash(input)
  local params = {}; 
  if (input == "" or input == nil) then
    ShaguQuest_Print("|cffffff00ShaguQuest|cffffffff Commands:");
	ShaguQuest_Print("/shagu spawn <mob|gameobject>");
    ShaguQuest_Print("/shagu item <item>");
	ShaguQuest_Print("/shagu quests <map>");    
    ShaguQuest_Print("/shagu quest <questname>");
    ShaguQuest_Print("/shagu clean");
  end 

  local commandlist = { } 
  local command
			  
  for command in string.gfind(input, "[^ ]+") do
  	table.insert(commandlist, command)
  end 

  arg1 = commandlist[1];
  arg2 = "";

  -- handle whitespace mob- and item names correctly						
  for i in commandlist do
  	if (i ~= 1) then
		arg2 = arg2 .. commandlist[i];
		if (commandlist[i+1] ~= nil) then
			arg2 = arg2 .. " "
		end
	end
  end

  -- argument: item
  if (arg1 == "item") then
    local itemName = arg2;
    ShaguQuest_MAP_NOTES = {};
	ShaguQuest_searchItem(itemName,nil)
	ShaguQuest_NextCMark();
	ShaguQuest_ShowMap();		   
  end

  -- argument: spawn
  if (arg1 == "spawn") then
    local monsterName = arg2;
    ShaguQuest_MAP_NOTES = {};
	ShaguQuest_searchMonster(monsterName,nil)
	ShaguQuest_NextCMark();
	ShaguQuest_ShowMap();
  end


  -- argument: quests
  if (arg1 == "quests") then
    local zoneName = arg2;
	if(zoneName == "")then
		zoneName = GetZoneText();
	end

    ShaguQuest_MAP_NOTES = {};
	ShaguQuest_searchQuests(zoneName)
	ShaguQuest_NextCMark();
	ShaguQuest_ShowMap();
  end

  -- argument: quests
  if (arg1 == "quest") then
    local questTitle = arg2;

    ShaguQuest_MAP_NOTES = {};
	if (questData[questTitle] ~= nil) then
       	for monsterName, monsterDrop in pairs(questData[questTitle]) do
			ShaguQuest_searchMonster(monsterName,questTitle,true);
		end
	end
	ShaguQuest_NextCMark();
	ShaguQuest_ShowMap();
  end



  -- argument: clean
  if (arg1 == "clean") then
    ShaguQuest_CleanMap();
  end
end

function ShaguQuest_Print(string)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffffff" .. string);
end

function QuestLog_UpdateQuestDetails(doNotScroll)
	if (EQL3_QuestLogFrame ~= nil) then
		ShaguQuest_QuestLog_UpdateQuestDetails("EQL3_", doNotScroll);
	else
		ShaguQuest_QuestLog_UpdateQuestDetails("", doNotScroll);
	end
end

function ShaguQuest_QuestLog_UpdateQuestDetails(prefix, doNotScroll)
	if (getglobal(prefix.."QuestLogFrame"):IsVisible()) then
	ShaguQuest_MAP_NOTES = {};
	local questID = GetQuestLogSelection();
	local questTitle = GetQuestLogTitle(questID);

	if ( not questTitle ) then
		questTitle = "";
	end
	if ( IsCurrentQuestFailed() ) then
		questTitle = questTitle.." - ("..TEXT(FAILED)..")";
	end
	getglobal(prefix.."QuestLogQuestTitle"):SetText(questTitle);

	local questDescription;
	local questObjectives;
	questDescription, questObjectives = GetQuestLogQuestText();
	getglobal(prefix.."QuestLogObjectivesText"):SetText(questObjectives);
	
	local questTimer = GetQuestLogTimeLeft();
	if ( questTimer ) then
		getglobal(prefix.."QuestLogFrame").hasTimer = 1;
		getglobal(prefix.."QuestLogFrame").timePassed = 0;
		getglobal(prefix.."QuestLogTimerText"):Show();
		getglobal(prefix.."QuestLogTimerText"):SetText(TEXT(TIME_REMAINING).." "..SecondsToTime(questTimer));
		getglobal(prefix.."QuestLogObjective1"):SetPoint("TOPLEFT", prefix.."QuestLogTimerText", "BOTTOMLEFT", 0, -10);
	else
		getglobal(prefix.."QuestLogFrame").hasTimer = nil;
		getglobal(prefix.."QuestLogTimerText"):Hide();
		getglobal(prefix.."QuestLogObjective1"):SetPoint("TOPLEFT", prefix.."QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
	end
	
	local numObjectives = GetNumQuestLeaderBoards();

	local monsterName, zoneName, noteAdded, showMap, noteID;
	for i=1, numObjectives, 1 do
		local string = getglobal(prefix.."QuestLogObjective"..i);
		local text;
		local type;
		local finished;

		text, type, finished = GetQuestLogLeaderBoard(i);
		if ( not text or strlen(text) == 0 ) then
			text = type;
		end
		local i, j, itemName, numItems, numNeeded = strfind(text, "(.*):%s*([%d]+)%s*/%s*([%d]+)");
		if ( finished ) then
			string:SetTextColor(0.2, 0.2, 0.2);
			text = text.." ("..TEXT(COMPLETE)..")";
		else
			string:SetTextColor(0, 0, 0);
		end
		
		showMap = true;

		-- quest data
		if (questData[questTitle] ~= nil) then
        	for monsterName, monsterDrop in pairs(questData[questTitle]) do
				ShaguQuest_searchMonster(monsterName,questTitle,true);
			end
		end

		-- spawn data
		if (type == "monster") then
			-- enGB
			local i, j, monsterName = strfind(itemName, "(.*) killed");
			ShaguQuest_searchMonster(monsterName,questTitle);

			local i, j, monsterName = strfind(itemName, "(.*) slain");
			ShaguQuest_searchMonster(monsterName,questTitle);

			-- deDE
			local i, j, monsterName = strfind(itemName, "(.*) getötet");
			ShaguQuest_searchMonster(monsterName,questTitle);

			-- frFR
			local i, j, monsterName = strfind(itemName, "(.*) tué");
			ShaguQuest_searchMonster(monsterName,questTitle);

			local i, j, monsterName = strfind(itemName, "(.*) tués");
			ShaguQuest_searchMonster(monsterName,questTitle);

			-- whatever
			local i, j, monsterName = strfind(itemName, "(.*)");
			ShaguQuest_searchMonster(monsterName,questTitle);
		end

		-- item data
		if (type == "item") then
			ShaguQuest_searchItem(itemName,questTitle);
		end

		ShaguQuest_NextCMark();
		string:SetText(text);
		string:Show();
		QuestFrame_SetAsLastShown(string);
	end

	for i=numObjectives + 1, MAX_OBJECTIVES, 1 do
		getglobal(prefix.."QuestLogObjective"..i):Hide();
	end



	if ( GetQuestLogRequiredMoney() > 0 ) then
		if ( numObjectives > 0 ) then
			getglobal(prefix.."QuestLogRequiredMoneyText"):SetPoint("TOPLEFT", "QuestLogObjective"..numObjectives, "BOTTOMLEFT", 0, -4);
		else
			getglobal(prefix.."QuestLogRequiredMoneyText"):SetPoint("TOPLEFT", "QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
		end
		
		MoneyFrame_Update(prefix.."QuestLogRequiredMoneyFrame", GetQuestLogRequiredMoney());
		
		if ( GetQuestLogRequiredMoney() > GetMoney() ) then
			getglobal(prefix.."QuestLogRequiredMoneyText"):SetTextColor(0, 0, 0);
			SetMoneyFrameColor(prefix.."QuestLogRequiredMoneyFrame", 1.0, 0.1, 0.1);
		else
			getglobal(prefix.."QuestLogRequiredMoneyText"):SetTextColor(0.2, 0.2, 0.2);
			SetMoneyFrameColor(prefix.."QuestLogRequiredMoneyFrame", 1.0, 1.0, 1.0);
		end
		getglobal(prefix.."QuestLogRequiredMoneyText"):Show();
		getglobal(prefix.."QuestLogRequiredMoneyFrame"):Show();
	else
		getglobal(prefix.."QuestLogRequiredMoneyText"):Hide();
		getglobal(prefix.."QuestLogRequiredMoneyFrame"):Hide();
	end

	if ( GetQuestLogRequiredMoney() > 0 ) then
		getglobal(prefix.."QuestLogDescriptionTitle"):SetPoint("TOPLEFT", prefix.."QuestLogRequiredMoneyText", "BOTTOMLEFT", 0, -10);
	elseif ( numObjectives > 0 ) then
		getglobal(prefix.."QuestLogDescriptionTitle"):SetPoint("TOPLEFT", prefix.."QuestLogObjective"..numObjectives, "BOTTOMLEFT", 0, -10);
	else
		if ( questTimer ) then
			getglobal(prefix.."QuestLogDescriptionTitle"):SetPoint("TOPLEFT", prefix.."QuestLogTimerText", "BOTTOMLEFT", 0, -10);
		else
			getglobal(prefix.."QuestLogDescriptionTitle"):SetPoint("TOPLEFT", prefix.."QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
		end
	end
	if ( questDescription ) then
		getglobal(prefix.."QuestLogQuestDescription"):SetText(questDescription);
		QuestFrame_SetAsLastShown(getglobal(prefix.."QuestLogQuestDescription"));
	end	
	
	if (getglobal(prefix.."QuestLogMapButtonsTitle") == nil) then
		getglobal(prefix.."QuestLogDetailScrollChildFrame"):CreateFontString(prefix.."QuestLogMapButtonsTitle","","QuestTitleFont");
	end


	local r, g, b, a = getglobal(prefix.."QuestLogQuestDescription"):GetTextColor();
	
	getglobal(prefix.."QuestLogRewardTitleText"):SetPoint("TOPLEFT", prefix.."QuestLogQuestDescription", "BOTTOMLEFT", 0, -15);

	if (getglobal(prefix.."QuestLogShowMap") == nil) then
		CreateFrame("Button", prefix.."QuestLogShowMap", getglobal(prefix.."QuestLogDetailScrollChildFrame"), "UIPanelButtonTemplate");
		CreateFrame("Button", prefix.."QuestLogCleanMap", getglobal(prefix.."QuestLogDetailScrollChildFrame"), "UIPanelButtonTemplate");
	end
	
	getglobal(prefix.."QuestLogShowMap"):SetText("Show");
	getglobal(prefix.."QuestLogShowMap"):SetPoint("TOPLEFT", prefix.."QuestLogQuestDescription", "BOTTOMLEFT", 0, -10);
	getglobal(prefix.."QuestLogShowMap"):SetHeight(25);
	getglobal(prefix.."QuestLogShowMap"):SetWidth(125);
	getglobal(prefix.."QuestLogShowMap"):RegisterForClicks("LeftButtonUp");
	getglobal(prefix.."QuestLogShowMap"):SetScript("OnClick", ShaguQuest_ShowMap);
	
	getglobal(prefix.."QuestLogCleanMap"):SetText("Clean");
	getglobal(prefix.."QuestLogCleanMap"):SetPoint("TOPLEFT", prefix.."QuestLogQuestDescription", "BOTTOMLEFT", 155, -10);
	getglobal(prefix.."QuestLogCleanMap"):SetHeight(25);
	getglobal(prefix.."QuestLogCleanMap"):SetWidth(125);
	getglobal(prefix.."QuestLogCleanMap"):RegisterForClicks("LeftButtonUp");
	getglobal(prefix.."QuestLogCleanMap"):SetScript("OnClick", ShaguQuest_CleanMap);

	local numRewards = GetNumQuestLogRewards();
	local numChoices = GetNumQuestLogChoices();
	local money = GetQuestLogRewardMoney();

	if ( (numRewards + numChoices + money) > 0 ) then
		getglobal(prefix.."QuestLogRewardTitleText"):Show();
		QuestFrame_SetAsLastShown(getglobal(prefix.."QuestLogRewardTitleText"));
	else
		getglobal(prefix.."QuestLogRewardTitleText"):Hide();
	end

	if (not showMap) then
		getglobal(prefix.."QuestLogShowMap"):Hide();
		getglobal(prefix.."QuestLogCleanMap"):Hide();
	else
		getglobal(prefix.."QuestLogShowMap"):Show();
		getglobal(prefix.."QuestLogCleanMap"):Show();
	end
	
	QuestFrameItems_Update("QuestLog");
	if ( not doNotScroll ) then
		getglobal(prefix.."QuestLogDetailScrollFrameScrollBar"):SetValue(0);
	end
	getglobal(prefix.."QuestLogDetailScrollFrame"):UpdateScrollChildRect();	
end
end

function ShaguQuest_NextCMark()
	if (cMark == "Star") then
		cMark = "Circle";
	elseif (cMark == "Circle") then
		cMark = "Diamond";
	elseif (cMark == "Diamond") then
		cMark = "Triangle";
	elseif (cMark == "Triangle") then
		cMark = "Moon";
	elseif (cMark == "Moon") then
		cMark = "Square";
	elseif (cMark == "Square") then
		cMark = "Cross";
	elseif (cMark == "Cross") then
		cMark = "Skull";
	elseif (cMark == "Skull") then
		cMark = "Star";
	end
end

function ShaguQuest_PlotNotesOnMap()
	local zone = nil;
	local title = nil;
	local noteID = nil;

	for nKey, nData in ipairs(ShaguQuest_MAP_NOTES) do
		Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, nData[6], "ShaguQuest", 'title', nData[4], 'info', nData[5]);

		if (nData[1] ~= nil) then
			zone = nData[1];
			title = nData[4];
		end
	end
	return zone, title, noteID;
end

function ShaguQuest_GetMapIDFromZome(zoneText)
	for cKey, cName in ipairs{GetMapContinents()} do
		for zKey,zName in ipairs{GetMapZones(cKey)} do
			if(zoneText == zName) then
				return cKey, zKey;
			end
		end
	end
	return -1, zoneText;
end

function ShaguQuest_ShowMap()
	local ShowMapZone, ShowMapTitle, ShowMapID = ShaguQuest_PlotNotesOnMap();

	if (Cartographer) then
		if (ShowMapZone ~= nil) then
			WorldMapFrame:Show();	
			if (bestZone ~= nil) then
			  SetMapZoom(ShaguQuest_GetMapIDFromZome(bestZone));
			end									
		end
	end
end

function ShaguQuest_searchMonster(monsterName,questTitle,questGiver)
    if (monsterName ~= "" and monsterName ~= nil and spawnData[monsterName] ~= nil) then
		bestDiff = 100;

        for cid, cdata in pairs(spawnData[monsterName]["coords"]) do
			local f, t, coordx, coordy, zone, zoneDiff = strfind(spawnData[monsterName]["coords"][cid], "(.*),(.*),(.*),(.*)");
			zoneDiff = tonumber(zoneDiff);
			zoneName = zoneData[tonumber(zone)];
			
			if(questTitle ~= nil) then
				if(questGiver ~= nil) then
					table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, questTitle, monsterName, "quest", 0});
				else
					table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, questTitle, monsterName, cMark, 0});
				end
			else
				table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, monsterName, coordx..","..coordy, cMark, 0});
			end

			-- detect best map
			if (zoneDiff <= bestDiff) then
				bestZone = zoneData[tonumber(zone)];
				bestDiff = zoneDiff;
			end
		end
	end
end

function ShaguQuest_searchQuests(zoneName)
    if (zoneName ~= "" and zoneName ~= nil) then
		bestZone = zoneName;
		-- detect zone id by name
		for zoneDB, zoneDBName in pairs(zoneData) do
			if(zoneDBName == zoneName) then
				zone = zoneDB
			end
		end

		if(zone ~= nil) then
			for questTitle, questGiver in pairs(questData) do
				for questGiver in pairs(questGiver) do
					if (questGiver ~= "" and questGiver ~= nil and spawnData[questGiver] ~= nil) then
						for cid, cdata in pairs(spawnData[questGiver]["coords"]) do
							local f, t, coordx, coordy, zoneGiver, zoneDiff = strfind(spawnData[questGiver]["coords"][cid], "(.*),(.*),(.*),(.*)");

							if(tonumber(zoneGiver) == tonumber(zone)) then
								table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, questTitle, questGiver, "quest", 0});
							end
						end
					end			
				end
			end
		end
	end
end

function ShaguQuest_searchItem(itemName,questTitle)
    if (itemName ~= "" and itemData[itemName] ~= nil) then
		if(questTitle == nil) then
   			ShaguQuest_Print("|cff33ff88Search: |cffffffff"..itemName);
	        showmax = 5;
		end

		for id, monsterNameDrop in pairs(itemData[itemName]) do
			local f, t, monsterName, monsterDrop = strfind(itemData[itemName][id], "(.*),(.*)");

			local dropRate = monsterDrop;

			if (dropRate == nil) then dropRate = ""; else dropRate = string.format("%.2f", tonumber(dropRate)) .. "%"; end

			if(spawnData[monsterName] ~= nil) then
				bestDiff = 100;
				zoneList = " "
				for cid, cdata in pairs(spawnData[monsterName]["coords"]) do
					local f, t, coordx, coordy, zone, zoneDiff = strfind(spawnData[monsterName]["coords"][cid], "(.*),(.*),(.*),(.*)");
					zoneDiff = tonumber(zoneDiff);
					zoneName = zoneData[tonumber(zone)];

					if(questTitle ~= nil) then
						table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, questTitle, monsterName .. "\nDrop: " ..itemName  .. "\nDropchance: " .. dropRate, cMark, 0});
					else
						table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, itemName, monsterName .. "\nDrop: " .. dropRate, cMark, 0});
					end	

					-- detect best map
					if (zoneDiff <= bestDiff) then
						bestZone = zoneData[tonumber(zone)];

						if(firstIsBest ~= true) then
							globalBestZone = bestZone;
						end
						bestDiff = zoneDiff;
					end

					-- build zone string
					if (zoneName ~= oldZone and strfind(zoneList, zoneName) == nil) then
						zoneList = zoneList .. "[" .. zoneName .. "] "
						oldZone = zoneName
					end
				end
				if(questTitle == nil) then
					ShaguQuest_Print(" |cffffffff (" .. dropRate .. ")" .. " |cffffff00" .. monsterName .. "|caaaaaaaa " .. zoneList);
				end
				if(questTitle == nil) then
					firstIsBest = true;
					showmax = showmax - 1;
					if (showmax == 0) then
						break;
					end
				end
			end
		end
		if(questTitle == nil) then
			bestZone = globalBestZone;
		end
	end
end

function ShaguQuest_CleanMap()
	if (Cartographer_Notes ~= nil) then
		Cartographer_Notes:UnregisterNotesDatabase("ShaguQuest");
		ShaguQuestDB = {}; ShaguQuestDBH = {};
		Cartographer_Notes:RegisterNotesDatabase("ShaguQuest",ShaguQuestDB,ShaguQuestDBH);
	end
end

function ShaguQuest_PopulateZones()
	local numEntries, numQuests = GetNumQuestLogEntries();
	local lastZone, questLogTitleText, suggestedGroup, level, questTag, isHeader, isCollapsed, isComplete;
	for i=1, numEntries, 1 do
		questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
		if (isHeader) then
			lastZone = questLogTitleText;
		else
			ShaguQuest_QuestZoneInfo[questLogTitleText] = lastZone;
		end
	end
end
