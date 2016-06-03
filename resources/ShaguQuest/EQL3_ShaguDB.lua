ShaguQuest_AutoPlot = false
ShaguQuest_QueuePlot = true
ShaguQuest_LastQueue = 0

ShaguQuestAutoPlot = CreateFrame("Frame")
ShaguQuestAutoPlot.Button = CreateFrame("Button", nil, EQL3_QuestLogFrame, "UIPanelButtonTemplate")
ShaguQuestAutoPlot.Button:SetWidth(120)
ShaguQuestAutoPlot.Button:SetHeight(20)
ShaguQuestAutoPlot.Button:SetText("|cffffffffAutotrack: |cffffaaaaOff")
ShaguQuestAutoPlot.Button:SetPoint("TOPLEFT", 75,-42)
ShaguQuestAutoPlot:SetFrameStrata("TOOLTIP")

ShaguQuestAutoPlot.Button:SetScript("OnClick", function()
	if ShaguQuest_AutoPlot == false then
		ShaguQuest_AutoPlot = true
    QuestlogOptions[EQL3_Player].AddNew = 1
    QuestlogOptions[EQL3_Player].AddUntracked = 1
		ShaguQuestAutoPlot.Button:SetText("|cffffffffAutotrack: |cffaaffaaOn")
		ShaguQuestAutoPlot:ShowAll()
	else
		ShaguQuest_AutoPlot = false
		ShaguQuestAutoPlot.Button:SetText("|cffffffffAutotrack: |cffffaaaaOff")
		ShaguDB_CleanMap();
	end
end)

ShaguQuestAutoPlot.Button:Show()

ShaguQuestAutoPlot:RegisterEvent("QUEST_LOG_UPDATE");
ShaguQuestAutoPlot:RegisterEvent("PLAYER_ENTERING_WORLD");
ShaguQuestAutoPlot:RegisterEvent("ADDON_LOADED")

ShaguQuestAutoPlot:SetScript("OnEvent", function()
    ShaguQuest_LastQueue = GetTime()
    ShaguQuest_QueuePlot = true
end)

ShaguQuestAutoPlot:SetScript("OnUpdate", function()
    if ShaguQuest_QueuePlot == true and ShaguQuest_LastQueue + .3 <= GetTime() then
        ShaguQuestAutoPlot:ShowAll()
        ShaguQuest_QueuePlot = false
    end
end)

function ShaguQuestAutoPlot:ShowAll()
	if ShaguQuest_AutoPlot == false then
		ShaguQuestAutoPlot.Button:SetText("|cffffffffAutotrack: |cffffaaaaOff")
	else
		ShaguQuestAutoPlot.Button:SetText("|cffffffffAutotrack: |cffaaffaaOn")
	end

	if ShaguQuest_AutoPlot == true then
	local questLogID=1;
  ShaguDB_MAP_NOTES = {};
	ShaguDB_CleanMap();
	while (GetQuestLogTitle(questLogID) ~= nil) do
		questLogID = questLogID + 1;


		local questTitle, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questLogID);
		if (not isHeader and questTitle ~= nil) then
			local numObjectives = GetNumQuestLeaderBoards(questLogID);
			if (numObjectives ~= nil) then

    		-- quest data
    		if (questDB[questTitle] ~= nil) then
      		for monsterName, monsterDrop in pairs(questDB[questTitle]) do
        		if (spawnDB[monsterName] ~= nil and strfind(spawnDB[monsterName]["faction"], faction) ~= nil) then
          		ShaguDB_searchMonster(monsterName,questTitle,true);
        		end
      		end
    		end

				for i=1, numObjectives, 1 do
					local text, type, finished = GetQuestLogLeaderBoard(i, questLogID);
					local i, j, itemName, numItems, numNeeded = strfind(text, "(.*):%s*([%d]+)%s*/%s*([%d]+)");

					if (not finished) then
     				-- spawn data
        		if (type == "monster") then
          		-- enGB
          		local i, j, monsterName = strfind(itemName, "(.*) killed");
          		ShaguDB_searchMonster(monsterName,questTitle);

          		local i, j, monsterName = strfind(itemName, "(.*) slain");
          		ShaguDB_searchMonster(monsterName,questTitle);

          		-- deDE
          		local i, j, monsterName = strfind(itemName, "(.*) getötet");
          		ShaguDB_searchMonster(monsterName,questTitle);

          		-- whatever
          		local i, j, monsterName = strfind(itemName, "(.*)");
          		ShaguDB_searchMonster(monsterName,questTitle);
        		end

        		-- item data
        		if (type == "item") then
			        ShaguDB_searchItem(itemName,questTitle, true);
			        ShaguDB_searchVendor(itemName,questTitle);
     	  		end
					end
				end

			end
		end
		ShaguDB_PlotNotesOnMap()
	end
end

end


function QuestLog_UpdateQuestDetails(doNotScroll)
  if (EQL3_QuestLogFrame ~= nil) then
    ShaguDB_QuestLog_UpdateQuestDetails("EQL3_", doNotScroll);
  else
    ShaguDB_QuestLog_UpdateQuestDetails("", doNotScroll);
  end
end


function ShaguDB_QuestLog_UpdateQuestDetails(prefix, doNotScroll)
  ShaguDB_MAP_NOTES = {};

  if (getglobal(prefix.."QuestLogFrame"):IsVisible()) then
    ShaguDB_MAP_NOTES = {};
    local monsterName, zoneName, noteAdded, showMap, noteID;

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

    -- Show Quest Watch if track quest is checked
    local numObjectives = GetNumQuestLeaderBoards();

    -- quest data
    if (questDB[questTitle] ~= nil) then
      for monsterName, monsterDrop in pairs(questDB[questTitle]) do
        if (spawnDB[monsterName] ~= nil and strfind(spawnDB[monsterName]["faction"], faction) ~= nil) then
          ShaguDB_searchMonster(monsterName,questTitle,true);
        end
      end
    end

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
        -- spawn data
        if (type == "monster") then
          -- enGB
          local i, j, monsterName = strfind(itemName, "(.*) killed");
          ShaguDB_searchMonster(monsterName,questTitle);

          local i, j, monsterName = strfind(itemName, "(.*) slain");
          ShaguDB_searchMonster(monsterName,questTitle);

          -- deDE
          local i, j, monsterName = strfind(itemName, "(.*) getötet");
          ShaguDB_searchMonster(monsterName,questTitle);

          -- whatever
          local i, j, monsterName = strfind(itemName, "(.*)");
          ShaguDB_searchMonster(monsterName,questTitle);
        end

        -- item data
        if (type == "item") then
          ShaguDB_searchItem(itemName,questTitle);
          ShaguDB_searchVendor(itemName,questTitle);
        end
      end
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

    -- {{{ ShaguDB EQL Integration
    -- Button: Frame
    if (getglobal(prefix.."QuestLogMapButtonsFrame") == nil) then getglobal(prefix.."QuestLogDetailScrollChildFrame"):CreateFontString(prefix.."QuestLogMapButtonsFrame","","QuestTitleFont"); end
    getglobal(prefix.."QuestLogMapButtonsFrame"):SetPoint("TOPLEFT", prefix.."QuestLogQuestDescription", "BOTTOMLEFT", 0, -20);
    getglobal(prefix.."QuestLogMapButtonsFrame"):SetHeight(25);
    getglobal(prefix.."QuestLogMapButtonsFrame"):SetWidth(285);

    -- Button: Show
    if (getglobal(prefix.."QuestLogShowMap") == nil) then CreateFrame("Button", prefix.."QuestLogShowMap", getglobal(prefix.."QuestLogDetailScrollChildFrame"), "UIPanelButtonTemplate"); end
    getglobal(prefix.."QuestLogShowMap"):SetText("Show");
    getglobal(prefix.."QuestLogShowMap"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsFrame", "TOPLEFT", 10, 10);
    getglobal(prefix.."QuestLogShowMap"):SetHeight(25);
    getglobal(prefix.."QuestLogShowMap"):SetWidth(125);
    getglobal(prefix.."QuestLogShowMap"):RegisterForClicks("LeftButtonUp");
    getglobal(prefix.."QuestLogShowMap"):SetScript("OnClick", ShaguDB_ShowMap);
    getglobal(prefix.."QuestLogShowMap"):Show();

    -- Button: Clean
    if (getglobal(prefix.."QuestLogCleanMap") == nil) then CreateFrame("Button", prefix.."QuestLogCleanMap", getglobal(prefix.."QuestLogDetailScrollChildFrame"), "UIPanelButtonTemplate"); end
    getglobal(prefix.."QuestLogCleanMap"):SetText("Clean");
    getglobal(prefix.."QuestLogCleanMap"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsFrame", "TOPLEFT", 145, 10);
    getglobal(prefix.."QuestLogCleanMap"):SetHeight(25);
    getglobal(prefix.."QuestLogCleanMap"):SetWidth(125);
    getglobal(prefix.."QuestLogCleanMap"):RegisterForClicks("LeftButtonUp");
    getglobal(prefix.."QuestLogCleanMap"):SetScript("OnClick", ShaguDB_CleanMap);
    getglobal(prefix.."QuestLogCleanMap"):Show();
    -- }}}

    getglobal(prefix.."QuestLogRewardTitleText"):SetPoint("TOPLEFT", prefix.."QuestLogShowMap", "BOTTOMLEFT", -10, -10);
    getglobal(prefix.."QuestLogRewardTitleText"):SetHeight(25);

    local numRewards = GetNumQuestLogRewards();
    local numChoices = GetNumQuestLogChoices();
    local money = GetQuestLogRewardMoney();

    if ( (numRewards + numChoices + money) > 0 ) then
      getglobal(prefix.."QuestLogRewardTitleText"):Show();
      QuestFrame_SetAsLastShown(getglobal(prefix.."QuestLogRewardTitleText"));
    else
      getglobal(prefix.."QuestLogRewardTitleText"):Hide();
    end

    QuestFrameItems_Update("QuestLog");
    if ( not doNotScroll ) then
      getglobal(prefix.."QuestLogDetailScrollFrameScrollBar"):SetValue(0);
    end
    getglobal(prefix.."QuestLogDetailScrollFrame"):UpdateScrollChildRect();
  end
end
