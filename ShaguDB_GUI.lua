SDBG_SpawnButtons = {}
SDBG_ItemButtons = {}
SDBG_VendorButtons = {}
SDBG_FavouritesEdit = {}
-- {{{ Favourite List
if SDBG_Favourites == nil then
  SDBG_Favourites = {
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
  bgFile = "Interface\\AddOns\\ShaguDB\\img\\background", tile = true, tileSize = 16,
  edgeFile = "Interface\\AddOns\\ShaguDB\\img\\border", edgeSize = 16,
  insets = {left = 4, right = 4, top = 4, bottom = 4},
}

SDBG = CreateFrame("Frame",nil,UIParent)
SDBG:RegisterEvent("PLAYER_ENTERING_WORLD");
SDBG:SetScript("OnEvent", function(self, event, ...)
    SDBG.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(ShaguMinimapPosition)),(80*sin(ShaguMinimapPosition))-52)
  end)

-- {{{ Main Frame
SDBG:Hide()
SDBG:SetFrameStrata("TOOLTIP")
SDBG:SetWidth(600)
SDBG:SetHeight(425)

SDBG:SetBackdrop(backdrop)
SDBG:SetBackdropColor(0,0,0,0.9);
SDBG:SetPoint("CENTER",0,0)
SDBG:SetMovable(true)
SDBG:EnableMouse(true)
SDBG:SetScript("OnMouseDown",function()
    SDBG:StartMoving()
  end)
SDBG:SetScript("OnMouseUp",function()
    SDBG:StopMovingOrSizing()
  end)

-- {{{ title bar
SDBG.titleBar = CreateFrame("Frame", nil, SDBG)
SDBG.titleBar:SetPoint("TOP", 0, -5);
SDBG.titleBar:SetWidth(590);
SDBG.titleBar:SetHeight(30);
SDBG.titleBar.color = SDBG.titleBar:CreateTexture("BACKGROUND");
SDBG.titleBar.color:SetAllPoints();
SDBG.titleBar.color:SetTexture(0.4, 0.4, 0.4, 0.1);
-- }}}
-- {{{ Title
SDBG.text = SDBG:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.text:SetFontObject(GameFontWhite)
SDBG.text:SetFont("Fonts\\FRIZQT__.TTF", 14)
SDBG.text:SetPoint("TOPLEFT", 15, -15)
SDBG.text:SetText("|cff33ffccShagu|cffffffffDatabase |cff555555oooVersionooo")
-- }}}
-- {{{ bottom bar
SDBG.bottomBar = CreateFrame("Frame", nil, SDBG)
SDBG.bottomBar:SetPoint("BOTTOM", 0, 5);
SDBG.bottomBar:SetWidth(590);
SDBG.bottomBar:SetHeight(40);
SDBG.bottomBar.color = SDBG.bottomBar:CreateTexture("BACKGROUND");
SDBG.bottomBar.color:SetAllPoints();
SDBG.bottomBar.color:SetTexture(0.4, 0.4, 0.4, 0.1);
-- }}}
-- {{{ Header: Spawn
SDBG.titleSpawn = SDBG:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.titleSpawn:SetFontObject(GameFontWhite)
SDBG.titleSpawn:SetFont("Fonts\\FRIZQT__.TTF", 12)
SDBG.titleSpawn:SetWidth(200)
SDBG.titleSpawn:SetPoint("TOPLEFT", 0, -55)
SDBG.titleSpawn:SetTextColor(1,1,1,0.3)
SDBG.titleSpawn:SetText("Spawn")
-- }}}
-- {{{ Header: Item
SDBG.titleItem = SDBG:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.titleItem:SetFontObject(GameFontWhite)
SDBG.titleItem:SetFont("Fonts\\FRIZQT__.TTF", 12)
SDBG.titleItem:SetWidth(200)
SDBG.titleItem:SetPoint("TOP", 0, -55)
SDBG.titleItem:SetTextColor(1,1,1,0.3)
SDBG.titleItem:SetText("Loot")
-- }}}
-- {{{ Header: Vendor
SDBG.titleVendor = SDBG:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.titleVendor:SetFontObject(GameFontWhite)
SDBG.titleVendor:SetFont("Fonts\\FRIZQT__.TTF", 12)
SDBG.titleVendor:SetWidth(200)
SDBG.titleVendor:SetPoint("TOPRIGHT", 0, -55)
SDBG.titleVendor:SetTextColor(1,1,1,0.3)
SDBG.titleVendor:SetText("Vendor")
-- }}}
-- {{{ Seperatorline: 1
SDBG.vertLine1 = CreateFrame("Frame", nil, SDBG)
SDBG.vertLine1:SetPoint("TOP", 95, -50);
SDBG.vertLine1:SetWidth(1);
SDBG.vertLine1:SetHeight(320);
SDBG.vertLine1.color = SDBG.vertLine1:CreateTexture("BACKGROUND");
SDBG.vertLine1.color:SetAllPoints();
SDBG.vertLine1.color:SetTexture(0.1, 0.1, 0.1, 1);
-- }}}
-- {{{ Seperatorline: 2
SDBG.vertLine2 = CreateFrame("Frame", nil, SDBG)
SDBG.vertLine2:SetPoint("TOP", -95, -50);
SDBG.vertLine2:SetWidth(1);
SDBG.vertLine2:SetHeight(320);
SDBG.vertLine2.color = SDBG.vertLine2:CreateTexture("BACKGROUND");
SDBG.vertLine2.color:SetAllPoints();
SDBG.vertLine2.color:SetTexture(0.1, 0.1, 0.1, 1);
-- }}}
-- {{{ Button: Close
SDBG.closeButton = CreateFrame("Button", nil, SDBG, "UIPanelCloseButton")
SDBG.closeButton:SetWidth(30)
SDBG.closeButton:SetHeight(30) -- width, height
SDBG.closeButton:SetPoint("TOPRIGHT", -5,-5)
SDBG.closeButton:SetScript("OnClick", function()
    SDBG:Hide()
  end)
-- }}}
-- {{{ Text: Search
SDBG.searchText = SDBG:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.searchText:SetFontObject(GameFontWhite)
SDBG.searchText:SetFont("Fonts\\FRIZQT__.TTF", 11)
SDBG.searchText:SetPoint("BOTTOMLEFT", 15, 20)
SDBG.searchText:SetTextColor(0.5,0.5,0.5)
SDBG.searchText:SetText("Search")
-- }}}
-- {{{ Text: caseSensitive
SDBG.caseSensitive = SDBG:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.caseSensitive:SetFontObject(GameFontWhite)
SDBG.caseSensitive:SetFont("Fonts\\FRIZQT__.TTF", 11)
SDBG.caseSensitive:SetPoint("BOTTOM", 0, 20)
SDBG.caseSensitive:SetTextColor(0.5,0.5,0.5)
SDBG.caseSensitive:SetText("Note: Favourite editboxes are case sensitive and saved automatically.")
SDBG.caseSensitive:Hide()
-- }}}

-- {{{ Input: Search
SDBG.inputField = CreateFrame("EditBox", "InputBoxTemplate", SDBG, "InputBoxTemplate")
InputBoxTemplateLeft:SetTexture(0.4, 0.4, 0.4, 0.1);
InputBoxTemplateMiddle:SetTexture(0.4, 0.4, 0.4, 0.1);
InputBoxTemplateRight:SetTexture(0.4, 0.4, 0.4, 0.1);
SDBG.inputField:SetWidth(450)
SDBG.inputField:SetHeight(20)
SDBG.inputField:SetPoint("BOTTOMLEFT", 68, 15)
SDBG.inputField:SetFontObject(GameFontNormal)
SDBG.inputField:SetAutoFocus(false)
SDBG.inputField:SetScript("OnTextChanged", function(self)
    SDBG_Query(SDBG.inputField:GetText())
  end)
-- }}}
-- {{{ Button: Clean
SDBG.cleanButton = CreateFrame("Button", nil, SDBG, "UIPanelButtonTemplate")
SDBG.cleanButton:SetWidth(60)
SDBG.cleanButton:SetHeight(22) -- width, height
SDBG.cleanButton:SetPoint("BOTTOMRIGHT", -14,14)
SDBG.cleanButton:SetText("Clean")
SDBG.cleanButton:SetScript("OnClick", function()
    ShaguDB_CleanMap()
  end)
-- }}}
-- {{{ Button: Fav
SDBG.favButton = CreateFrame("Button", nil, SDBG, "UIPanelButtonTemplate")
SDBG.favButton:SetNormalTexture("Interface\\AddOns\\ShaguDB\\img\\fav")
SDBG.favButton:SetPushedTexture(nil)

SDBG.favButton:SetWidth(26)
SDBG.favButton:SetHeight(26) -- width, height
SDBG.favButton:SetPoint("TOPRIGHT", -30,-5)
SDBG.favButton:SetText("")
SDBG.favButton:SetScript("OnClick", function()
    if not SDBG.cleanButton:IsShown() then
      SDBG_HideFavEdit()
      SDBG.searchText:Show()
      SDBG.inputField:Show()
      SDBG.cleanButton:Show()
      SDBG.caseSensitive:Hide()
      SDBG_Query("")
    else
      SDBG_EditFavourites()
    end
  end)
-- }}}
-- }}}
-- {{{ Minimap
SDBG.minimapButton = CreateFrame('Button', "ShaguDB_Minimap", Minimap)
if (ShaguMinimapPosition == nil) then
  ShaguMinimapPosition = 125
end

SDBG.minimapButton:SetMovable(true)
SDBG.minimapButton:EnableMouse(true)
SDBG.minimapButton:RegisterForDrag('LeftButton')
SDBG.minimapButton:SetScript("OnDragStop", function()
    local xpos,ypos = GetCursorPosition()
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin-xpos/UIParent:GetScale()+70
    ypos = ypos/UIParent:GetScale()-ymin-70

    ShaguMinimapPosition = math.deg(math.atan2(ypos,xpos))
    SDBG.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(ShaguMinimapPosition)),(80*sin(ShaguMinimapPosition))-52)
  end)

SDBG.minimapButton:SetFrameStrata('LOW')
SDBG.minimapButton:SetWidth(31)
SDBG.minimapButton:SetHeight(31)
SDBG.minimapButton:SetFrameLevel(9)
SDBG.minimapButton:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
SDBG.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(ShaguMinimapPosition)),(80*sin(ShaguMinimapPosition))-52)
SDBG.minimapButton:SetScript("OnClick", function()
    if ( arg1 == "LeftButton" ) then
      if (SDBG:IsShown()) then
        SDBG:Hide()
      else
        SDBG:Show()
      end
    end
  end)

-- {{{ Highlight
SDBG.minimapButton.overlay = SDBG.minimapButton:CreateTexture(nil, 'OVERLAY')
SDBG.minimapButton.overlay:SetWidth(53)
SDBG.minimapButton.overlay:SetHeight(53)
SDBG.minimapButton.overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
SDBG.minimapButton.overlay:SetPoint('TOPLEFT', 0,0)
-- }}}
-- {{{ Icon
SDBG.minimapButton.icon = SDBG.minimapButton:CreateTexture(nil, 'BACKGROUND')
SDBG.minimapButton.icon:SetWidth(20)
SDBG.minimapButton.icon:SetHeight(20)
SDBG.minimapButton.icon:SetTexture('Interface\\AddOns\\ShaguDB\\symbols\\sq')
SDBG.minimapButton.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
SDBG.minimapButton.icon:SetPoint('CENTER',1,1)
-- }}}
-- }}}

-- {{{ HideButtons
function SDBG_HideButtons()
  for i=1,13 do
    if (SDBG_SpawnButtons["Button_"..i]) then
      SDBG_SpawnButtons["Button_"..i]:Hide();
    end
    if (SDBG_ItemButtons["Button_"..i]) then
      SDBG_ItemButtons["Button_"..i]:Hide();
    end
    if (SDBG_VendorButtons["Button_"..i]) then
      SDBG_VendorButtons["Button_"..i]:Hide();
    end
  end
end
-- }}}
-- {{{ HideFavEdit
function SDBG_HideFavEdit()
  for i=1,13 do
    if (SDBG_FavouritesEdit["SpawnEdit"..i]) then
      SDBG_FavouritesEdit["SpawnEdit"..i]:Hide();
    end
    if (SDBG_FavouritesEdit["ItemEdit"..i]) then
      SDBG_FavouritesEdit["ItemEdit"..i]:Hide();
    end
    if (SDBG_FavouritesEdit["VendorEdit"..i]) then
      SDBG_FavouritesEdit["VendorEdit"..i]:Hide();
    end
  end
end
-- }}}
-- {{{ SearchSpawn
function SDBG_SearchSpawn(search)
  local spawnCount = 1;
  for spawn in pairs(spawnDB) do
    if (strfind(strlower(spawn), strlower(search))) then
      if ( spawnCount <= 13) then
        SDBG_SpawnButtons["Button_"..spawnCount] = CreateFrame("Button","mybutton",SDBG,"UIPanelButtonTemplate")
        SDBG_SpawnButtons["Button_"..spawnCount]:SetPoint("TOPLEFT", 10, -spawnCount*22-55)
        SDBG_SpawnButtons["Button_"..spawnCount]:SetWidth(200)
        SDBG_SpawnButtons["Button_"..spawnCount]:SetHeight(20)
        SDBG_SpawnButtons["Button_"..spawnCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
        SDBG_SpawnButtons["Button_"..spawnCount]:SetNormalTexture(nil)
        SDBG_SpawnButtons["Button_"..spawnCount]:SetPushedTexture(nil)
        SDBG_SpawnButtons["Button_"..spawnCount]:SetTextColor(1,1,1)
        SDBG_SpawnButtons["Button_"..spawnCount]:SetText(spawn)
        SDBG_SpawnButtons["Button_"..spawnCount]:SetScript("OnClick", function(self)
            ShaguDB_MAP_NOTES = {};
            ShaguDB_searchMonster(this:GetText(),nil)
            ShaguDB_ShowMap();
          end)
        spawnCount = spawnCount + 1
      end
    end
  end
end
-- }}}
-- {{{ SearchItem
function SDBG_SearchItem(search)
  local itemCount = 1;
  for spawn in pairs(itemDB) do
    if (strfind(strlower(spawn), strlower(search))) then
      if ( itemCount <= 13) then
        SDBG_ItemButtons["Button_"..itemCount] = CreateFrame("Button","mybutton",SDBG,"UIPanelButtonTemplate")
        SDBG_ItemButtons["Button_"..itemCount]:SetPoint("TOP", 0, -itemCount*22-55)
        SDBG_ItemButtons["Button_"..itemCount]:SetWidth(200)
        SDBG_ItemButtons["Button_"..itemCount]:SetHeight(20)
        SDBG_ItemButtons["Button_"..itemCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
        SDBG_ItemButtons["Button_"..itemCount]:SetNormalTexture(nil)
        SDBG_ItemButtons["Button_"..itemCount]:SetPushedTexture(nil)
        SDBG_ItemButtons["Button_"..itemCount]:SetTextColor(1,1,1)
        SDBG_ItemButtons["Button_"..itemCount]:SetText(spawn)
        SDBG_ItemButtons["Button_"..itemCount]:SetScript("OnClick", function(self)
            ShaguDB_MAP_NOTES = {};
            ShaguDB_searchItem(this:GetText(),nil)
            ShaguDB_ShowMap();
          end)
        itemCount = itemCount + 1
      end
    end
  end
end
-- }}}a
-- {{{ SearchVenador
function SDBG_SearchVendor(search)
  local vendorCount = 1;
  for spawn in pairs(vendorDB) do
    if (strfind(strlower(spawn), strlower(search))) then
      if ( vendorCount <= 13) then
        SDBG_VendorButtons["Button_"..vendorCount] = CreateFrame("Button","mybutton",SDBG,"UIPanelButtonTemplate")
        SDBG_VendorButtons["Button_"..vendorCount]:SetPoint("TOPRIGHT", -10, -vendorCount*22-55)
        SDBG_VendorButtons["Button_"..vendorCount]:SetWidth(200)
        SDBG_VendorButtons["Button_"..vendorCount]:SetHeight(20)
        SDBG_VendorButtons["Button_"..vendorCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
        SDBG_VendorButtons["Button_"..vendorCount]:SetNormalTexture(nil)
        SDBG_VendorButtons["Button_"..vendorCount]:SetPushedTexture(nil)
        SDBG_VendorButtons["Button_"..vendorCount]:SetTextColor(1,1,1)
        SDBG_VendorButtons["Button_"..vendorCount]:SetText(spawn)
        SDBG_VendorButtons["Button_"..vendorCount]:SetScript("OnClick", function(self)
            ShaguDB_MAP_NOTES = {};
            ShaguDB_searchVendor(this:GetText(),nil)
            ShaguDB_ShowMap();
          end)
        vendorCount = vendorCount + 1
      end
    end
  end
end
-- }}}
-- {{{ ShowFavourites
function SDBG_ShowFavourites()
  for i = 1,13 do
    if ( SDBG_Favourites["spawn"][i] ~= '' ) then
      SDBG_SpawnButtons["Button_"..i] = CreateFrame("Button","mybutton",SDBG,"UIPanelButtonTemplate")
      SDBG_SpawnButtons["Button_"..i]:SetPoint("TOPLEFT", 10, -i*22-55)
      SDBG_SpawnButtons["Button_"..i]:SetWidth(200)
      SDBG_SpawnButtons["Button_"..i]:SetHeight(20)
      SDBG_SpawnButtons["Button_"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
      SDBG_SpawnButtons["Button_"..i]:SetNormalTexture(nil)
      SDBG_SpawnButtons["Button_"..i]:SetPushedTexture(nil)
      SDBG_SpawnButtons["Button_"..i]:SetTextColor(0.2,1,0.9,0.7)
      SDBG_SpawnButtons["Button_"..i]:SetText(SDBG_Favourites["spawn"][i])
      SDBG_SpawnButtons["Button_"..i]:SetScript("OnClick", function(self)
          ShaguDB_MAP_NOTES = {};
          ShaguDB_searchMonster(this:GetText(),nil)
          ShaguDB_ShowMap();
        end)
    end

    if ( SDBG_Favourites["item"][i] ~= '') then
      SDBG_ItemButtons["Button_"..i] = CreateFrame("Button","mybutton",SDBG,"UIPanelButtonTemplate")
      SDBG_ItemButtons["Button_"..i]:SetPoint("TOP", 0, -i*22-55)
      SDBG_ItemButtons["Button_"..i]:SetWidth(200)
      SDBG_ItemButtons["Button_"..i]:SetHeight(20)
      SDBG_ItemButtons["Button_"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
      SDBG_ItemButtons["Button_"..i]:SetNormalTexture(nil)
      SDBG_ItemButtons["Button_"..i]:SetPushedTexture(nil)
      SDBG_ItemButtons["Button_"..i]:SetTextColor(0.2,1,0.9,0.7)
      SDBG_ItemButtons["Button_"..i]:SetText(SDBG_Favourites["item"][i])
      SDBG_ItemButtons["Button_"..i]:SetScript("OnClick", function(self)
          ShaguDB_MAP_NOTES = {};
          ShaguDB_searchItem(this:GetText(),nil)
          ShaguDB_ShowMap();
        end)
    end

    if ( SDBG_Favourites["vendor"][i] ~= '' ) then
      SDBG_VendorButtons["Button_"..i] = CreateFrame("Button","mybutton",SDBG,"UIPanelButtonTemplate")
      SDBG_VendorButtons["Button_"..i]:SetPoint("TOPRIGHT", -10, -i*22-55)
      SDBG_VendorButtons["Button_"..i]:SetWidth(200)
      SDBG_VendorButtons["Button_"..i]:SetHeight(20)
      SDBG_VendorButtons["Button_"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
      SDBG_VendorButtons["Button_"..i]:SetNormalTexture(nil)
      SDBG_VendorButtons["Button_"..i]:SetPushedTexture(nil)
      SDBG_VendorButtons["Button_"..i]:SetTextColor(0.2,1,0.9,0.7)
      SDBG_VendorButtons["Button_"..i]:SetText(SDBG_Favourites["vendor"][i])
      SDBG_VendorButtons["Button_"..i]:SetScript("OnClick", function(self)
          ShaguDB_MAP_NOTES = {};
          ShaguDB_searchVendor(this:GetText(),nil)
          ShaguDB_ShowMap();
        end)
    end
  end
end
-- }}}
-- {{{ EditFavourites
function SDBG_EditFavourites()
  SDBG_HideFavEdit()
  SDBG_HideButtons()
  SDBG.cleanButton:Hide()
  SDBG.searchText:Hide()
  SDBG.caseSensitive:Show()
  SDBG.inputField:Hide()
  SDBG.cleanButton:Hide()
  for i = 1,13 do

    SDBG_FavouritesEdit["SpawnEdit"..i] = CreateFrame("EditBox", "InputBoxTemplateS"..i, SDBG)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetBackdrop(backdrop)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetBackdropBorderColor(0.2,0.2,0.2,1)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetText(SDBG_Favourites["spawn"][i])
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetJustifyH("CENTER")
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetTextColor(0.2,1,0.9,0.7)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetWidth(180)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetHeight(25)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetPoint("TOPLEFT", 20, -i*22-53)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetFontObject(GameFontNormal)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetAutoFocus(false)
    SDBG_FavouritesEdit["SpawnEdit"..i].editID = i
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetTextInsets(8,8,0,0)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetScript("OnTextChanged", function(self)
        SDBG_Favourites["spawn"][this.editID] = this:GetText()
      end)
    SDBG_FavouritesEdit["SpawnEdit"..i]:SetScript("OnEscapePressed", function(self)
        this:ClearFocus()
      end)

    SDBG_FavouritesEdit["ItemEdit"..i] = CreateFrame("EditBox", "InputBoxTemplateI"..i, SDBG)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetBackdrop(backdrop)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetBackdropBorderColor(0.2,0.2,0.2,1)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetText(SDBG_Favourites["item"][i])
    SDBG_FavouritesEdit["ItemEdit"..i]:SetJustifyH("CENTER")
    SDBG_FavouritesEdit["ItemEdit"..i]:SetTextColor(0.2,1,0.9,0.7)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetWidth(180)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetHeight(25)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetPoint("TOP", 0, -i*22-53)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetFontObject(GameFontNormal)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetAutoFocus(false)
    SDBG_FavouritesEdit["ItemEdit"..i].editID = i
    SDBG_FavouritesEdit["ItemEdit"..i]:SetTextInsets(8,8,0,0)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetScript("OnTextChanged", function(self)
        SDBG_Favourites["item"][this.editID] = this:GetText()
      end)
    SDBG_FavouritesEdit["ItemEdit"..i]:SetScript("OnEscapePressed", function(self)
        this:ClearFocus()
      end)

    SDBG_FavouritesEdit["VendorEdit"..i] = CreateFrame("EditBox", "InputBoxTemplateV"..i, SDBG)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetBackdrop(backdrop)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetBackdropBorderColor(0.2,0.2,0.2,1)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetText(SDBG_Favourites["vendor"][i])
    SDBG_FavouritesEdit["VendorEdit"..i]:SetJustifyH("CENTER")
    SDBG_FavouritesEdit["VendorEdit"..i]:SetTextColor(0.2,1,0.9,0.7)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetWidth(180)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetHeight(25)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetPoint("TOPRIGHT", -20, -i*22-53)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetFontObject(GameFontNormal)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetAutoFocus(false)
    SDBG_FavouritesEdit["VendorEdit"..i].editID = i
    SDBG_FavouritesEdit["VendorEdit"..i]:SetTextInsets(8,8,0,0)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetScript("OnTextChanged", function(self)
        SDBG_Favourites["vendor"][this.editID] = this:GetText()
      end)
    SDBG_FavouritesEdit["VendorEdit"..i]:SetScript("OnEscapePressed", function(self)
        this:ClearFocus()
      end)
  end
end

-- }}}
-- {{{ Query
function SDBG_Query(search)
  SDBG_HideButtons()
  if (strlen(search) >= 3) then
    SDBG_SearchSpawn(search)
    SDBG_SearchItem(search)
    SDBG_SearchVendor(search)
  else
    SDBG_ShowFavourites()
  end
end
-- }}}
