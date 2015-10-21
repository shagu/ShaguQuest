-- clear variables
ShaguQuest_QuestZoneInfo = {};
cMark = "mk1";

-- Register on event for "VARIABLES_LOADED"
ShaguQuest_VARIABLES_LOADED = CreateFrame("Frame")
ShaguQuest_VARIABLES_LOADED:RegisterEvent("VARIABLES_LOADED");
ShaguQuest_VARIABLES_LOADED:SetScript("OnEvent", function(self, event, ...)
    ShaguQuestDB = {}; ShaguQuestDBH = {};
    ShaguQuest_MAP_NOTES = {};
    ShaguQuest_Print("|cff33ff88ShaguQuest|cffffffff oooVersionooo |cffaaaaaa [oooLocaleooo]");
    Cartographer_Notes:RegisterNotesDatabase("ShaguQuest",ShaguQuestDB,ShaguQuestDBH);

    -- load symbols
    Cartographer_Notes:RegisterIcon("mk1", {
        text = "Mark 1",
        path = "Interface\\AddOns\\ShaguQuest\\symbols\\mk1",
      })
    Cartographer_Notes:RegisterIcon("mk2", {
        text = "Mark 2",
        path = "Interface\\AddOns\\ShaguQuest\\symbols\\mk2",
      })
    Cartographer_Notes:RegisterIcon("mk3", {
        text = "Mark 3",
        path = "Interface\\AddOns\\ShaguQuest\\symbols\\mk3",
      })
    Cartographer_Notes:RegisterIcon("mk4", {
        text = "Mark 4",
        path = "Interface\\AddOns\\ShaguQuest\\symbols\\mk4",
      })
    Cartographer_Notes:RegisterIcon("mk5", {
        text = "Mark 5",
        path = "Interface\\AddOns\\ShaguQuest\\symbols\\mk5",
      })
    Cartographer_Notes:RegisterIcon("mk6", {
        text = "Mark 6",
        path = "Interface\\AddOns\\ShaguQuest\\symbols\\mk6",
      })
    Cartographer_Notes:RegisterIcon("mk7", {
        text = "Mark 7",
        path = "Interface\\AddOns\\ShaguQuest\\symbols\\mk7",
      })
    Cartographer_Notes:RegisterIcon("mk8", {
        text = "Mark 8",
        path = "Interface\\AddOns\\ShaguQuest\\symbols\\mk8",
      })
    Cartographer_Notes:RegisterIcon("quest", {
        text = "Quest",
        path = "Interface\\AddOns\\ShaguQuest\\symbols\\quest",
      })
    Cartographer_Notes:RegisterIcon("vendor", {
        text = "Quest",
        path = "Interface\\AddOns\\ShaguQuest\\symbols\\vendor",
      })
  end)

-- Register on event for "PLAYER_ENTERING_WORLD"
ShaguQuest_PLAYER_ENTERING_WORLD = CreateFrame("Frame")
ShaguQuest_PLAYER_ENTERING_WORLD:RegisterEvent("PLAYER_ENTERING_WORLD");
ShaguQuest_PLAYER_ENTERING_WORLD:SetScript("OnEvent", function(self, event, ...)
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
    ShaguQuest_Print("|cff33ff88ShaguQuest|cffffffff oooVersionooo |cff00ccff[" .. UnitFactionGroup("player") .. "]|cffaaaaaa [oooLocaleooo]");
    ShaguQuest_Print("Available Commands:");
    ShaguQuest_Print("/shagu spawn <mob|gameobject>");
    ShaguQuest_Print("/shagu item <item>");
    ShaguQuest_Print("/shagu vendor <item>");
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
    ShaguQuest_ShowMap();
  end

  -- argument: vendor
  if (arg1 == "vendor") then
    local itemName = arg2;
    ShaguQuest_MAP_NOTES = {};
    ShaguQuest_searchVendor(itemName,nil)
    ShaguQuest_ShowMap();
  end

  -- argument: spawn
  if (arg1 == "spawn") then
    local monsterName = arg2;
    ShaguQuest_MAP_NOTES = {};
    ShaguQuest_searchMonster(monsterName,nil)
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
end;


function ShaguQuest_Print(string)
  DEFAULT_CHAT_FRAME:AddMessage("|cffffffff" .. string);
end


function ShaguQuest_NextCMark()
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


function ShaguQuest_CleanMap()
  if (Cartographer_Notes ~= nil) then
    Cartographer_Notes:UnregisterNotesDatabase("ShaguQuest");
    ShaguQuestDB = {}; ShaguQuestDBH = {};
    Cartographer_Notes:RegisterNotesDatabase("ShaguQuest",ShaguQuestDB,ShaguQuestDBH);
  end
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
  -- enable multiclick color-change
  -- QuestLog_UpdateQuestDetails(doNotScroll)
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


function ShaguQuest_searchMonster(monsterName,questTitle,questGiver)
  if (monsterName ~= nil and spawnData[monsterName] ~= nil and spawnData[monsterName]["coords"] ~= nil) then
    ShaguQuest_NextCMark()

    -- show chat header if not EQL    
    if(questTitle == nil) then
      ShaguQuest_Print("|cffffcc33ShaguQuest: |cffffffffSpawns of |cff33ff88"..monsterName.."|cffffffff can be found at:" );
    end

    zoneList = " "
    showmax = 0
    oldZone = ""

    -- set best map
    bestZone = zoneData[tonumber(spawnData[monsterName]["zone"])];

    for cid, cdata in pairs(spawnData[monsterName]["coords"]) do
      local f, t, coordx, coordy, zone = strfind(spawnData[monsterName]["coords"][cid], "(.*),(.*),(.*)");
      zoneName = zoneData[tonumber(zone)];

      if(questTitle ~= nil) then
        if(questGiver ~= nil) then
          table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, questTitle, monsterName, "quest", 0});
        else
          table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, questTitle, monsterName, cMark, 0});
        end
      else
        if (zoneName ~= oldZone and strfind(zoneList, zoneName) == nil) then
          zoneList = zoneList .. "[" .. zoneName .. "] "
          oldZone = zoneName
          if(questTitle == nil and showmax < 5) then
            ShaguQuest_Print(" |cffffffff (" .. coordx .. " , ".. coordy .. ")" .. " |caaaaaaaa" .. "[" .. zoneName .."]");
            showmax = showmax + 1;
          end
        end
        table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, monsterName, coordx..","..coordy, cMark, 0});
      end
    end
  end
end


function ShaguQuest_searchItem(itemName,questTitle)
  firstIsBest = false;
  ShaguQuest_NextCMark();

  if (itemName ~= nil and itemData[itemName] ~= nil) then

    if(questTitle == nil) then
      ShaguQuest_Print("|cffffcc33ShaguQuest: |cffffffffDropchances for |cff33ff88"..itemName.."|cffffffff at:" );
      showmax = 0;
    end

    for id, monsterNameDrop in pairs(itemData[itemName]) do
      local f, t, monsterName, dropRate = strfind(itemData[itemName][id], "(.*),(.*)");

      if (dropRate == nil) then dropRate = ""; else dropRate = string.format("%.2f", tonumber(dropRate)) .. "%"; end

      if(spawnData[monsterName] ~= nil) then
        zoneList = " "
        for cid, cdata in pairs(spawnData[monsterName]["coords"]) do
          local f, t, coordx, coordy, zone = strfind(spawnData[monsterName]["coords"][cid], "(.*),(.*),(.*)");
          zoneName = zoneData[tonumber(zone)];

          if(questTitle ~= nil) then
            table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, questTitle, monsterName .. "\nDrop: " ..itemName .. "\nDropchance: " .. dropRate, cMark, 0});
          else
            table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, itemName, monsterName .. "\nDrop: " .. dropRate, cMark, 0});
          end

          -- set best map
          bestZone = zoneData[tonumber(spawnData[monsterName]["zone"])];
          if(firstIsBest ~= true) then
            globalBestZone = zoneData[tonumber(spawnData[monsterName]["zone"])];
          end

          -- build zone string
          if (zoneName ~= oldZone and strfind(zoneList, zoneName) == nil) then
            zoneList = zoneList .. "[" .. zoneName .. "] "
            oldZone = zoneName
          end
        end
        if(questTitle == nil and showmax < 5) then
          ShaguQuest_Print(" |cffffffff (" .. dropRate .. ")" .. " |cffffff00" .. monsterName .. "|caaaaaaaa " .. zoneList);
        end
        if(questTitle == nil) then
          firstIsBest = true;
          showmax = showmax + 1;
        end
      end
    end
    if(questTitle == nil) then
      bestZone = globalBestZone;
    end
  end
end


function ShaguQuest_searchVendor(itemName,questTitle)
  local zoneList = ""
  showmax = 0
  if ( questTitle == nil and vendorData[itemName] ~= nil) then
    ShaguQuest_Print("|cffffcc33ShaguQuest: |cffffffffVendor for |cff33ff88"..itemName.."|cffffffff can be found at:" );
  end
  if (itemName ~= "" and vendorData[itemName] ~= nil) then
    for id, monsterNameDrop in pairs(vendorData[itemName]) do
      local f, t, monsterName, dropRate = strfind(vendorData[itemName][id], "(.*),(.*)");

      if (dropRate == "0") then dropRate = "Infinite"; else dropRate = dropRate; end

      if(spawnData[monsterName] ~= nil and strfind(spawnData[monsterName]["faction"], faction) ~= nil) then
        for cid, cdata in pairs(spawnData[monsterName]["coords"]) do
          local f, t, coordx, coordy, zone = strfind(spawnData[monsterName]["coords"][cid], "(.*),(.*),(.*)");
          zoneName = zoneData[tonumber(zone)];

          if(questTitle ~= nil) then
            table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, questTitle, monsterName .. "\nSells: " ..itemName .. "\nCount: " .. dropRate, "vendor", 0});
          else
            table.insert(ShaguQuest_MAP_NOTES,{zoneName, coordx, coordy, itemName, monsterName .. "\nSells: " .. dropRate, "vendor", 0});
          end

          -- build zone string
          if (strfind(zoneList, zoneName) == nil) then
            zoneList = zoneList .. zoneName .. ", "
            if (bestZone == nil) then
              bestZone = zoneData[tonumber(zone)];
            end
            if(questTitle == nil and showmax < 5) then
              ShaguQuest_Print(" |cffffffff (" .. coordx .. " , ".. coordy .. ")" .. " |cffffff00" .. monsterName .. "|caaaaaaaa [" .. zoneName.."]");
              showmax = showmax + 1;
            end
            oldZone = zoneName
          end
        end
      end
      if (strfind(GetZoneText(), zoneList)) then
        bestZone = GetZoneText();
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
          if (questGiver ~= "" and questGiver ~= nil and spawnData[questGiver] ~= nil and strfind(spawnData[questGiver]["faction"], faction) ~= nil) then
            for cid, cdata in pairs(spawnData[questGiver]["coords"]) do
              local f, t, coordx, coordy, zoneGiver = strfind(spawnData[questGiver]["coords"][cid], "(.*),(.*),(.*)");

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
