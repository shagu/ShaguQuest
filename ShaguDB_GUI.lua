local backdrop = {
  bgFile = "Interface\\AddOns\\ShaguDB\\img\\background", tile = true, tileSize = 8,
  edgeFile = "Interface\\AddOns\\ShaguDB\\img\\border", edgeSize = 8,
  insets = {left = 0, right = 0, top = 0, bottom = 0},
}

local backdrop_noborder = {
  bgFile = "Interface\\AddOns\\ShaguDB\\img\\background", tile = true, tileSize = 8,
  insets = {left = 0, right = 0, top = 0, bottom = 0},
}

SDBG = CreateFrame("Frame",nil,UIParent)
SDBG:RegisterEvent("PLAYER_ENTERING_WORLD");
SDBG:SetScript("OnEvent", function(self, event, ...)
    SDBG.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(ShaguMinimapPosition)),(80*sin(ShaguMinimapPosition))-52)
  end)

SDBG:Hide()
SDBG:SetFrameStrata("DIALOG")
SDBG:SetWidth(500)
SDBG:SetHeight(445)

SDBG:SetBackdrop(backdrop)
SDBG:SetBackdropColor(0,0,0,.85);
SDBG:SetPoint("CENTER",0,0)
SDBG:SetMovable(true)
SDBG:EnableMouse(true)
SDBG:SetScript("OnMouseDown",function()
    SDBG:StartMoving()
  end)
SDBG:SetScript("OnMouseUp",function()
    SDBG:StopMovingOrSizing()
  end)



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

SDBG.minimapButton.overlay = SDBG.minimapButton:CreateTexture(nil, 'OVERLAY')
SDBG.minimapButton.overlay:SetWidth(53)
SDBG.minimapButton.overlay:SetHeight(53)
SDBG.minimapButton.overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
SDBG.minimapButton.overlay:SetPoint('TOPLEFT', 0,0)
SDBG.minimapButton.icon = SDBG.minimapButton:CreateTexture(nil, 'BACKGROUND')
SDBG.minimapButton.icon:SetWidth(20)
SDBG.minimapButton.icon:SetHeight(20)
SDBG.minimapButton.icon:SetTexture('Interface\\AddOns\\ShaguDB\\symbols\\sq')
SDBG.minimapButton.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
SDBG.minimapButton.icon:SetPoint('CENTER',1,1)

SDBG.closeButton = CreateFrame("Button", nil, SDBG, "UIPanelCloseButton")
SDBG.closeButton:SetWidth(30)
SDBG.closeButton:SetHeight(30) -- width, height
SDBG.closeButton:SetPoint("TOPRIGHT", -5,-5)
SDBG.closeButton:SetScript("OnClick", function()
    SDBG:Hide()
  end)

SDBG.titlebar = CreateFrame("Frame", nil, SDBG)
SDBG.titlebar:ClearAllPoints()
SDBG.titlebar:SetWidth(494)
SDBG.titlebar:SetHeight(35)
SDBG.titlebar:SetPoint("TOP", 0, -3)
SDBG.titlebar:SetBackdrop(backdrop_noborder)
SDBG.titlebar:SetBackdropColor(1,1,1,.10)

SDBG.text = SDBG:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.text:ClearAllPoints()
SDBG.text:SetPoint("TOPLEFT", 12, -12)
SDBG.text:SetFontObject(GameFontWhite)
SDBG.text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
SDBG.text:SetText("|cff33ffccShagu|cffffffffDB |cffaaaaaaoooVersionooo")

SDBG.input = CreateFrame("Frame", nil, SDBG)
--SDBG.input:ClearAllPoints()
SDBG.input:SetWidth(494)
SDBG.input:SetHeight(40)
SDBG.input:SetPoint("BOTTOM", 0, 3)
SDBG.input:SetBackdrop(backdrop_noborder)
--SDBG.input:SetBackdropColor(.2,1,.8,1)
SDBG.input:SetBackdropColor(1,1,1,.10)

SDBG.inputField = CreateFrame("EditBox", "InputBoxTemplate", SDBG.input, "InputBoxTemplate")
InputBoxTemplateLeft:SetTexture(1,1,1,.15);
InputBoxTemplateMiddle:SetTexture(1,1,1,.15);
InputBoxTemplateRight:SetTexture(1,1,1,.15);
SDBG.inputField:SetParent(SDBG.input)
SDBG.inputField:SetTextColor(.2,1.1,1)

SDBG.inputField:SetWidth(375)
SDBG.inputField:SetHeight(20)
SDBG.inputField:SetPoint("TOPLEFT", 15, -10)
SDBG.inputField:SetFontObject(GameFontNormal)
SDBG.inputField:SetAutoFocus(false)
SDBG.inputField:SetText("Search")
SDBG.inputField:SetScript("OnTextChanged", function(self)
  local query = SDBG.inputField:GetText()
  SDBG:HideButtons()
  if (strlen(query) >= 3) and query ~= "Search" then
    SDBG:SearchSpawn(query)
    SDBG:SearchItem(query)
    SDBG:SearchQuest(query)
  else
    SDBG.buttonSpawn.text:SetText("Mobs & Objects")
    SDBG.buttonItem.text:SetText("Items")
    SDBG.buttonQuest.text:SetText("Quests")
  end
end)

SDBG.inputField:SetScript("OnEditFocusGained", function(self)
  if this:GetText() == "Search" then this:SetText("") end
end)
SDBG.inputField:SetScript("OnEditFocusLost", function(self)
  if this:GetText() == "" then this:SetText("Search") end
end)

SDBG.cleanButton = CreateFrame("Button", nil, SDBG.input)
SDBG.cleanButton:SetParent(SDBG.input)
SDBG.cleanButton:SetWidth(65)
SDBG.cleanButton:SetHeight(24) -- width, height
SDBG.cleanButton:SetPoint("TOPRIGHT", -10,-8)
SDBG.cleanButton.text = SDBG.cleanButton:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.cleanButton.text:ClearAllPoints()
SDBG.cleanButton.text:SetAllPoints(SDBG.cleanButton)
SDBG.cleanButton.text:SetPoint("LEFT", 0, 0)
SDBG.cleanButton.text:SetFontObject(GameFontWhite)
SDBG.cleanButton.text:SetText("Clean")
SDBG.cleanButton:SetBackdrop(backdrop)
SDBG.cleanButton:SetBackdropColor(0,0,0,.15)
SDBG.cleanButton:SetBackdropBorderColor(1,1,1,.25)

SDBG.cleanButton:SetScript("OnClick", function()
    ShaguDB_CleanMap()
  end)

SDBG.buttonSpawn = CreateFrame("Button", nil, SDBG)
--SDBG.buttonSpawn:ClearAllPoints()
SDBG.buttonSpawn:SetWidth(150)
SDBG.buttonSpawn:SetHeight(25)
SDBG.buttonSpawn:SetPoint("TOPLEFT", 13, -50)
SDBG.buttonSpawn:SetBackdrop(backdrop_noborder)
SDBG.buttonSpawn.text = SDBG.buttonSpawn:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.buttonSpawn.text:ClearAllPoints()
SDBG.buttonSpawn.text:SetAllPoints(SDBG.buttonSpawn)
SDBG.buttonSpawn.text:SetPoint("LEFT", 0, 0)
SDBG.buttonSpawn.text:SetFontObject(GameFontWhite)
SDBG.buttonSpawn.text:SetText("Mobs & Objects")
SDBG.buttonSpawn:SetBackdropColor(1,1,1,.05)
SDBG.buttonSpawn:SetScript("OnClick", function()
  SDBG.buttonSpawn:SetBackdropColor(1,1,1,.15)
  SDBG.buttonItem:SetBackdropColor(1,1,1,.05)
  SDBG.buttonQuest:SetBackdropColor(1,1,1,.05)

  SDBG.spawn:Show()
  SDBG.item:Hide()
  SDBG.quest:Hide()
end)

SDBG.buttonItem = CreateFrame("Button", nil, SDBG)
--SDBG.buttonItem:ClearAllPoints()
SDBG.buttonItem:SetWidth(150)
SDBG.buttonItem:SetHeight(25)
SDBG.buttonItem:SetPoint("TOP", 0, -50)
SDBG.buttonItem:SetBackdrop(backdrop_noborder)
SDBG.buttonItem.text = SDBG.buttonItem:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.buttonItem.text:ClearAllPoints()
SDBG.buttonItem.text:SetAllPoints(SDBG.buttonItem)
SDBG.buttonItem.text:SetPoint("LEFT", 0, 0)
SDBG.buttonItem.text:SetFontObject(GameFontWhite)
SDBG.buttonItem.text:SetText("Items")
SDBG.buttonItem:SetBackdropColor(1,1,1,.15)
SDBG.buttonItem:SetScript("OnClick", function()
  SDBG.buttonItem:SetBackdropColor(1,1,1,.15)
  SDBG.buttonSpawn:SetBackdropColor(1,1,1,.05)
  SDBG.buttonQuest:SetBackdropColor(1,1,1,.05)

  SDBG.item:Show()
  SDBG.spawn:Hide()
  SDBG.quest:Hide()

end)

SDBG.buttonQuest = CreateFrame("Button", nil, SDBG)
--SDBG.buttonQuest:ClearAllPoints()
SDBG.buttonQuest:SetWidth(150)
SDBG.buttonQuest:SetHeight(25)
SDBG.buttonQuest:SetPoint("TOPRIGHT", -13, -50)
SDBG.buttonQuest:SetBackdrop(backdrop_noborder)
SDBG.buttonQuest.text = SDBG.buttonQuest:CreateFontString("Status", "LOW", "GameFontNormal")
SDBG.buttonQuest.text:ClearAllPoints()
SDBG.buttonQuest.text:SetAllPoints(SDBG.buttonQuest)
SDBG.buttonQuest.text:SetPoint("LEFT", 0, 0)
SDBG.buttonQuest.text:SetFontObject(GameFontWhite)
SDBG.buttonQuest.text:SetText("Quests")
SDBG.buttonQuest:SetBackdropColor(1,1,1,.05)
SDBG.buttonQuest:SetScript("OnClick", function()
  SDBG.buttonQuest:SetBackdropColor(1,1,1,.15)
  SDBG.buttonSpawn:SetBackdropColor(1,1,1,.05)
  SDBG.buttonItem:SetBackdropColor(1,1,1,.05)

  SDBG.quest:Show()
  SDBG.item:Hide()
  SDBG.spawn:Hide()

end)

SDBG.spawn = CreateFrame("Frame",nil,SDBG)
SDBG.spawn:SetPoint("TOP", 0, -75)
SDBG.spawn:SetWidth(475)
SDBG.spawn:SetHeight(315)
SDBG.spawn:SetBackdrop(backdrop_noborder)
SDBG.spawn:SetBackdropColor(1,1,1,.15)
--SDBG.spawn:SetFrameStrata("DIALOG")
SDBG.spawn:Hide()
SDBG.spawn.buttons = {}

SDBG.item = CreateFrame("Frame",nil,SDBG)
SDBG.item:SetPoint("TOP", 0, -75)
SDBG.item:SetWidth(475)
SDBG.item:SetHeight(315)
SDBG.item:SetBackdrop(backdrop_noborder)
SDBG.item:SetBackdropColor(1,1,1,.15)
--SDBG.item:SetFrameStrata("DIALOG")
SDBG.item.buttons = {}

SDBG.quest = CreateFrame("Frame",nil,SDBG)
SDBG.quest:SetPoint("TOP", 0, -75)
SDBG.quest:SetWidth(475)
SDBG.quest:SetHeight(315)
SDBG.quest:SetBackdrop(backdrop_noborder)
SDBG.quest:SetBackdropColor(1,1,1,.15)
--SDBG.quest:SetFrameStrata("DIALOG")
SDBG.quest:Hide()
SDBG.quest.buttons = {}

function SDBG.HideButtons()
  for i=1,14 do
    if (SDBG.spawn.buttons[i]) then
      SDBG.spawn.buttons[i]:Hide();
    end
    if (SDBG.item.buttons[i]) then
      SDBG.item.buttons[i]:Hide();
    end
    if (SDBG.quest.buttons[i]) then
      SDBG.quest.buttons[i]:Hide();
    end
  end
end

function SDBG:SearchSpawn(search)
  local spawnCount = 1;
  for spawn in pairs(spawnDB) do
    if (strfind(strlower(spawn), strlower(search))) then
      if ( spawnCount <= 14) then
        SDBG.spawn.buttons[spawnCount] = CreateFrame("Button","mybutton",SDBG.spawn,"UIPanelButtonTemplate")
        SDBG.spawn.buttons[spawnCount]:SetPoint("TOP", 0, -spawnCount*21+11)
        SDBG.spawn.buttons[spawnCount]:SetWidth(450)
        SDBG.spawn.buttons[spawnCount]:SetHeight(20)
        SDBG.spawn.buttons[spawnCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
        SDBG.spawn.buttons[spawnCount]:SetTextColor(1,1,1,1)
        SDBG.spawn.buttons[spawnCount]:SetNormalTexture(nil)
        SDBG.spawn.buttons[spawnCount]:SetPushedTexture(nil)
        SDBG.spawn.buttons[spawnCount]:SetHighlightTexture(nil)
        SDBG.spawn.buttons[spawnCount]:SetBackdrop(backdrop_noborder)
        if math.mod(spawnCount,2) == 0 then
          SDBG.spawn.buttons[spawnCount]:SetBackdropColor(1,1,1,.05)
          SDBG.spawn.buttons[spawnCount].even = true
        else
          SDBG.spawn.buttons[spawnCount]:SetBackdropColor(1,1,1,.10)
          SDBG.spawn.buttons[spawnCount].even = false
        end

        SDBG.spawn.buttons[spawnCount]:SetTextColor(1,1,1)
        if spawnDB[spawn]['level'] ~= "" then
          SDBG.spawn.buttons[spawnCount]:SetText(spawn .. " |cffaaaaaa(Lv." .. spawnDB[spawn]['level'] .. ")")
        else
          SDBG.spawn.buttons[spawnCount]:SetText(spawn)
        end
        SDBG.spawn.buttons[spawnCount].spawnName = spawn
        SDBG.spawn.buttons[spawnCount]:SetScript("OnClick", function(self)
            ShaguDB_MAP_NOTES = {};
            ShaguDB_searchMonster(this.spawnName,nil)
            ShaguDB_ShowMap();
          end)

        SDBG.spawn.buttons[spawnCount]:SetScript("OnEnter", function(self)
          this:SetBackdropColor(1,1,1,.25)
        end)

        SDBG.spawn.buttons[spawnCount]:SetScript("OnLeave", function(self)
          if this.even == true then
            this:SetBackdropColor(1,1,1,.05)
          else
            this:SetBackdropColor(1,1,1,.10)
          end
        end)


        -- show faction icons
        local faction = spawnDB[SDBG.spawn.buttons[spawnCount].spawnName]['faction']
        if strfind(faction, "H") and faction ~= "HA" then
          SDBG.spawn.buttons[spawnCount].horde = CreateFrame("Frame", nil, SDBG.spawn.buttons[spawnCount])
          SDBG.spawn.buttons[spawnCount].horde:SetPoint("RIGHT", -15, 0)
          SDBG.spawn.buttons[spawnCount].horde:SetWidth(20)
          SDBG.spawn.buttons[spawnCount].horde:SetHeight(20)
          SDBG.spawn.buttons[spawnCount].horde.icon = SDBG.spawn.buttons[spawnCount].horde:CreateTexture(nil,"BACKGROUND")
          SDBG.spawn.buttons[spawnCount].horde.icon:SetTexture("Interface\\AddOns\\ShaguDB\\symbols\\icon_horde")
          SDBG.spawn.buttons[spawnCount].horde.icon:SetAllPoints(SDBG.spawn.buttons[spawnCount].horde)
        end

        if strfind(faction, "A") and faction ~= "HA" then
          SDBG.spawn.buttons[spawnCount].alliance = CreateFrame("Frame", nil, SDBG.spawn.buttons[spawnCount])
          if SDBG.spawn.buttons[spawnCount].horde then
          SDBG.spawn.buttons[spawnCount].alliance:SetPoint("RIGHT", -40, 0)
          else
          SDBG.spawn.buttons[spawnCount].alliance:SetPoint("RIGHT", -15, 0)
          end
          SDBG.spawn.buttons[spawnCount].alliance:SetWidth(20)
          SDBG.spawn.buttons[spawnCount].alliance:SetHeight(20)
          SDBG.spawn.buttons[spawnCount].alliance.icon = SDBG.spawn.buttons[spawnCount].alliance:CreateTexture(nil,"BACKGROUND")
          SDBG.spawn.buttons[spawnCount].alliance.icon:SetTexture("Interface\\AddOns\\ShaguDB\\symbols\\icon_alliance")
          SDBG.spawn.buttons[spawnCount].alliance.icon:SetAllPoints(SDBG.spawn.buttons[spawnCount].alliance)
        end
        spawnCount = spawnCount + 1
      end
    end
  end
  
  if spawnCount >= 14 then spawnCount = "*" else spawnCount = spawnCount -1 end
  SDBG.buttonSpawn.text:SetText("Mobs & Objects |cffaaaaaa(" .. spawnCount .. ")")

end
-- }}}
-- {{{ SearchItem
function SDBG:SearchItem(search)
  local itemCount = 1;
  for itemName in pairs(itemDB) do
    if (strfind(strlower(itemName), strlower(search))) then
      if ( itemCount <= 14) then
        local itemColor
	    local itemID = itemDB[itemName]['id']
        GameTooltip:SetHyperlink("item:" .. itemID .. ":0:0:0")
        GameTooltip:Hide()

	    local _, itemLink, itemQuality, _, _, _, _, _, itemTexture = GetItemInfo(itemID)
        if itemQuality then itemColor = "|c" .. string.format("%02x%02x%02x%02x", 255, 
								    ITEM_QUALITY_COLORS[itemQuality].r * 255, 
								    ITEM_QUALITY_COLORS[itemQuality].g * 255, 
								    ITEM_QUALITY_COLORS[itemQuality].b * 255)
        else itemColor = "|cffffffff" end

        SDBG.item.buttons[itemCount] = CreateFrame("Button","mybutton",SDBG.item,"UIPanelButtonTemplate")
        SDBG.item.buttons[itemCount]:SetPoint("TOP", 0, -itemCount*21+11)
        SDBG.item.buttons[itemCount]:SetWidth(450)
        SDBG.item.buttons[itemCount]:SetHeight(20)
        SDBG.item.buttons[itemCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
        SDBG.item.buttons[itemCount]:SetNormalTexture(nil)
        SDBG.item.buttons[itemCount]:SetPushedTexture(nil)
        SDBG.item.buttons[itemCount]:SetHighlightTexture(nil)
        SDBG.item.buttons[itemCount]:SetBackdrop(backdrop_noborder)
        if math.mod(itemCount,2) == 0 then
          SDBG.item.buttons[itemCount]:SetBackdropColor(1,1,1,.05)
          SDBG.item.buttons[itemCount].even = true
        else
          SDBG.item.buttons[itemCount]:SetBackdropColor(1,1,1,.10)
          SDBG.item.buttons[itemCount].even = false
        end
        SDBG.item.buttons[itemCount].itemName = itemName
        SDBG.item.buttons[itemCount].itemColor = itemColor
        SDBG.item.buttons[itemCount].itemID = itemID
        SDBG.item.buttons[itemCount].itemLink = itemLink

        SDBG.item.buttons[itemCount]:SetText(itemColor .."|Hitem:"..itemID..":0:0:0|h["..itemName.."]|h|r")
        SDBG.item.buttons[itemCount]:SetScript("OnEnter", function(self)
          this:SetBackdropColor(1,1,1,.25)
            GameTooltip:SetOwner(SDBG, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink("item:" .. itemID .. ":0:0:0")
            GameTooltip:Show()
        end)

        SDBG.item.buttons[itemCount]:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
            if this.even == true then
              this:SetBackdropColor(1,1,1,.05)
            else
              this:SetBackdropColor(1,1,1,.10)
            end
        end)

        SDBG.item.buttons[itemCount]:SetScript("OnClick", function(self)
            if IsShiftKeyDown() then
                if not ChatFrameEditBox:IsVisible() then
                    ChatFrameEditBox:Show()
                end
	            ChatFrameEditBox:Insert(this.itemColor .."|Hitem:"..this.itemID..":0:0:0|h["..this.itemName.."]|h|r")
            elseif IsControlKeyDown() then
              DressUpItemLink(this.itemID);
            else
   ShowUIPanel(ItemRefTooltip);
   if ( not ItemRefTooltip:IsVisible() ) then
     ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
   end
	 ItemRefTooltip:SetHyperlink("item:" .. itemID .. ":0:0:0")

--                ShaguDB_MAP_NOTES = {};
--                ShaguDB_searchItem(this.itemName,nil)
--                ShaguDB_ShowMap();
            end
          end)


        -- show loot button
        if itemDB[itemName][1] or itemDB[itemName][2] then
          SDBG.item.buttons[itemCount].loot = CreateFrame("Button","mybutton",SDBG.item.buttons[itemCount],"UIPanelButtonTemplate")
          SDBG.item.buttons[itemCount].loot:SetPoint("RIGHT", -15, 0)
          SDBG.item.buttons[itemCount].loot:SetWidth(20)
          SDBG.item.buttons[itemCount].loot:SetHeight(20)
          SDBG.item.buttons[itemCount].loot:SetNormalTexture(nil)
          SDBG.item.buttons[itemCount].loot:SetPushedTexture(nil)
          SDBG.item.buttons[itemCount].loot:SetHighlightTexture(nil)
          SDBG.item.buttons[itemCount].loot.icon = SDBG.item.buttons[itemCount].loot:CreateTexture(nil,"BACKGROUND")

          local npc
          if itemDB[itemName][1] then
            _, _, npc, _ = strfind(itemDB[itemName][1], "(.*),(.*)");
          else
            _, _, npc, _ = strfind(itemDB[itemName][2], "(.*),(.*)");
          end
          
          if spawnDB[npc] and spawnDB[npc]['type'] == "NPC" then
            SDBG.item.buttons[itemCount].loot.icon:SetTexture("Interface\\AddOns\\ShaguDB\\symbols\\icon_npc")
          else
            SDBG.item.buttons[itemCount].loot.icon:SetTexture("Interface\\AddOns\\ShaguDB\\symbols\\icon_object")
          end
          SDBG.item.buttons[itemCount].loot.icon:SetAllPoints(SDBG.item.buttons[itemCount].loot)

          SDBG.item.buttons[itemCount].loot:SetScript("OnClick", function(self)
              ShaguDB_MAP_NOTES = {};
              ShaguDB_searchItem(this:GetParent().itemName,nil)
              ShaguDB_ShowMap();
          end)
        end

        -- show vendor button
        if vendorDB[itemName] then
          SDBG.item.buttons[itemCount].vendor = CreateFrame("Button","mybutton",SDBG.item.buttons[itemCount],"UIPanelButtonTemplate")
          if SDBG.item.buttons[itemCount].loot then
            SDBG.item.buttons[itemCount].vendor:SetPoint("RIGHT", -40, 0)
          else
            SDBG.item.buttons[itemCount].vendor:SetPoint("RIGHT", -15, 0)
          end
          SDBG.item.buttons[itemCount].vendor:SetWidth(20)
          SDBG.item.buttons[itemCount].vendor:SetHeight(20)
          SDBG.item.buttons[itemCount].vendor:SetNormalTexture(nil)
          SDBG.item.buttons[itemCount].vendor:SetPushedTexture(nil)
          SDBG.item.buttons[itemCount].vendor:SetHighlightTexture(nil)
          SDBG.item.buttons[itemCount].vendor.icon = SDBG.item.buttons[itemCount].vendor:CreateTexture(nil,"BACKGROUND")
          SDBG.item.buttons[itemCount].vendor.icon:SetTexture("Interface\\AddOns\\ShaguDB\\symbols\\icon_vendor")
          SDBG.item.buttons[itemCount].vendor.icon:SetAllPoints(SDBG.item.buttons[itemCount].vendor)
          SDBG.item.buttons[itemCount].vendor:SetScript("OnClick", function(self)
              ShaguDB_MAP_NOTES = {};
              ShaguDB_searchVendor(this:GetParent().itemName,nil)
              ShaguDB_ShowMap();
          end)
        end


        itemCount = itemCount + 1
      end
    end
  end
  if itemCount >= 14 then itemCount = "*" else itemCount = itemCount -1 end
  SDBG.buttonItem.text:SetText("Items |cffaaaaaa(" .. itemCount .. ")")
end
-- }}}a
-- {{{ SearchVenador
function SDBG:SearchQuest(search)
  local questCount = 1;
  for questName in pairs(questDB) do
    if (strfind(strlower(questName), strlower(search))) then
      if questCount <= 14 and questDB[questName] then
      
        SDBG.quest.buttons[questCount] = CreateFrame("Button","mybutton",SDBG.quest,"UIPanelButtonTemplate")
        SDBG.quest.buttons[questCount]:SetPoint("TOP", 0, -questCount*22+11)
        SDBG.quest.buttons[questCount]:SetWidth(450)
        SDBG.quest.buttons[questCount]:SetHeight(20)
        SDBG.quest.buttons[questCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
        SDBG.quest.buttons[questCount]:SetNormalTexture(nil)
        SDBG.quest.buttons[questCount]:SetPushedTexture(nil)
        SDBG.quest.buttons[questCount]:SetHighlightTexture(nil)
        SDBG.quest.buttons[questCount]:SetBackdrop(backdrop_noborder)
        if math.mod(questCount,2) == 0 then
          SDBG.quest.buttons[questCount]:SetBackdropColor(1,1,1,.05)
          SDBG.quest.buttons[questCount].even = true
        else
          SDBG.quest.buttons[questCount]:SetBackdropColor(1,1,1,.10)
          SDBG.quest.buttons[questCount].even = false
        end

        SDBG.quest.buttons[questCount].questName = questName
        SDBG.quest.buttons[questCount]:SetText("|cffffcc00" .."|Hquest:0:0:0:0|h["..questName.."]|h|r")
        SDBG.quest.buttons[questCount]:SetScript("OnEnter", function(self)
            this:SetBackdropColor(1,1,1,.25)
        end)

        SDBG.quest.buttons[questCount]:SetScript("OnLeave", function(self)
            if this.even == true then
              this:SetBackdropColor(1,1,1,.05)
            else
              this:SetBackdropColor(1,1,1,.10)
            end
        end)

        SDBG.quest.buttons[questCount]:SetScript("OnClick", function(self)
            if IsShiftKeyDown() then
                if not ChatFrameEditBox:IsVisible() then
                    ChatFrameEditBox:Show()
                end
	            ChatFrameEditBox:Insert("|cffffff00|Hitem:0:0:0:0|h["..this.questName.."]|h|r")
            else

            ShaguDB_MAP_NOTES = {};
            if (questDB[this.questName] ~= nil) then
              for monsterName, monsterDrop in pairs(questDB[this.questName]) do
                ShaguDB_searchMonster(monsterName,this.questName,true);
              end
            end
            ShaguDB_NextCMark();
            ShaguDB_ShowMap();
          end
          end)

        -- show faction icons
        local faction = ""
          for monsterName, monsterDrop in pairs(questDB[questName]) do
            if spawnDB[monsterName] and  spawnDB[monsterName]['faction'] then
            faction = faction .. spawnDB[monsterName]['faction']
            end
          end

          if strfind(faction, "H") and faction ~= "HA" then
            SDBG.quest.buttons[questCount].horde = CreateFrame("Frame", nil, SDBG.quest.buttons[questCount])
            SDBG.quest.buttons[questCount].horde:SetPoint("RIGHT", -15, 0)
            SDBG.quest.buttons[questCount].horde:SetWidth(20)
            SDBG.quest.buttons[questCount].horde:SetHeight(20)
            SDBG.quest.buttons[questCount].horde.icon = SDBG.quest.buttons[questCount].horde:CreateTexture(nil,"BACKGROUND")
            SDBG.quest.buttons[questCount].horde.icon:SetTexture("Interface\\AddOns\\ShaguDB\\symbols\\icon_horde")
            SDBG.quest.buttons[questCount].horde.icon:SetAllPoints(SDBG.quest.buttons[questCount].horde)
          end

          if strfind(faction, "A") and faction ~= "HA" then
            SDBG.quest.buttons[questCount].alliance = CreateFrame("Frame", nil, SDBG.quest.buttons[questCount])
            if SDBG.quest.buttons[questCount].horde then
            SDBG.quest.buttons[questCount].alliance:SetPoint("RIGHT", -40, 0)
            else
            SDBG.quest.buttons[questCount].alliance:SetPoint("RIGHT", -15, 0)
            end
            SDBG.quest.buttons[questCount].alliance:SetWidth(20)
            SDBG.quest.buttons[questCount].alliance:SetHeight(20)
            SDBG.quest.buttons[questCount].alliance.icon = SDBG.quest.buttons[questCount].alliance:CreateTexture(nil,"BACKGROUND")
            SDBG.quest.buttons[questCount].alliance.icon:SetTexture("Interface\\AddOns\\ShaguDB\\symbols\\icon_alliance")
            SDBG.quest.buttons[questCount].alliance.icon:SetAllPoints(SDBG.quest.buttons[questCount].alliance)
          end
  
        questCount = questCount + 1
      end
    end
  end
  if questCount >= 14 then questCount = "*" else questCount = questCount -1 end
  SDBG.buttonQuest.text:SetText("Quests |cffaaaaaa(" .. questCount .. ")")
end
