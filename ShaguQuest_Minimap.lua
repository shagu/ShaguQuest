MyMod_Settings = {
  MinimapPos = 45 -- default position of the minimap icon in degrees
}


-- Call this in a mod's initialization to move the minimap button to its saved position (also used in its movement)
-- ** do not call from the mod's OnLoad, VARIABLES_LOADED or later is fine. **
function MyMod_MinimapButton_Reposition()
  MyMod_MinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(MyMod_Settings.MinimapPos)),(80*sin(MyMod_Settings.MinimapPos))-52)
end


-- Only while the button is dragged this is called every frame
function MyMod_MinimapButton_DraggingFrame_OnUpdate()

  local xpos,ypos = GetCursorPosition()
  local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

  xpos = xmin-xpos/UIParent:GetScale()+70 -- get coordinates as differences from the center of the minimap
  ypos = ypos/UIParent:GetScale()-ymin-70

  MyMod_Settings.MinimapPos = math.deg(math.atan2(ypos,xpos)) -- save the degrees we are relative to the minimap center
  MyMod_MinimapButton_Reposition() -- move the button
end


-- Put your code that you want on a minimap button click here. arg1="LeftButton", "RightButton", etc
function MyMod_MinimapButton_OnClick()
  if ( arg1 == "LeftButton" ) then
    if (ShaguQuest_GUI:IsShown()) then
      ShaguQuest_GUI:Hide()
    else
      ShaguQuest_GUI:Show()
    end
  end
end
