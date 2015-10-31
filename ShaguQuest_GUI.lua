SQG_SpawnButtons = {}
SQG_ItemButtons = {}
SQG_VendorButtons = {}
SQG_FavouritesEdit = {}
-- {{{ Favourite List
if SQG_Favourites == nil then
  SQG_Favourites = {
    ["spawn"] = {
      [1] = '',
      [2] = '',
      [3] = '',
      [4] = '',
      [5] = '',
      [6] = '',
      [7] = '',
      [8] = '',
      [9] = '',
      [10] = '',
      [11] = '',
      [12] = '',
      [13] = '',
    },
    ["item"] = {
      [1] = '',
      [2] = '',
      [3] = '',
      [4] = '',
      [5] = '',
      [6] = '',
      [7] = '',
      [8] = '',
      [9] = '',
      [10] = '',
      [11] = '',
      [12] = '',
      [13] = '',
    },
    ["vendor"] = {
      [1] = '',
      [2] = '',
      [3] = '',
      [4] = '',
      [5] = '',
      [6] = '',
      [7] = '',
      [8] = '',
      [9] = '',
      [10] = '',
      [11] = '',
      [12] = '',
      [13] = '',
    },
  }
end
-- }}}

local backdrop = {
  bgFile = "Interface\\AddOns\\ShaguQuest\\img\\background", tile = true, tileSize = 16,
  edgeFile = "Interface\\AddOns\\ShaguQuest\\img\\border", edgeSize = 16,
  insets = {left = 4, right = 4, top = 4, bottom = 4},
}

SQG = CreateFrame("Frame",nil,UIParent)
SQG:RegisterEvent("PLAYER_ENTERING_WORLD");
SQG:SetScript("OnEvent", function(self, event, ...)
    SQG.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(ShaguMinimapPosition)),(80*sin(ShaguMinimapPosition))-52)
  end)

-- {{{ Main Frame
SQG:Hide()
SQG:SetFrameStrata("TOOLTIP")
SQG:SetWidth(600)
SQG:SetHeight(425)

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

-- {{{ title bar
SQG.titleBar = CreateFrame("Frame", nil, SQG)
SQG.titleBar:SetPoint("TOP", 0, -5);
SQG.titleBar:SetWidth(590);
SQG.titleBar:SetHeight(30);
SQG.titleBar.color = SQG.titleBar:CreateTexture("BACKGROUND");
SQG.titleBar.color:SetAllPoints();
SQG.titleBar.color:SetTexture(0.4, 0.4, 0.4, 0.1);
-- }}}
-- {{{ Title
SQG.text = SQG:CreateFontString("Status", "LOW", "GameFontNormal")
SQG.text:SetFontObject(GameFontWhite)
SQG.text:SetFont("Fonts\\FRIZQT__.TTF", 14)
SQG.text:SetPoint("TOPLEFT", 15, -15)
SQG.text:SetText("|cff33ffccShaguQuest|cffffffffDatabase")
-- }}}
-- {{{ bottom bar
SQG.bottomBar = CreateFrame("Frame", nil, SQG)
SQG.bottomBar:SetPoint("BOTTOM", 0, 5);
SQG.bottomBar:SetWidth(590);
SQG.bottomBar:SetHeight(40);
SQG.bottomBar.color = SQG.bottomBar:CreateTexture("BACKGROUND");
SQG.bottomBar.color:SetAllPoints();
SQG.bottomBar.color:SetTexture(0.4, 0.4, 0.4, 0.1);
-- }}}
-- {{{ Header: Spawn
SQG.titleSpawn = SQG:CreateFontString("Status", "LOW", "GameFontNormal")
SQG.titleSpawn:SetFontObject(GameFontWhite)
SQG.titleSpawn:SetFont("Fonts\\FRIZQT__.TTF", 12)
SQG.titleSpawn:SetWidth(200)
SQG.titleSpawn:SetPoint("TOPLEFT", 0, -55)
SQG.titleSpawn:SetTextColor(1,1,1,0.3)
SQG.titleSpawn:SetText("Spawn")
-- }}}
-- {{{ Header: Item
SQG.titleItem = SQG:CreateFontString("Status", "LOW", "GameFontNormal")
SQG.titleItem:SetFontObject(GameFontWhite)
SQG.titleItem:SetFont("Fonts\\FRIZQT__.TTF", 12)
SQG.titleItem:SetWidth(200)
SQG.titleItem:SetPoint("TOP", 0, -55)
SQG.titleItem:SetTextColor(1,1,1,0.3)
SQG.titleItem:SetText("Loot")
-- }}}
-- {{{ Header: Vendor
SQG.titleVendor = SQG:CreateFontString("Status", "LOW", "GameFontNormal")
SQG.titleVendor:SetFontObject(GameFontWhite)
SQG.titleVendor:SetFont("Fonts\\FRIZQT__.TTF", 12)
SQG.titleVendor:SetWidth(200)
SQG.titleVendor:SetPoint("TOPRIGHT", 0, -55)
SQG.titleVendor:SetTextColor(1,1,1,0.3)
SQG.titleVendor:SetText("Vendor")
-- }}}
-- {{{ Seperatorline: 1
SQG.vertLine1 = CreateFrame("Frame", nil, SQG)
SQG.vertLine1:SetPoint("TOP", 95, -50);
SQG.vertLine1:SetWidth(1);
SQG.vertLine1:SetHeight(320);
SQG.vertLine1.color = SQG.vertLine1:CreateTexture("BACKGROUND");
SQG.vertLine1.color:SetAllPoints();
SQG.vertLine1.color:SetTexture(0.1, 0.1, 0.1, 1);
-- }}}
-- {{{ Seperatorline: 2
SQG.vertLine2 = CreateFrame("Frame", nil, SQG)
SQG.vertLine2:SetPoint("TOP", -95, -50);
SQG.vertLine2:SetWidth(1);
SQG.vertLine2:SetHeight(320);
SQG.vertLine2.color = SQG.vertLine2:CreateTexture("BACKGROUND");
SQG.vertLine2.color:SetAllPoints();
SQG.vertLine2.color:SetTexture(0.1, 0.1, 0.1, 1);
-- }}}
-- {{{ Button: Close
SQG.closeButton = CreateFrame("Button", nil, SQG, "UIPanelCloseButton")
SQG.closeButton:SetWidth(30)
SQG.closeButton:SetHeight(30) -- width, height
SQG.closeButton:SetPoint("TOPRIGHT", -5,-5)
SQG.closeButton:SetScript("OnClick", function()
    SQG:Hide()
  end)
-- }}}
-- {{{ Text: Search
SQG.searchText = SQG:CreateFontString("Status", "LOW", "GameFontNormal")
SQG.searchText:SetFontObject(GameFontWhite)
SQG.searchText:SetFont("Fonts\\FRIZQT__.TTF", 11)
SQG.searchText:SetPoint("BOTTOMLEFT", 15, 20)
SQG.searchText:SetTextColor(0.5,0.5,0.5)
SQG.searchText:SetText("Search")
-- }}}
-- {{{ Input: Search
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
-- }}}
-- {{{ Button: Clean
SQG.cleanButton = CreateFrame("Button", nil, SQG, "UIPanelButtonTemplate")
SQG.cleanButton:SetWidth(60)
SQG.cleanButton:SetHeight(22) -- width, height
SQG.cleanButton:SetPoint("BOTTOMRIGHT", -14,14)
SQG.cleanButton:SetText("Clean")
SQG.cleanButton:SetScript("OnClick", function()
    ShaguQuest_CleanMap()
  end)

-- }}}
-- {{{ Button: Fav
SQG.favButton = CreateFrame("Button", nil, SQG, "UIPanelButtonTemplate")
SQG.favButton:SetNormalTexture("Interface\\AddOns\\ShaguQuest\\img\\fav")
SQG.favButton:SetPushedTexture(nil)

SQG.favButton:SetWidth(26)
SQG.favButton:SetHeight(26) -- width, height
SQG.favButton:SetPoint("TOPRIGHT", -30,-5)
SQG.favButton:SetText("")
SQG.favButton:SetScript("OnClick", function()
    if not SQG.cleanButton:IsShown() then
      SQG_HideFavEdit()
      SQG.searchText:Show()
      SQG.inputField:Show()
      SQG.cleanButton:Show()
      SQG_Query("")
    else
      SQG_EditFavourites()
    end
  end)
-- }}}
-- }}}
-- {{{ Minimap
SQG.minimapButton = CreateFrame('Button', nil, Minimap)
if (ShaguMinimapPosition == nil) then
  ShaguMinimapPosition = 125
end

SQG.minimapButton:SetMovable(true)
SQG.minimapButton:EnableMouse(true)
SQG.minimapButton:RegisterForDrag('LeftButton')
SQG.minimapButton:SetScript("OnDragStop", function()
    local xpos,ypos = GetCursorPosition()
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin-xpos/UIParent:GetScale()+70
    ypos = ypos/UIParent:GetScale()-ymin-70

    ShaguMinimapPosition = math.deg(math.atan2(ypos,xpos))
    SQG.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(ShaguMinimapPosition)),(80*sin(ShaguMinimapPosition))-52)
  end)

SQG.minimapButton:SetFrameStrata('HIGH')
SQG.minimapButton:SetWidth(31)
SQG.minimapButton:SetHeight(31)
SQG.minimapButton:SetFrameLevel(9)
SQG.minimapButton:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
SQG.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(ShaguMinimapPosition)),(80*sin(ShaguMinimapPosition))-52)
SQG.minimapButton:SetScript("OnClick", function()
    if ( arg1 == "LeftButton" ) then
      if (SQG:IsShown()) then
        SQG:Hide()
      else
        SQG:Show()
      end
    end
  end)

-- {{{ Highlight
SQG.minimapButton.overlay = SQG.minimapButton:CreateTexture(nil, 'OVERLAY')
SQG.minimapButton.overlay:SetWidth(53)
SQG.minimapButton.overlay:SetHeight(53)
SQG.minimapButton.overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
SQG.minimapButton.overlay:SetPoint('TOPLEFT', 0,0)
-- }}}
-- {{{ Icon
SQG.minimapButton.icon = SQG.minimapButton:CreateTexture(nil, 'BACKGROUND')
SQG.minimapButton.icon:SetWidth(20)
SQG.minimapButton.icon:SetHeight(20)
SQG.minimapButton.icon:SetTexture('Interface\\AddOns\\ShaguQuest\\symbols\\sq')
SQG.minimapButton.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
SQG.minimapButton.icon:SetPoint('CENTER',1,1)
-- }}}
-- }}}

-- {{{ HideButtons
function SQG_HideButtons()
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
end
-- }}}
-- {{{ HideFavEdit
function SQG_HideFavEdit()
  for i=1,13 do
    if (SQG_FavouritesEdit["SpawnEdit"..i]) then
      SQG_FavouritesEdit["SpawnEdit"..i]:Hide();
    end
    if (SQG_FavouritesEdit["ItemEdit"..i]) then
      SQG_FavouritesEdit["ItemEdit"..i]:Hide();
    end
    if (SQG_FavouritesEdit["VendorEdit"..i]) then
      SQG_FavouritesEdit["VendorEdit"..i]:Hide();
    end
  end
end
-- }}}
-- {{{ SearchSpawn
function SQG_SearchSpawn(search)
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
end
-- }}}
-- {{{ SearchItem
function SQG_SearchItem(search)
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
end
-- }}}a
-- {{{ SearchVenador
function SQG_SearchVendor(search)
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
-- }}}
-- {{{ ShowFavourites
function SQG_ShowFavourites()
  for i = 1,13 do
    if ( SQG_Favourites["spawn"][i] ~= '' ) then
      SQG_SpawnButtons["Button_"..i] = CreateFrame("Button","mybutton",SQG,"UIPanelButtonTemplate")
      SQG_SpawnButtons["Button_"..i]:SetPoint("TOPLEFT", 10, -i*22-55)
      SQG_SpawnButtons["Button_"..i]:SetWidth(200)
      SQG_SpawnButtons["Button_"..i]:SetHeight(20)
      SQG_SpawnButtons["Button_"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
      SQG_SpawnButtons["Button_"..i]:SetNormalTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
      SQG_SpawnButtons["Button_"..i]:SetPushedTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
      SQG_SpawnButtons["Button_"..i]:SetTextColor(0.2,1,0.9,0.7)
      SQG_SpawnButtons["Button_"..i]:SetText(SQG_Favourites["spawn"][i])
      SQG_SpawnButtons["Button_"..i]:SetScript("OnClick", function(self)
          ShaguQuest_MAP_NOTES = {};
          ShaguQuest_searchMonster(this:GetText(),nil)
          ShaguQuest_ShowMap();
        end)
    end

    if ( SQG_Favourites["item"][i] ~= '') then
      SQG_ItemButtons["Button_"..i] = CreateFrame("Button","mybutton",SQG,"UIPanelButtonTemplate")
      SQG_ItemButtons["Button_"..i]:SetPoint("TOP", 0, -i*22-55)
      SQG_ItemButtons["Button_"..i]:SetWidth(200)
      SQG_ItemButtons["Button_"..i]:SetHeight(20)
      SQG_ItemButtons["Button_"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
      SQG_ItemButtons["Button_"..i]:SetNormalTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
      SQG_ItemButtons["Button_"..i]:SetPushedTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
      SQG_ItemButtons["Button_"..i]:SetTextColor(0.2,1,0.9,0.7)
      SQG_ItemButtons["Button_"..i]:SetText(SQG_Favourites["item"][i])
      SQG_ItemButtons["Button_"..i]:SetScript("OnClick", function(self)
          ShaguQuest_MAP_NOTES = {};
          ShaguQuest_searchItem(this:GetText(),nil)
          ShaguQuest_ShowMap();
        end)
    end

    if ( SQG_Favourites["vendor"][i] ~= '' ) then
      SQG_VendorButtons["Button_"..i] = CreateFrame("Button","mybutton",SQG,"UIPanelButtonTemplate")
      SQG_VendorButtons["Button_"..i]:SetPoint("TOPRIGHT", -10, -i*22-55)
      SQG_VendorButtons["Button_"..i]:SetWidth(200)
      SQG_VendorButtons["Button_"..i]:SetHeight(20)
      SQG_VendorButtons["Button_"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
      SQG_VendorButtons["Button_"..i]:SetNormalTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
      SQG_VendorButtons["Button_"..i]:SetPushedTexture("Interface\\AddOns\\ShaguUI\\img\\bag")
      SQG_VendorButtons["Button_"..i]:SetTextColor(0.2,1,0.9,0.7)
      SQG_VendorButtons["Button_"..i]:SetText(SQG_Favourites["vendor"][i])
      SQG_VendorButtons["Button_"..i]:SetScript("OnClick", function(self)
          ShaguQuest_MAP_NOTES = {};
          ShaguQuest_searchVendor(this:GetText(),nil)
          ShaguQuest_ShowMap();
        end)
    end
  end
end
-- }}}
-- {{{ EditFavourites
function SQG_EditFavourites()
  SQG_HideFavEdit()
  SQG_HideButtons()
  SQG.cleanButton:Hide()
  SQG.searchText:Hide()
  SQG.inputField:Hide()
  SQG.cleanButton:Hide()
  for i = 1,13 do

    SQG_FavouritesEdit["SpawnEdit"..i] = CreateFrame("EditBox", "InputBoxTemplateS"..i, SQG, "InputBoxTemplate")
    SQG_FavouritesEdit["SpawnEdit"..i]:SetText(SQG_Favourites["spawn"][i])
    SQG_FavouritesEdit["SpawnEdit"..i]:SetJustifyH("CENTER")
    SQG_FavouritesEdit["SpawnEdit"..i]:SetTextColor(0.2,1,0.9,0.7)
    SQG_FavouritesEdit["SpawnEdit"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
    SQG_FavouritesEdit["SpawnEdit"..i]:SetWidth(180)
    SQG_FavouritesEdit["SpawnEdit"..i]:SetHeight(25)
    SQG_FavouritesEdit["SpawnEdit"..i]:SetPoint("TOPLEFT", 22, -i*22-53)
    SQG_FavouritesEdit["SpawnEdit"..i]:SetFontObject(GameFontNormal)
    SQG_FavouritesEdit["SpawnEdit"..i]:SetAutoFocus(false)
    SQG_FavouritesEdit["SpawnEdit"..i].editID = i
    SQG_FavouritesEdit["SpawnEdit"..i]:SetScript("OnTextChanged", function(self)
        SQG_Favourites["spawn"][this.editID] = this:GetText()
      end)

    SQG_FavouritesEdit["ItemEdit"..i] = CreateFrame("EditBox", "InputBoxTemplateI"..i, SQG, "InputBoxTemplate")
    SQG_FavouritesEdit["ItemEdit"..i]:SetText(SQG_Favourites["item"][i])
    SQG_FavouritesEdit["ItemEdit"..i]:SetJustifyH("CENTER")
    SQG_FavouritesEdit["ItemEdit"..i]:SetTextColor(0.2,1,0.9,0.7)
    SQG_FavouritesEdit["ItemEdit"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
    SQG_FavouritesEdit["ItemEdit"..i]:SetWidth(180)
    SQG_FavouritesEdit["ItemEdit"..i]:SetHeight(25)
    SQG_FavouritesEdit["ItemEdit"..i]:SetPoint("TOP", 3, -i*22-53)
    SQG_FavouritesEdit["ItemEdit"..i]:SetFontObject(GameFontNormal)
    SQG_FavouritesEdit["ItemEdit"..i]:SetAutoFocus(false)
    SQG_FavouritesEdit["ItemEdit"..i].editID = i
    SQG_FavouritesEdit["ItemEdit"..i]:SetScript("OnTextChanged", function(self)
        SQG_Favourites["item"][this.editID] = this:GetText()
      end)

    SQG_FavouritesEdit["VendorEdit"..i] = CreateFrame("EditBox", "InputBoxTemplateV"..i, SQG, "InputBoxTemplate")
    SQG_FavouritesEdit["VendorEdit"..i]:SetText(SQG_Favourites["vendor"][i])
    SQG_FavouritesEdit["VendorEdit"..i]:SetJustifyH("CENTER")
    SQG_FavouritesEdit["VendorEdit"..i]:SetTextColor(0.2,1,0.9,0.7)
    SQG_FavouritesEdit["VendorEdit"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
    SQG_FavouritesEdit["VendorEdit"..i]:SetWidth(180)
    SQG_FavouritesEdit["VendorEdit"..i]:SetHeight(25)
    SQG_FavouritesEdit["VendorEdit"..i]:SetPoint("TOPRIGHT", -17, -i*22-53)
    SQG_FavouritesEdit["VendorEdit"..i]:SetFontObject(GameFontNormal)
    SQG_FavouritesEdit["VendorEdit"..i]:SetAutoFocus(false)
    SQG_FavouritesEdit["VendorEdit"..i].editID = i
    SQG_FavouritesEdit["VendorEdit"..i]:SetScript("OnTextChanged", function(self)
        SQG_Favourites["vendor"][this.editID] = this:GetText()
      end)

  end

end

-- }}}
-- {{{ Query
function SQG_Query(search)
  SQG_HideButtons()
  if (strlen(search) >= 3) then
    SQG_SearchSpawn(search)
    SQG_SearchItem(search)
    SQG_SearchVendor(search)
  else
    SQG_ShowFavourites()
  end
end
-- }}}
