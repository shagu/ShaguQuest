-- clear variables
ShaguDB_QuestZoneInfo = {};
cMark = "mk1";

-- Register on event for "VARIABLES_LOADED"
ShaguDB_VARIABLES_LOADED = CreateFrame("Frame")
ShaguDB_VARIABLES_LOADED:RegisterEvent("VARIABLES_LOADED");
ShaguDB_VARIABLES_LOADED:SetScript("OnEvent", function(self, event, ...)
    ShaguDBDB = {}; ShaguDBDBH = {};
    ShaguDB_MAP_NOTES = {};
    ShaguDB_Print("|cff33ff88ShaguDB|cffffffff oooVersionooo |cffaaaaaa [oooLocaleooo]");
    Cartographer_Notes:RegisterNotesDatabase("ShaguDB",ShaguDBDB,ShaguDBDBH);

    -- load symbols
    Cartographer_Notes:RegisterIcon("mk1", {
        text = "Mark 1",
        path = "Interface\\AddOns\\ShaguDB\\symbols\\mk1",
      })
    Cartographer_Notes:RegisterIcon("mk2", {
        text = "Mark 2",
        path = "Interface\\AddOns\\ShaguDB\\symbols\\mk2",
      })
    Cartographer_Notes:RegisterIcon("mk3", {
        text = "Mark 3",
        path = "Interface\\AddOns\\ShaguDB\\symbols\\mk3",
      })
    Cartographer_Notes:RegisterIcon("mk4", {
        text = "Mark 4",
        path = "Interface\\AddOns\\ShaguDB\\symbols\\mk4",
      })
    Cartographer_Notes:RegisterIcon("mk5", {
        text = "Mark 5",
        path = "Interface\\AddOns\\ShaguDB\\symbols\\mk5",
      })
    Cartographer_Notes:RegisterIcon("mk6", {
        text = "Mark 6",
        path = "Interface\\AddOns\\ShaguDB\\symbols\\mk6",
      })
    Cartographer_Notes:RegisterIcon("mk7", {
        text = "Mark 7",
        path = "Interface\\AddOns\\ShaguDB\\symbols\\mk7",
      })
    Cartographer_Notes:RegisterIcon("mk8", {
        text = "Mark 8",
        path = "Interface\\AddOns\\ShaguDB\\symbols\\mk8",
      })
    Cartographer_Notes:RegisterIcon("quest", {
        text = "Quest",
        path = "Interface\\AddOns\\ShaguDB\\symbols\\quest",
      })
    Cartographer_Notes:RegisterIcon("vendor", {
        text = "Quest",
        path = "Interface\\AddOns\\ShaguDB\\symbols\\vendor",
      })

    if ShaguMinimapEnabled == nil then
      ShaguMinimapEnabled = true
    elseif ShaguMinimapEnabled == false then
      SDBG.minimapButton:Hide()
    end
  end)

-- Register on event for "PLAYER_ENTERING_WORLD"
ShaguDB_PLAYER_ENTERING_WORLD = CreateFrame("Frame")
ShaguDB_PLAYER_ENTERING_WORLD:RegisterEvent("PLAYER_ENTERING_WORLD");
ShaguDB_PLAYER_ENTERING_WORLD:SetScript("OnEvent", function(self, event, ...)
    if (UnitFactionGroup("player") == "Horde") then
      faction = "H"
    else
      faction = "A"
    end
  end)

-- Create the /shagu SlashCommand
SLASH_SHAGU1 = "/shagu";
SlashCmdList["SHAGU"] = function(input, editbox)
  local params = {};
  if (input == "" or input == nil) then
    ShaguDB_Print("|cff33ff88ShaguDB|cffffffff oooVersionooo |cff00ccff[" .. UnitFactionGroup("player") .. "]|cffaaaaaa [oooLocaleooo]");
    ShaguDB_Print("Available Commands:");
    ShaguDB_Print("/shagu spawn <mob|gameobject> |cffaaaaaa - search objects");
    ShaguDB_Print("/shagu item <item> |cffaaaaaa - search loot");
    ShaguDB_Print("/shagu vendor <item> |cffaaaaaa - vendors for item");
    ShaguDB_Print("/shagu quests <map> |cffaaaaaa - show questgivers");
    ShaguDB_Print("/shagu quest <questname> |cffaaaaaa - show specific questgiver");
    ShaguDB_Print("/shagu clean |cffaaaaaa - clean map");
    ShaguDB_Print("/shagu minimap |cffaaaaaa - toggle minimap icon");
    ShaguDB_Print("/shagu db |cffaaaaaa - show database interface");
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
    ShaguDB_MAP_NOTES = {};
    ShaguDB_searchItem(itemName,nil)
    ShaguDB_ShowMap();
  end

  -- argument: vendor
  if (arg1 == "vendor") then
    local itemName = arg2;
    ShaguDB_MAP_NOTES = {};
    ShaguDB_searchVendor(itemName,nil)
    ShaguDB_ShowMap();
  end

  -- argument: spawn
  if (arg1 == "spawn") then
    local monsterName = arg2;
    ShaguDB_MAP_NOTES = {};
    ShaguDB_searchMonster(monsterName,nil)
    ShaguDB_ShowMap();
  end

  -- argument: quests
  if (arg1 == "quests") then
    local zoneName = arg2;
    if(zoneName == "")then
      zoneName = GetZoneText();
    end

    ShaguDB_MAP_NOTES = {};
    ShaguDB_searchQuests(zoneName)
    ShaguDB_ShowMap();
  end

  -- argument: quests
  if (arg1 == "quest") then
    local questTitle = arg2;

    ShaguDB_MAP_NOTES = {};
    if (questDB[questTitle] ~= nil) then
      for monsterName, monsterDrop in pairs(questDB[questTitle]) do
        ShaguDB_searchMonster(monsterName,questTitle,true);
      end
    end
    ShaguDB_NextCMark();
    ShaguDB_ShowMap();
  end

  -- argument: clean
  if (arg1 == "clean") then
    ShaguDB_CleanMap();
  end

  -- argument: minimap
  if (arg1 == "minimap") then
      if (SDBG.minimapButton:IsShown()) then
        SDBG.minimapButton:Hide()
        ShaguMinimapEnabled = false
      else
        SDBG.minimapButton:Show()
        ShaguMinimapEnabled = true
      end
  end

  -- argument: db
  if (arg1 == "db") then
      if (SDBG:IsShown()) then
        SDBG:Hide()
      else
        SDBG:Show()
      end
  end
end;


function ShaguDB_Print(string)
  DEFAULT_CHAT_FRAME:AddMessage("|cffffffff" .. string);
end


function ShaguDB_NextCMark()
  if (cMark == "mk1") then
    cMark = "mk2";
  elseif (cMark == "mk2") then
    cMark = "mk3";
  elseif (cMark == "mk3") then
    cMark = "mk4";
  elseif (cMark == "mk4") then
    cMark = "mk5";
  elseif (cMark == "mk5") then
    cMark = "mk6";
  elseif (cMark == "mk6") then
    cMark = "mk7";
  elseif (cMark == "mk7") then
    cMark = "mk8";
  elseif (cMark == "mk8") then
    cMark = "mk1";
  end
end


function ShaguDB_CleanMap()
  if (Cartographer_Notes ~= nil) then
    Cartographer_Notes:UnregisterNotesDatabase("ShaguDB");
    ShaguDBDB = {}; ShaguDBDBH = {};
    Cartographer_Notes:RegisterNotesDatabase("ShaguDB",ShaguDBDB,ShaguDBDBH);
  end
end


function ShaguDB_ShowMap()
  local ShowMapZone, ShowMapTitle, ShowMapID = ShaguDB_PlotNotesOnMap();

  if (Cartographer) then
    if (ShowMapZone ~= nil) then
      WorldMapFrame:Show();
      if (bestZone ~= nil) then
        cKey, zKey = ShaguDB_GetMapIDFromZone(bestZone)
        if (cKey == -1) then
          showM = bestZone

          -- deDE fix
          if (GetLocale() == "deDE") then
            local BZ = AceLibrary("Babble-Zone-2.2")
            showM = BZ:GetReverseTranslation(bestZone)
          end

          Cartographer_InstanceMaps:ShowInstance(showM)
          UIErrorsFrame:AddMessage("|cffff5555Results might be wrong. Instance Notes are still experimental.|cffffffff")
        else
          SetMapZoom(cKey, zKey);
        end
      end
    end
  end
  -- enable multiclick color-change
  -- QuestLog_UpdateQuestDetails(doNotScroll)
end


function ShaguDB_PlotNotesOnMap()
  local zone = nil;
  local title = nil;
  local noteID = nil;

  for nKey, nData in ipairs(ShaguDB_MAP_NOTES) do
    Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, nData[6], "ShaguDB", 'title', nData[4], 'info', nData[5]);
    if (nData[1] ~= nil) then
      zone = nData[1];
      title = nData[4];
    end
  end

  return zone, title, noteID;
end


function ShaguDB_GetMapIDFromZone(zoneText)
  for cKey, cName in ipairs{GetMapContinents()} do
    for zKey,zName in ipairs{GetMapZones(cKey)} do
      if(zoneText == zName) then
        return cKey, zKey;
      end
    end
  end

  return -1, zoneText;
end


function ShaguDB_searchMonster(monsterName,questTitle,questGiver)
  if (monsterName ~= nil and spawnDB[monsterName] ~= nil and spawnDB[monsterName]["coords"] ~= nil) then
    ShaguDB_NextCMark()

    -- show chat header if not EQL
    if(questTitle == nil) then
      ShaguDB_Print("|cffffcc33ShaguDB: |cffffffffSpawns of |cff33ff88"..monsterName.."|cffffffff can be found at:" );
    end

    zoneList = " "
    showmax = 0
    oldZone = ""

    -- set best map
    bestZone = zoneDB[tonumber(spawnDB[monsterName]["zone"])];

    for cid, cdata in pairs(spawnDB[monsterName]["coords"]) do
      local f, t, coordx, coordy, zone = strfind(spawnDB[monsterName]["coords"][cid], "(.*),(.*),(.*)");
      zoneName = zoneDB[tonumber(zone)];

      local level = spawnDB[monsterName]["level"]
      if level ~= 0 then 
        level = "\nLevel: " .. level 
      else
        level = ""
      end

      if(questTitle ~= nil) then
        if(questGiver ~= nil) then
          table.insert(ShaguDB_MAP_NOTES,{zoneName, coordx, coordy, "Quest: "..questTitle, monsterName .. level, "quest", 0});
        else
          table.insert(ShaguDB_MAP_NOTES,{zoneName, coordx, coordy, "Quest: "..questTitle, "Kill: "..monsterName .. level, cMark, 0});
        end
      else
        if (zoneName ~= oldZone and strfind(zoneList, zoneName) == nil) then
          zoneList = zoneList .. "[" .. zoneName .. "] "
          oldZone = zoneName
          if(questTitle == nil and showmax < 5) then
            ShaguDB_Print(" |cffffffff (" .. coordx .. " , ".. coordy .. ")" .. " |caaaaaaaa" .. "[" .. zoneName .."]");
            showmax = showmax + 1;
          end
        end
        table.insert(ShaguDB_MAP_NOTES,{zoneName, coordx, coordy, monsterName, "Coords: " .. coordx..","..coordy .. level, cMark, 0});
      end
    end
  end
end


function ShaguDB_searchItem(itemName,questTitle,autotrack)
  local runonce = false;
  firstIsBest = false;
  local showmax = 0;
  ShaguDB_NextCMark();

  if (itemName ~= nil and itemDB[itemName] ~= nil) then

    for id, monsterNameDrop in pairs(itemDB[itemName]) do
      local f, t, monsterName, dropRate = strfind(itemDB[itemName][id], "(.*),(.*)");

      if (dropRate == nil) then dropRate = ""; else dropRate = string.format("%.2f", tonumber(dropRate)) .. "%"; end

      if(spawnDB[monsterName] ~= nil) then
        zoneList = " "
        if(questTitle == nil and runonce == false) then
          ShaguDB_Print("|cffffcc33ShaguDB: |cffffffffDropchances for |cff33ff88"..itemName.."|cffffffff at:" );
          showmax = 0;
          runonce = true
        end
        if spawnDB[monsterName]["coords"] then
          for cid, cdata in pairs(spawnDB[monsterName]["coords"]) do
            hasResult = true;
            local f, t, coordx, coordy, zone = strfind(spawnDB[monsterName]["coords"][cid], "(.*),(.*),(.*)");
            zoneName = zoneDB[tonumber(zone)];
            local level = spawnDB[monsterName]["level"]
            if level ~= 0 then 
              level = "\nLevel: " .. level 
            else
              level = ""
            end

            if questTitle ~= nil and autotrack and showmax < 5 then
              table.insert(ShaguDB_MAP_NOTES,{zoneName, coordx, coordy, "Quest: "..questTitle, monsterName .. level .. "\nLoot: " ..itemName .. "\nDropchance: " .. dropRate, cMark, 0});
            elseif questTitle ~= nil and not autotrack then
              table.insert(ShaguDB_MAP_NOTES,{zoneName, coordx, coordy, "Quest: "..questTitle, monsterName .. level .. "\nLoot: " ..itemName .. "\nDropchance: " .. dropRate, cMark, 0});
            end

            if questTitle == nil then
              table.insert(ShaguDB_MAP_NOTES,{zoneName, coordx, coordy, itemName, monsterName .. level .. "\nDrop: " .. dropRate, cMark, 0});
            end

            -- set best map
            bestZone = zoneDB[tonumber(spawnDB[monsterName]["zone"])];
            if(firstIsBest ~= true) then
              globalBestZone = zoneDB[tonumber(spawnDB[monsterName]["zone"])];
            end

            -- build zone string
            if (zoneName ~= oldZone and strfind(zoneList, zoneName) == nil) then
              zoneList = zoneList .. "[" .. zoneName .. "] "
              oldZone = zoneName
            end
          end
        end
        if(questTitle == nil and showmax < 5) then
          if dropRate == "0.00%" then dropRate = "N/A" end
          if zoneList == " " then zoneList = "[unknown]" end
          ShaguDB_Print(" |cffffffff (" .. dropRate .. ")" .. " |cffffff00" .. monsterName .. "|caaaaaaaa " .. zoneList);
        end
        if(questTitle == nil) then
          firstIsBest = true;
        end
        showmax = showmax + 1;
      end
    end
    if(questTitle == nil) then
      bestZone = globalBestZone;
    end
  end
end


function ShaguDB_searchVendor(itemName,questTitle)
  local zoneList = ""
  showmax = 0
  if ( questTitle == nil and vendorDB[itemName] ~= nil) then
    ShaguDB_Print("|cffffcc33ShaguDB: |cffffffffVendor for |cff33ff88"..itemName.."|cffffffff can be found at:" );
  end
  if (itemName ~= "" and vendorDB[itemName] ~= nil) then
    bestZone = ""
    for id, monsterNameDrop in pairs(vendorDB[itemName]) do
      local f, t, monsterName, dropRate = strfind(vendorDB[itemName][id], "(.*),(.*)");

      if (dropRate == "0") then dropRate = "Infinite"; else dropRate = dropRate; end

      if(spawnDB[monsterName] ~= nil and strfind(spawnDB[monsterName]["faction"], faction) ~= nil) then
        if spawnDB[monsterName]["coords"] then
          for cid, cdata in pairs(spawnDB[monsterName]["coords"]) do
            local f, t, coordx, coordy, zone = strfind(spawnDB[monsterName]["coords"][cid], "(.*),(.*),(.*)");
            zoneName = zoneDB[tonumber(zone)];

            if(questTitle ~= nil) then
              table.insert(ShaguDB_MAP_NOTES,{zoneName, coordx, coordy, "Quest: "..questTitle, monsterName .. "\nBuy: " ..itemName .. "\nCount: " .. dropRate, "vendor", 0});
            else
              table.insert(ShaguDB_MAP_NOTES,{zoneName, coordx, coordy, itemName, monsterName .. "\nSells: " .. dropRate, "vendor", 0});
            end

            -- build zone string
            if (strfind(zoneList, zoneName) == nil) then
              zoneList = zoneList .. zoneName .. ", "
              if(questTitle == nil and showmax < 5) then
                ShaguDB_Print(" |cffffffff (" .. coordx .. " , ".. coordy .. ")" .. " |cffffff00" .. monsterName .. "|caaaaaaaa [" .. zoneName.."]");
                showmax = showmax + 1;
              end
              oldZone = zoneName
            end

            if (strfind(zoneList,GetZoneText()) ~= nil) then
              bestZone = GetZoneText();
            else
              bestZone = zoneName
            end
          end
        end
      end
      if(questTitle == nil and showmax < 1) then
        ShaguDB_Print(" |cffffffff (??,??)" .. " |cffffff00" .. monsterName .. "|caaaaaaaa [unknown]");
      end
    end
  end
end


function ShaguDB_searchQuests(zoneName)
  if (zoneName ~= "" and zoneName ~= nil) then
    bestZone = zoneName;
    -- detect zone id by name
    for zoneDB, zoneDBName in pairs(zoneDB) do
      if(zoneDBName == zoneName) then
        zone = zoneDB
      end
    end

    if(zone ~= nil) then
      for questTitle, questGiver in pairs(questDB) do
        for questGiver in pairs(questGiver) do
          if (questGiver ~= "" and questGiver ~= nil and spawnDB[questGiver] ~= nil and strfind(spawnDB[questGiver]["faction"], faction) ~= nil) and spawnDB[questGiver]["coords"] then
            for cid, cdata in pairs(spawnDB[questGiver]["coords"]) do
              local f, t, coordx, coordy, zoneGiver = strfind(spawnDB[questGiver]["coords"][cid], "(.*),(.*),(.*)");

              if(tonumber(zoneGiver) == tonumber(zone)) then
                table.insert(ShaguDB_MAP_NOTES,{zoneName, coordx, coordy, questTitle, questGiver, "quest", 0});
              end
            end
          end
        end
      end
    end
  end
end

local HookSetItemRef = SetItemRef
SetItemRef = function (link, text, button)
  isQuest, _, questID = string.find(link, "quest:(%d+):.*");
  isQuest2, _, _ = string.find(link, "quest2:.*");

  _, _, questLevel = string.find(link, "quest:%d+:(%d+)");
  local playerHasQuest = false

  if isQuest then
    -- A usual Quest Link introduced in 2.0x
    ShowUIPanel(ItemRefTooltip);
    ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");

    hasTitle, _, questTitle = string.find(text, ".*|h%[(.*)%]|h.*");
    if hasTitle then
      ItemRefTooltip:AddLine(questTitle, 1,1,0)
    end

    for i=1, GetNumQuestLogEntries() do
      local questlogTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(i);
      if questTitle == questlogTitle then
        playerHasQuest = true
        SelectQuestLogEntry(i)
        local _, text = GetQuestLogQuestText()
        ItemRefTooltip:AddLine(text,1,1,1,true)

        for j=1, GetNumQuestLeaderBoards() do
          if j == 1 and GetNumQuestLeaderBoards() > 0 then ItemRefTooltip:AddLine("|cffffffff ") end
          local desc, type, done = GetQuestLogLeaderBoard(j)
          if done then ItemRefTooltip:AddLine("|cffaaffaa"..desc.."|r")
          else ItemRefTooltip:AddLine("|cffffffff"..desc.."|r") end
        end
      end
    end

    if playerHasQuest == false then
      ItemRefTooltip:AddLine("You don't have this quest.", 1, .8, .8)
    end

    if questLevel ~= 0 and questLevel ~= "0" then
      local color = GetDifficultyColor(questLevel)
      ItemRefTooltip:AddLine("Quest Level " .. questLevel, color.r, color.g, color.b)
    end

    ItemRefTooltip:Show()

  elseif isQuest2 then
    -- QuestLink Compatibility
      ShowUIPanel(ItemRefTooltip);
      ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
      hasTitle, _, questTitle = string.find(text, ".*|h%[(.*)%]|h.*");
      if hasTitle then
        ItemRefTooltip:AddLine(questTitle, 1,1,0)
      end
      ItemRefTooltip:AddLine("(Unknown QuestLink).", 1, .3, .3)

      for i=1, GetNumQuestLogEntries() do
        local questlogTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(i);
        if questTitle == questlogTitle then
          playerHasQuest = true
          SelectQuestLogEntry(i)
          local _, text = GetQuestLogQuestText()
          ItemRefTooltip:AddLine(text,1,1,1,true)

          for j=1, GetNumQuestLeaderBoards() do
            if j == 1 and GetNumQuestLeaderBoards() > 0 then ItemRefTooltip:AddLine("|cffffffff ") end
            local desc, type, done = GetQuestLogLeaderBoard(j)
            if done then ItemRefTooltip:AddLine("|cffaaffaa"..desc.."|r")
            else ItemRefTooltip:AddLine("|cffffffff"..desc.."|r") end
          end
        end
      end

      if playerHasQuest == false then
        ItemRefTooltip:AddLine("You don't have this quest.", 1, .8, .8)
      end
      ItemRefTooltip:Show()
  else
    HookSetItemRef(link, text, button)
  end
end
