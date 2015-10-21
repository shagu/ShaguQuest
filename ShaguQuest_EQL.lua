function QuestLog_UpdateQuestDetails(doNotScroll)
  if (EQL3_QuestLogFrame ~= nil) then
    ShaguQuest_QuestLog_UpdateQuestDetails("EQL3_", doNotScroll);
  else
    ShaguQuest_QuestLog_UpdateQuestDetails("", doNotScroll);
  end
end


function ShaguQuest_QuestLog_UpdateQuestDetails(prefix, doNotScroll)
  ShaguQuest_MAP_NOTES = {};

  if (getglobal(prefix.."QuestLogFrame"):IsVisible()) then
    ShaguQuest_MAP_NOTES = {};
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
    if (questData[questTitle] ~= nil) then
      for monsterName, monsterDrop in pairs(questData[questTitle]) do
        if (spawnData[monsterName] ~= nil and strfind(spawnData[monsterName]["faction"], faction) ~= nil) then
          ShaguQuest_searchMonster(monsterName,questTitle,true);
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
          ShaguQuest_searchMonster(monsterName,questTitle);

          local i, j, monsterName = strfind(itemName, "(.*) slain");
          ShaguQuest_searchMonster(monsterName,questTitle);

          -- deDE
          local i, j, monsterName = strfind(itemName, "(.*) getötet");
          ShaguQuest_searchMonster(monsterName,questTitle);

          -- whatever
          local i, j, monsterName = strfind(itemName, "(.*)");
          ShaguQuest_searchMonster(monsterName,questTitle);
        end

        -- item data
        if (type == "item") then
          ShaguQuest_searchItem(itemName,questTitle);
          ShaguQuest_searchVendor(itemName,questTitle);
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

    -- {{{ ShaguQuest EQL Integration
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
    getglobal(prefix.."QuestLogShowMap"):SetScript("OnClick", ShaguQuest_ShowMap);
    getglobal(prefix.."QuestLogShowMap"):Show();

    -- Button: Clean
    if (getglobal(prefix.."QuestLogCleanMap") == nil) then CreateFrame("Button", prefix.."QuestLogCleanMap", getglobal(prefix.."QuestLogDetailScrollChildFrame"), "UIPanelButtonTemplate"); end
    getglobal(prefix.."QuestLogCleanMap"):SetText("Clean");
    getglobal(prefix.."QuestLogCleanMap"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsFrame", "TOPLEFT", 145, 10);
    getglobal(prefix.."QuestLogCleanMap"):SetHeight(25);
    getglobal(prefix.."QuestLogCleanMap"):SetWidth(125);
    getglobal(prefix.."QuestLogCleanMap"):RegisterForClicks("LeftButtonUp");
    getglobal(prefix.."QuestLogCleanMap"):SetScript("OnClick", ShaguQuest_CleanMap);
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
