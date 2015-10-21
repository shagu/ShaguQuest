SDB_SpawnButtons = {}
SDB_ItemButtons = {}
SDB_VendorButtons = {}

function ShaguQuest_GUI_OnMouseDown()
  ShaguQuest_GUI:StartMoving()
end


function ShaguQuest_GUI_OnMouseUp()
  ShaguQuest_GUI:StopMovingOrSizing()
end


function ShaguQuest_GUI_Query(search)
  for i=1,13 do
    if (SDB_SpawnButtons["Button_"..i]) then
      SDB_SpawnButtons["Button_"..i]:Hide();
    end
    if (SDB_ItemButtons["Button_"..i]) then
      SDB_ItemButtons["Button_"..i]:Hide();
    end
    if (SDB_VendorButtons["Button_"..i]) then
      SDB_VendorButtons["Button_"..i]:Hide();
    end
  end

  local backdrop = {
    bgFile = "Interface\\AddOns\\ShaguUI\\img\\sbar", tile = true, tileSize = 16,
    edgeFile = "Interface\\AddOns\\ShaguUI\\img\\sbar", edgeSize = 16,
    insets = {left = 4, right = 4, top = 4, bottom = 4},
  }

  if (strlen(search) >= 3) then
    local spawnCount = 1;
    for spawn in pairs(spawnData) do
      if (strfind(strlower(spawn), strlower(search))) then
        if ( spawnCount <= 13) then
          SDB_SpawnButtons["Button_"..spawnCount] = CreateFrame("Button","mybutton",ShaguQuest_GUI,"UIPanelButtonTemplate")
          SDB_SpawnButtons["Button_"..spawnCount]:SetPoint("TOPLEFT", 10, -spawnCount*22-50)
          SDB_SpawnButtons["Button_"..spawnCount]:SetWidth(200)
          SDB_SpawnButtons["Button_"..spawnCount]:SetHeight(20)
          SDB_SpawnButtons["Button_"..spawnCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
          SDB_SpawnButtons["Button_"..spawnCount]:SetNormalTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SDB_SpawnButtons["Button_"..spawnCount]:SetPushedTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SDB_SpawnButtons["Button_"..spawnCount]:SetTextColor(1,1,1)
          SDB_SpawnButtons["Button_"..spawnCount]:SetText(spawn)
          SDB_SpawnButtons["Button_"..spawnCount]:SetScript("OnClick", function(self)
              ShaguQuest_MAP_NOTES = {};
              ShaguQuest_searchMonster(this:GetText(),nil)
              ShaguQuest_ShowMap();
            end)
          spawnCount = spawnCount + 1
        end
      end
    end

    local itemCount = 1;
    for spawn in pairs(itemData) do
      if (strfind(strlower(spawn), strlower(search))) then
        if ( itemCount <= 13) then
          SDB_ItemButtons["Button_"..itemCount] = CreateFrame("Button","mybutton",ShaguQuest_GUI,"UIPanelButtonTemplate")
          SDB_ItemButtons["Button_"..itemCount]:SetPoint("TOP", 0, -itemCount*22-50)
          SDB_ItemButtons["Button_"..itemCount]:SetWidth(200)
          SDB_ItemButtons["Button_"..itemCount]:SetHeight(20)
          SDB_ItemButtons["Button_"..itemCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
          SDB_ItemButtons["Button_"..itemCount]:SetNormalTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SDB_ItemButtons["Button_"..itemCount]:SetPushedTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SDB_ItemButtons["Button_"..itemCount]:SetTextColor(1,1,1)
          SDB_ItemButtons["Button_"..itemCount]:SetText(spawn)
          SDB_ItemButtons["Button_"..itemCount]:SetScript("OnClick", function(self)
              ShaguQuest_MAP_NOTES = {};
              ShaguQuest_searchItem(this:GetText(),nil)
              ShaguQuest_ShowMap();
            end)
          itemCount = itemCount + 1
        end
      end
    end

    local vendorCount = 1;
    for spawn in pairs(vendorData) do
      if (strfind(strlower(spawn), strlower(search))) then
        if ( vendorCount <= 13) then
          SDB_VendorButtons["Button_"..vendorCount] = CreateFrame("Button","mybutton",ShaguQuest_GUI,"UIPanelButtonTemplate")
          SDB_VendorButtons["Button_"..vendorCount]:SetPoint("TOPRIGHT", -10, -vendorCount*22-50)
          SDB_VendorButtons["Button_"..vendorCount]:SetWidth(200)
          SDB_VendorButtons["Button_"..vendorCount]:SetHeight(20)
          SDB_VendorButtons["Button_"..vendorCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
          SDB_VendorButtons["Button_"..vendorCount]:SetNormalTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SDB_VendorButtons["Button_"..vendorCount]:SetPushedTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SDB_VendorButtons["Button_"..vendorCount]:SetTextColor(1,1,1)
          SDB_VendorButtons["Button_"..vendorCount]:SetText(spawn)
          SDB_VendorButtons["Button_"..vendorCount]:SetScript("OnClick", function(self)
              ShaguQuest_MAP_NOTES = {};
              ShaguQuest_searchVendor(this:GetText(),nil)
              ShaguQuest_ShowMap();
            end)
          vendorCount = vendorCount + 1
        end
      end
    end
  end
end
