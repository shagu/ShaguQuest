if EQL3_QUESTLOG_VERSION ~= nil then
  local ShaguError = CreateFrame("Frame",nil,UIParent)
  ShaguError:SetFrameStrata("TOOLTIP")
  ShaguError:SetWidth(200)
  ShaguError:SetHeight(50)
  ShaguError:SetPoint("TOP",0,-150)

  ShaguError.text = ShaguError:CreateFontString("Status", "LOW", "GameFontNormal")
  ShaguError.text:SetFontObject(GameFontNormalLarge)
  ShaguError.text:SetPoint("CENTER", 0, 0)
  if ( GetLocale() == "deDE" ) then
    ShaguError.text:SetText("|cffff5555-- WARNUNG --|cffffeecc\n"
    .. "ShaguQuest ist inkompatibel zu EQL3. \n"
    .. "Es muss entweder \"ShaguQuest [EQL3]\" oder \"Extended Questlog 3\" deaktiviert werden.\n"
    .. "\n"
    .. "|caaaaaaaa*) ShaguQuest ist eine Weiterentwicklung von EQL3 und bietet eine Integration mit ShaguDB."
    ) 
  else
    ShaguError.text:SetText("|cffff5555-- WARNING --|cffffeecc\n"
    .. "ShaguQuest is incompatible with EQL3. \n"
    .. "You need to disable either \"ShaguQuest [EQL3]\" or \"Extended Questlog 3\". \n"
    .. "\n"
    .. "|caaaaaaaa*) ShaguQuest is a derivative of EQL3 which delivers integration with ShaguDB."
    )
  end

  CloseWindows = EQL3_old_CloseWindows
  ToggleQuestLog = old_ToggleQuestLog
  QuestWatch_Update = old_QuestWatch_Update
  GetNumQuestLogEntries = old_GetNumQuestLogEntries
  SelectQuestLogEntry = old_SelectQuestLogEntry
  GetQuestLogSelection = old_GetQuestLogSelection
  ExpandQuestHeader = old_ExpandQuestHeader
  CollapseQuestHeader = old_CollapseQuestHeader
  IsUnitOnQuest = old_IsUnitOnQuest
  GetNumQuestLeaderBoards = old_GetNumQuestLeaderBoards
  GetQuestLogLeaderBoard = old_GetQuestLogLeaderBoard
  GetQuestLogTitle = old_GetQuestLogTitle
end




