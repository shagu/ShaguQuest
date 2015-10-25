SQG_SpawnButtons = {}
SQG_ItemButtons = {}
SQG_VendorButtons = {}

-- gui
local backdrop = {
  bgFile = "Interface\\AddOns\\ShaguQuest\\img\\background", tile = true, tileSize = 16, 
  edgeFile = "Interface\\AddOns\\ShaguQuest\\img\\border", edgeSize = 16, 
  insets = {left = 4, right = 4, top = 4, bottom = 4}, 
 }

SQG = CreateFrame("Frame",nil,UIParent)
SQG:Hide()
SQG:SetFrameStrata("TOOLTIP")
SQG:SetWidth(600) -- Set these to whatever height/width is needed 
SQG:SetHeight(420) -- for your Texture

SQG:SetBackdrop(backdrop)
SQG:SetBackdropColor(0,0,0,0.9);
SQG:SetPoint("CENTER",0,0)
SQG:SetMovable(true)
SQG:EnableMouse(true)
SQG:SetScript("OnMouseDown",function()
  SQG:StartMoving()
end)
SQG:SetScript("OnMouseUp",function()
  SQG:StopMovingOrSizing()
end)

SQG.titleBar = CreateFrame("Frame", nil, SQG)
SQG.titleBar:SetPoint("TOP", 0, 5); 
SQG.titleBar:SetWidth(590); 
SQG.titleBar:SetHeight(40);
SQG.titleBar.color = SQG.titleBar:CreateTexture("BACKGROUND");
SQG.titleBar.color:SetAllPoints();
SQG.titleBar.color:SetTexture(0.4, 0.4, 0.4, 0.1); 
-- SQG.titleBar.color:SetAlpha(1);

SQG.titleSpawn = SQG:CreateFontString("Status", "LOW", "GameFontNormal")
SQG.titleSpawn:SetFontObject(GameFontWhite)
SQG.titleSpawn:SetFont("Fonts\\FRIZQT__.TTF", 12) 
SQG.titleSpawn:SetWidth(200)
SQG.titleSpawn:SetPoint("TOPLEFT", 0, -55)
SQG.titleSpawn:SetTextColor(1,1,1,0.3)
SQG.titleSpawn:SetText("Spawn") 

SQG.titleItem = SQG:CreateFontString("Status", "LOW", "GameFontNormal")
SQG.titleItem:SetFontObject(GameFontWhite)
SQG.titleItem:SetFont("Fonts\\FRIZQT__.TTF", 12) 
SQG.titleItem:SetWidth(200)
SQG.titleItem:SetPoint("TOP", 0, -55)
SQG.titleItem:SetTextColor(1,1,1,0.3)
SQG.titleItem:SetText("Loot") 

SQG.titleVendor = SQG:CreateFontString("Status", "LOW", "GameFontNormal")
SQG.titleVendor:SetFontObject(GameFontWhite)
SQG.titleVendor:SetFont("Fonts\\FRIZQT__.TTF", 12) 
SQG.titleVendor:SetWidth(200)
SQG.titleVendor:SetPoint("TOPRIGHT", 0, -55)
SQG.titleVendor:SetTextColor(1,1,1,0.3)
SQG.titleVendor:SetText("Vendor") 


SQG.vertLine1 = CreateFrame("Frame", nil, SQG)
SQG.vertLine1:SetPoint("TOP", 95, -50); 
SQG.vertLine1:SetWidth(1); 
SQG.vertLine1:SetHeight(320);
SQG.vertLine1.color = SQG.vertLine1:CreateTexture("BACKGROUND");
SQG.vertLine1.color:SetAllPoints();
SQG.vertLine1.color:SetTexture(0.1, 0.1, 0.1, 1); 

SQG.vertLine2 = CreateFrame("Frame", nil, SQG)
SQG.vertLine2:SetPoint("TOP", -95, -50); 
SQG.vertLine2:SetWidth(1); 
SQG.vertLine2:SetHeight(320);
SQG.vertLine2.color = SQG.vertLine2:CreateTexture("BACKGROUND");
SQG.vertLine2.color:SetAllPoints();
SQG.vertLine2.color:SetTexture(0.1, 0.1, 0.1, 1); 

SQG.text = SQG:CreateFontString("Status", "LOW", "GameFontNormal")
SQG.text:SetFontObject(GameFontWhite)
SQG.text:SetFont("Fonts\\FRIZQT__.TTF", 14) 
SQG.text:SetPoint("TOPLEFT", 15, -15)
SQG.text:SetText("|cff33ffccShaguQuest|cffffffffDatabase") 

SQG.closeButton = CreateFrame("Button", nil, SQG, "UIPanelCloseButton")
SQG.closeButton:SetWidth(30)
SQG.closeButton:SetHeight(30) -- width, height
SQG.closeButton:SetPoint("TOPRIGHT", -5,-5)
SQG.closeButton:SetScript("OnClick", function()
  SQG:Hide()
end)

SQG.searchText = SQG:CreateFontString("Status", "LOW", "GameFontNormal")
SQG.searchText:SetFontObject(GameFontWhite)
SQG.searchText:SetFont("Fonts\\FRIZQT__.TTF", 11) 
SQG.searchText:SetPoint("BOTTOMLEFT", 15, 20)
SQG.searchText:SetTextColor(0.5,0.5,0.5)
SQG.searchText:SetText("Search") 

SQG.inputField = CreateFrame("EditBox", "InputBoxTemplate", SQG, "InputBoxTemplate")
InputBoxTemplateLeft:SetTexture(0.4, 0.4, 0.4, 0.1); 
InputBoxTemplateMiddle:SetTexture(0.4, 0.4, 0.4, 0.1); 
InputBoxTemplateRight:SetTexture(0.4, 0.4, 0.4, 0.1);
SQG.inputField:SetWidth(450)
SQG.inputField:SetHeight(20)
SQG.inputField:SetPoint("BOTTOMLEFT", 68, 15)
SQG.inputField:SetFontObject(GameFontNormal)
SQG.inputField:SetAutoFocus(false)
SQG.inputField:SetScript("OnTextChanged", function(self)
  SQG_Query(SQG.inputField:GetText())
end)

SQG.cleanButton = CreateFrame("Button", nil, SQG, "UIPanelButtonTemplate")
SQG.cleanButton:SetWidth(60)
SQG.cleanButton:SetHeight(22) -- width, height
SQG.cleanButton:SetPoint("BOTTOMRIGHT", -14,14)
SQG.cleanButton:SetText("Clean")
SQG.cleanButton:SetScript("OnClick", function()
  ShaguQuest_CleanMap()
end)

SQG.minimapButton = CreateFrame('Button', nil, Minimap)
SQG.minimapButton.MinimapPos = 135

SQG.minimapButton:SetMovable(true)
SQG.minimapButton:EnableMouse(true)
SQG.minimapButton:RegisterForDrag('LeftButton')
SQG.minimapButton:SetScript("OnDragStop", function()
  local xpos,ypos = GetCursorPosition()
  local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

  xpos = xmin-xpos/UIParent:GetScale()+70
  ypos = ypos/UIParent:GetScale()-ymin-70

  SQG.minimapButton.MinimapPos = math.deg(math.atan2(ypos,xpos))
  SQG.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(SQG.minimapButton.MinimapPos)),(80*sin(SQG.minimapButton.MinimapPos))-52)
end)

SQG.minimapButton:SetFrameStrata('HIGH')
SQG.minimapButton:SetWidth(31)
SQG.minimapButton:SetHeight(31)
SQG.minimapButton:SetFrameLevel(9)
SQG.minimapButton:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
SQG.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(SQG.minimapButton.MinimapPos)),(80*sin(SQG.minimapButton.MinimapPos))-52)

SQG.minimapButton.overlay = SQG.minimapButton:CreateTexture(nil, 'OVERLAY')
SQG.minimapButton.overlay:SetWidth(53)
SQG.minimapButton.overlay:SetHeight(53)
SQG.minimapButton.overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
SQG.minimapButton.overlay:SetPoint('TOPLEFT', 0,0)

SQG.minimapButton.icon = SQG.minimapButton:CreateTexture(nil, 'BACKGROUND')
SQG.minimapButton.icon:SetWidth(20)
SQG.minimapButton.icon:SetHeight(20)
SQG.minimapButton.icon:SetTexture('Interface\\AddOns\\ShaguQuest\\symbols\\sq')
SQG.minimapButton.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
SQG.minimapButton.icon:SetPoint('CENTER',1,1)

SQG.minimapButton:SetScript("OnClick", function()
  if ( arg1 == "LeftButton" ) then
    if (SQG:IsShown()) then
      SQG:Hide()
    else
      SQG:Show()
    end
  end
end)

function SQG_Query(search)
  for i=1,13 do
    if (SQG_SpawnButtons["Button_"..i]) then
      SQG_SpawnButtons["Button_"..i]:Hide();
    end
    if (SQG_ItemButtons["Button_"..i]) then
      SQG_ItemButtons["Button_"..i]:Hide();
    end
    if (SQG_VendorButtons["Button_"..i]) then
      SQG_VendorButtons["Button_"..i]:Hide();
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
          SQG_SpawnButtons["Button_"..spawnCount] = CreateFrame("Button","mybutton",SQG,"UIPanelButtonTemplate")
          SQG_SpawnButtons["Button_"..spawnCount]:SetPoint("TOPLEFT", 10, -spawnCount*22-55)
          SQG_SpawnButtons["Button_"..spawnCount]:SetWidth(200)
          SQG_SpawnButtons["Button_"..spawnCount]:SetHeight(20)
          SQG_SpawnButtons["Button_"..spawnCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
          SQG_SpawnButtons["Button_"..spawnCount]:SetNormalTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SQG_SpawnButtons["Button_"..spawnCount]:SetPushedTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SQG_SpawnButtons["Button_"..spawnCount]:SetTextColor(1,1,1)
          SQG_SpawnButtons["Button_"..spawnCount]:SetText(spawn)
          SQG_SpawnButtons["Button_"..spawnCount]:SetScript("OnClick", function(self)
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
          SQG_ItemButtons["Button_"..itemCount] = CreateFrame("Button","mybutton",SQG,"UIPanelButtonTemplate")
          SQG_ItemButtons["Button_"..itemCount]:SetPoint("TOP", 0, -itemCount*22-55)
          SQG_ItemButtons["Button_"..itemCount]:SetWidth(200)
          SQG_ItemButtons["Button_"..itemCount]:SetHeight(20)
          SQG_ItemButtons["Button_"..itemCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
          SQG_ItemButtons["Button_"..itemCount]:SetNormalTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SQG_ItemButtons["Button_"..itemCount]:SetPushedTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SQG_ItemButtons["Button_"..itemCount]:SetTextColor(1,1,1)
          SQG_ItemButtons["Button_"..itemCount]:SetText(spawn)
          SQG_ItemButtons["Button_"..itemCount]:SetScript("OnClick", function(self)
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
          SQG_VendorButtons["Button_"..vendorCount] = CreateFrame("Button","mybutton",SQG,"UIPanelButtonTemplate")
          SQG_VendorButtons["Button_"..vendorCount]:SetPoint("TOPRIGHT", -10, -vendorCount*22-55)
          SQG_VendorButtons["Button_"..vendorCount]:SetWidth(200)
          SQG_VendorButtons["Button_"..vendorCount]:SetHeight(20)
          SQG_VendorButtons["Button_"..vendorCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
          SQG_VendorButtons["Button_"..vendorCount]:SetNormalTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SQG_VendorButtons["Button_"..vendorCount]:SetPushedTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
          SQG_VendorButtons["Button_"..vendorCount]:SetTextColor(1,1,1)
          SQG_VendorButtons["Button_"..vendorCount]:SetText(spawn)
          SQG_VendorButtons["Button_"..vendorCount]:SetScript("OnClick", function(self)
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
