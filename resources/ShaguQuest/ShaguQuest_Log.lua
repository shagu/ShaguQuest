-- Log Script file for Extended Questlog 3.5
-- Copyright © 2006 Daniel Rehn

function ShaguQuest_Maximize()
	ShaguQuest_QuestLogFrameCloseButton:Hide();
	ShaguQuest_QuestLogFrameMaximizeButton:Hide();
	ShaguQuest_QuestLogCountRight:SetPoint("TOPRIGHT", -28, -43);
	ShaguQuest_QuestLogTitleText:SetPoint("TOP", 48, -16);
	ShaguQuest_QuestLogVersionText:SetPoint("TOPRIGHT", -67, -16);
	ShaguQuest_QuestFrameOptionsButton:SetPoint("BOTTOMRIGHT", -25, 5);
	
	ShaguQuest_Top_Switch_On:Show();
	ShaguQuest_Bottom_Switch_On:Show();
	ShaguQuest_Top_Switch_Off:Hide();
	ShaguQuest_Bottom_Switch_Off:Hide();
	-- ShaguQuest_Top_Switch:SetTexture("Interface\Addons\ShaguQuest\Images\ShaguQuest_TopSwitchOn.tga");
	-- ShaguQuest_Bottom_Switch:SetTexture("Interface\Addons\ShaguQuest\Images\ShaguQuest_BottomSwitchOn.tga");
	
	QuestlogOptions[ShaguQuest_Player].WindowState = 1;
	ShowUIPanel(ShaguQuest_QuestLogFrame_Description);
end

function ShaguQuest_Minimize()
	ShaguQuest_QuestLogFrameCloseButton:Show();
	ShaguQuest_QuestLogFrameMaximizeButton:Show();
	ShaguQuest_QuestLogCountRight:SetPoint("TOPRIGHT", -356, -43);
	ShaguQuest_QuestLogTitleText:SetPoint("TOP", -114, -16);
	ShaguQuest_QuestLogVersionText:SetPoint("TOPRIGHT", -395, -16);
	ShaguQuest_QuestFrameOptionsButton:SetPoint("BOTTOMRIGHT", -354, 5);
	
	ShaguQuest_Top_Switch_On:Hide();
	ShaguQuest_Bottom_Switch_On:Hide();
	ShaguQuest_Top_Switch_Off:Show();
	ShaguQuest_Bottom_Switch_Off:Show();
	-- ShaguQuest_Top_Switch:SetTexture("Interface\Addons\ShaguQuest\Images\ShaguQuest_TopSwitchOff");
	-- ShaguQuest_Bottom_Switch:SetTexture("Interface\Addons\ShaguQuest\Images\ShaguQuest_BottomSwitchOff");
	
	QuestlogOptions[ShaguQuest_Player].WindowState = 0;
	HideUIPanel(ShaguQuest_QuestLogFrame_Description);
end

-- Toggle
local old_ToggleQuestLog = ToggleQuestLog;
function ToggleQuestLog()
	if ( ShaguQuest_QuestLogFrame:IsVisible() ) then
		HideUIPanel(ShaguQuest_QuestLogFrame);
	else
		ShowUIPanel(ShaguQuest_QuestLogFrame);
	end
end



-- ::::::::::::::::::: On Functions ::::::::::::::::::: --

-- OnLoad
function EQL_QuestLog_OnLoad()
  this:RegisterEvent("VARIABLES_LOADED");	
  this:RegisterEvent("QUEST_PROGRESS");	
  this:RegisterEvent("QUEST_COMPLETE");	 
end

-- OnEvent
function EQL_QuestLog_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		ShaguQuest_Player = UnitName("player").."-"..GetRealmName();
		
		DEFAULT_CHAT_FRAME:AddMessage("Extended QuestLog "..ShaguQuest_QUESTLOG_VERSION.." Loaded for "..UnitName("player").. " of "..GetRealmName()..".", 1, 1, 1, 1);
		
		if(QuestlogOptions == nil) then
			QuestlogOptions = {};
		end
		if(QuestlogOptions[ShaguQuest_Player] == nil) then
			QuestlogOptions[ShaguQuest_Player] = {};
		end
		
		-- Organizer
		
		if (QuestlogOptions[ShaguQuest_Player].OrganizerSettings == nil) then
			QuestlogOptions[ShaguQuest_Player].OrganizerSettings = {};
		end
		
		if (QuestlogOptions[ShaguQuest_Player].WindowState == nil) then
			QuestlogOptions[ShaguQuest_Player].WindowState = 0;
		end
		if(QuestlogOptions[ShaguQuest_Player].WindowState == 1) then
			ShaguQuest_Maximize();
		end
		
		if(QuestlogOptions[ShaguQuest_Player].QuestWatches == nil) then
			QuestlogOptions[ShaguQuest_Player].QuestWatches = {};
		end
		
		if(QuestlogOptions[ShaguQuest_Player].ShowQuestLevels == nil) then
			QuestlogOptions[ShaguQuest_Player].ShowQuestLevels = 1;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].RestoreUponSelect == nil) then
			QuestlogOptions[ShaguQuest_Player].RestoreUponSelect = 1;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].MinimizeUponClose == nil) then
			QuestlogOptions[ShaguQuest_Player].MinimizeUponClose = 1;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].LockQuestLog == nil) then
			QuestlogOptions[ShaguQuest_Player].LockQuestLog = 1;
		end
			-- Make It movable if so...
			if(QuestlogOptions[ShaguQuest_Player].LockQuestLog == 1) then
				ShaguQuest_QuestLogFrame:RegisterForDrag(0);
				ShaguQuest_QuestLogFrame_Description:RegisterForDrag(0);
			else
				ShaguQuest_QuestLogFrame:RegisterForDrag("LeftButton");
				ShaguQuest_QuestLogFrame_Description:RegisterForDrag("LeftButton");
			end
			
		if (QuestlogOptions[ShaguQuest_Player].LogLockPoints and
							QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointone and
							QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointtwo) then
			ShaguQuest_QuestLogFrame:ClearAllPoints();
			ShaguQuest_QuestLogFrame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointone,QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointtwo);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].LogOpacity == nil) then
			QuestlogOptions[ShaguQuest_Player].LogOpacity = 1.0;
		end
		ShaguQuest_QuestLogFrame:SetAlpha(QuestlogOptions[ShaguQuest_Player].LogOpacity);
		
		if(QuestlogOptions[ShaguQuest_Player].ShowZonesInTracker == nil) then
			QuestlogOptions[ShaguQuest_Player].ShowZonesInTracker = 1;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].SortTrackerItems == nil) then
			QuestlogOptions[ShaguQuest_Player].SortTrackerItems = 0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].CustomZoneColor == nil) then
			QuestlogOptions[ShaguQuest_Player].CustomZoneColor = 0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].CustomHeaderColor == nil) then
			QuestlogOptions[ShaguQuest_Player].CustomHeaderColor = 0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].CustomObjetiveColor == nil) then
			QuestlogOptions[ShaguQuest_Player].CustomObjetiveColor = 0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].FadeHeaderColor == nil) then
			QuestlogOptions[ShaguQuest_Player].FadeHeaderColor = 0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].FadeObjectiveColor == nil) then
			QuestlogOptions[ShaguQuest_Player].FadeObjectiveColor = 0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].CustomTrackerBGColor == nil) then
			QuestlogOptions[ShaguQuest_Player].CustomTrackerBGColor = 0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].UseTrackerListing == nil) then
			QuestlogOptions[ShaguQuest_Player].UseTrackerListing = 0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].TrackerList == nil) then
			QuestlogOptions[ShaguQuest_Player].TrackerList = 0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].TrackerSymbol == nil) then
			QuestlogOptions[ShaguQuest_Player].TrackerSymbol = 0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color == nil) then
			QuestlogOptions[ShaguQuest_Player].Color = {};
		end
		
		-- Colors
		
		if(QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"] == nil) then
			QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"] = {	r = TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,
																													g = TOOLTIP_DEFAULT_BACKGROUND_COLOR.g,
																													b = TOOLTIP_DEFAULT_BACKGROUND_COLOR.b,
																													a = 0.0};
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].a == nil) then
			QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].a = 0.0;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["Zone"] == nil) then
			QuestlogOptions[ShaguQuest_Player].Color["Zone"] = {r = 1.0, g = 1.0, b = 1.0};
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"] == nil) then
			QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"] = {r = 0.75, g = 0.61, b = 0.0};
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"] == nil) then
			QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"] = {r = NORMAL_FONT_COLOR.r,
																															g = NORMAL_FONT_COLOR.g,
																															b = NORMAL_FONT_COLOR.b};
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"] == nil) then
			QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"] = {r = 0.8, g = 0.8, b = 0.8};
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"] == nil) then
			QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"] = {r = HIGHLIGHT_FONT_COLOR.r,
																																 g = HIGHLIGHT_FONT_COLOR.g,
																																 b = HIGHLIGHT_FONT_COLOR.b};
		end
		
		
		
		if(QuestlogOptions[ShaguQuest_Player].LockTracker == nil) then
			QuestlogOptions[ShaguQuest_Player].LockTracker = 0;
		end
		if(QuestlogOptions[ShaguQuest_Player].LockPoints == nil) then
			QuestlogOptions[ShaguQuest_Player].LockPoints = {};
		end
		
		if(QuestlogOptions[ShaguQuest_Player].AddNew == nil) then
			QuestlogOptions[ShaguQuest_Player].AddNew = 0;
		end
		if(QuestlogOptions[ShaguQuest_Player].RemoveFinished == nil) then
			QuestlogOptions[ShaguQuest_Player].RemoveFinished = 0;
		end
		if(QuestlogOptions[ShaguQuest_Player].MinimizeFinished == nil) then
			QuestlogOptions[ShaguQuest_Player].MinimizeFinished = 0;
		end
		if(QuestlogOptions[ShaguQuest_Player].AddUntracked == nil) then
			QuestlogOptions[ShaguQuest_Player].AddUntracked = 0;
		end
		
		
		if(QuestlogOptions[ShaguQuest_Player].TrackerFontHeight == nil) then
			QuestlogOptions[ShaguQuest_Player].TrackerFontHeight = 12;
		end
		
		if(QuestlogOptions[ShaguQuest_Player].TrackerShowMinimizer == nil) then
			QuestlogOptions[ShaguQuest_Player].TrackerShowMinimizer = 0;
		end
		if(QuestlogOptions[ShaguQuest_Player].TrackerIsMinimized == nil) then
			QuestlogOptions[ShaguQuest_Player].TrackerIsMinimized = 0;
		end
		
		-- 3.5.6b
		if( QuestlogOptions[ShaguQuest_Player].AutoCompleteQuests == nil ) then
			QuestlogOptions[ShaguQuest_Player].AutoCompleteQuests = 0;
		end
		if( QuestlogOptions[ShaguQuest_Player].RemoveCompletedObjectives == nil ) then
			QuestlogOptions[ShaguQuest_Player].RemoveCompletedObjectives = 0;
		end
		if( QuestlogOptions[ShaguQuest_Player].ShowObjectiveMarkers == nil ) then
			QuestlogOptions[ShaguQuest_Player].ShowObjectiveMarkers = 1;
		end
		if( QuestlogOptions[ShaguQuest_Player].OnlyLevelsInLog == nil ) then
			QuestlogOptions[ShaguQuest_Player].OnlyLevelsInLog = 0;
		end
		
		-- 3.5.9
		if( QuestlogOptions[ShaguQuest_Player].ItemTooltip == nil ) then
			QuestlogOptions[ShaguQuest_Player].ItemTooltip = 1;
		end
		if( QuestlogOptions[ShaguQuest_Player].MobTooltip == nil ) then
			QuestlogOptions[ShaguQuest_Player].MobTooltip = 1;
		end
		if( QuestlogOptions[ShaguQuest_Player].InfoOnQuestCompletion == nil ) then
			QuestlogOptions[ShaguQuest_Player].InfoOnQuestCompletion = 0;
		end
		
		
		if(QuestlogOptions[ShaguQuest_Player].Color["Tooltip"] == nil) then
			QuestlogOptions[ShaguQuest_Player].Color["Tooltip"] = {r = 1.0, g = 0.8, b = 0.0};
		end
		
		if(QuestlogOptions[ShaguQuest_Player].CustomTooltipColor == nil) then
			QuestlogOptions[ShaguQuest_Player].CustomTooltipColor = 0;
		end
		
		
		
	elseif	( event == "QUEST_PROGRESS" ) then
		if ( QuestlogOptions[ShaguQuest_Player].AutoCompleteQuests == 1 ) then
			if ( IsQuestCompletable() ) then
				CompleteQuest();
			end
		end
	elseif ( event == "QUEST_COMPLETE" ) then
		if ( QuestlogOptions[ShaguQuest_Player].AutoCompleteQuests == 1 and GetNumQuestChoices() == 0 ) then
			GetQuestReward(QuestFrameRewardPanel.itemChoice);
		end
	end
end

local old_QuestLog_OnEvent = QuestLog_OnEvent;
function QuestLog_OnEvent(event)
	if ( event == "QUEST_LOG_UPDATE" or event == "UPDATE_FACTION" or (event == "UNIT_QUEST_LOG_CHANGED" and arg1 == "player") ) then
		QuestLog_Update();
		QuestWatch_Update();
		if ( ShaguQuest_QuestLogFrame:IsVisible() ) then
			QuestLog_UpdateQuestDetails(1);
		end
		
		if(event == "QUEST_LOG_UPDATE") then
			if(QuestlogOptions[ShaguQuest_Player].InfoOnQuestCompletion == 1) then
				LookForCompletedQuests();
			end
		end
	else
		QuestLog_Update();
		if ( event == "PARTY_MEMBERS_CHANGED" ) then
			-- Determine whether the selected quest is pushable or not
			if ( GetQuestLogPushable() and GetNumPartyMembers() > 0 ) then
				ShaguQuest_QuestFramePushQuestButton:Enable();
			else
				ShaguQuest_QuestFramePushQuestButton:Disable();
			end
		end
	end
end


-- OnShow
local old_QuestLog_OnShow = QuestLog_OnShow;
function QuestLog_OnShow()
	-- fix for crash with gypsy causing blank log and error
	if ( Gypsy_ShowQuestLevels and Gypsy_ShowQuestLevels == 1 ) then Gypsy_ShowQuestLevels = 0 end
	
	if(QuestLogFrame:IsVisible()) then
		QuestLogFrame:Hide();
	end
	
	ShowUIPanel(ShaguQuest_QuestLogFrame);
	
	if (QuestlogOptions[ShaguQuest_Player].LogLockPoints and
					QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointone and
					QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointtwo) then
		ShaguQuest_QuestLogFrame:ClearAllPoints();
		ShaguQuest_QuestLogFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointone,QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointtwo);
	end
	
	UpdateMicroButtons();
	PlaySound("igQuestLogOpen");
	QuestLog_SetSelection(GetQuestLogSelection());
	QuestLog_Update();
end

-- OnHide
local old_QuestLog_OnHide = QuestLog_OnHide;
function QuestLog_OnHide()
	HideUIPanel(ShaguQuest_QuestLogFrame);
	UpdateMicroButtons();
	PlaySound("igQuestLogClose");
	ShaguQuest_Organize_Popup:Hide();
	ShaguQuest_OptionsFrame:Hide();
	if ( QuestlogOptions[ShaguQuest_Player].MinimizeUponClose == 1 ) then
		ShaguQuest_Minimize();
	end
end

-- OnUpdate
local old_QuestLog_OnUpdate = QuestLog_OnUpdate;
function QuestLog_OnUpdate(elapsed)
	if ( ShaguQuest_QuestLogFrame.hasTimer ) then
		ShaguQuest_QuestLogFrame.timePassed = ShaguQuest_QuestLogFrame.timePassed + elapsed;
		if ( ShaguQuest_QuestLogFrame.timePassed > UPDATE_DELAY ) then
			ShaguQuest_QuestLogTimerText:SetText(TEXT(TIME_REMAINING).." "..SecondsToTime(GetQuestLogTimeLeft()));
			ShaguQuest_QuestLogFrame.timePassed = 0;		
		end
	end
end



local normal_QuestLog_Update = QuestLog_Update;

function QuestLog_Update()
	local numEntries, numQuests = GetNumQuestLogEntries();
	if ( numEntries == 0 ) then
		ShaguQuest_EmptyQuestLogFrame:Show();
		ShaguQuest_QuestLogFrameAbandonButton:Disable();
		QuestLogFrame.hasTimer = nil;
		ShaguQuest_QuestLogDetailScrollFrame:Hide();
		ShaguQuest_QuestLogExpandButtonFrame:Hide();
	else
		ShaguQuest_EmptyQuestLogFrame:Hide();
		ShaguQuest_QuestLogFrameAbandonButton:Enable();
		ShaguQuest_QuestLogDetailScrollFrame:Show();
		ShaguQuest_QuestLogExpandButtonFrame:Show();
	end

	-- Update Quest Count
	ShaguQuest_QuestLogQuestCount:SetText(format(QUEST_LOG_COUNT_TEMPLATE, numQuests, MAX_QUESTLOG_QUESTS));
	ShaguQuest_QuestLogCountMiddle:SetWidth(ShaguQuest_QuestLogQuestCount:GetWidth());

	-- ScrollFrame update
	FauxScrollFrame_Update(ShaguQuest_QuestLogListScrollFrame, numEntries, ShaguQuest_QUESTS_DISPLAYED, QUESTLOG_QUEST_HEIGHT, nil, nil, nil, ShaguQuest_QuestLogHighlightFrame, 293, 316 )
	
	-- Update the quest listing
	ShaguQuest_QuestLogHighlightFrame:Hide();
	
	local questIndex, questLogTitle, questTitleTag, questNumGroupMates, questNormalText, questHighlightText, questDisabledText, questHighlight, questCheck;
	local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete, color;
	local numPartyMembers, partyMembersOnQuest, tempWidth, textWidth, tempLevel;
	for i=1, ShaguQuest_QUESTS_DISPLAYED, 1 do
		questIndex = i + FauxScrollFrame_GetOffset(ShaguQuest_QuestLogListScrollFrame);
		questLogTitle = getglobal("ShaguQuest_QuestLogTitle"..i);
		questTitleTag = getglobal("ShaguQuest_QuestLogTitle"..i.."Tag");
		questNumGroupMates = getglobal("ShaguQuest_QuestLogTitle"..i.."GroupMates");
		questCheck = getglobal("ShaguQuest_QuestLogTitle"..i.."Check");
		questNormalText = getglobal("ShaguQuest_QuestLogTitle"..i.."NormalText");
		questHighlightText = getglobal("ShaguQuest_QuestLogTitle"..i.."NormalText");
		questDisabledText = getglobal("ShaguQuest_QuestLogTitle"..i.."NormalText");
		questHighlight = getglobal("ShaguQuest_QuestLogTitle"..i.."Highlight");
		if ( questIndex <= numEntries ) then
			questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questIndex);
			if(not questLogTitleText) then questLogTitleText = "Please report this error!" end
			if ( isHeader ) then
				if ( questLogTitleText ) then
					questLogTitle:SetText(questLogTitleText);
				else
					questLogTitle:SetText("");
				end
				
				--[[
				if ( isCollapsed ) then
					questLogTitle:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				else
					questLogTitle:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up"); 
				end
				]]--
				
				questLogTitle:SetNormalTexture("Interface\\Addons\\ShaguQuest\\Images\\ShaguQuest_Header_Icon");
				
				questHighlight:SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
				questNumGroupMates:SetText("");
				questCheck:Hide();
			else
				
				if(QuestlogOptions[ShaguQuest_Player].ShowQuestLevels == 1) then
					tempLevel = level;
					if (questTag ~= NIL) then
						tempLevel = tempLevel.."+";
					end
					questLogTitle:SetText("  ".."["..tempLevel.."] "..questLogTitleText);
				else
					questLogTitle:SetText("  "..questLogTitleText);
				end
				
				
				-- Set Dummy text to get text width *SUPER HACK*
				QuestLogDummyText:SetText(questLogTitle:GetText());

				questLogTitle:SetNormalTexture("");
				questHighlight:SetTexture("");

				-- If not a header see if any nearby group mates are on this quest
				numPartyMembers = GetNumPartyMembers();
				if ( numPartyMembers == 0 ) then
					--return;
				end
				partyMembersOnQuest = 0;
				for j=1, numPartyMembers do
					if ( IsUnitOnQuest(questIndex, "party"..j) ) then
						partyMembersOnQuest = partyMembersOnQuest + 1;
					end
				end
				if ( partyMembersOnQuest > 0 ) then
					questNumGroupMates:SetText("["..partyMembersOnQuest.."]");
				else
					questNumGroupMates:SetText("");
				end
			end
			-- Save if its a header or not
			questLogTitle.isHeader = isHeader;

			-- Set the quest tag
			if ( isComplete and isComplete < 0 ) then
				questTag = FAILED;
			elseif ( isComplete and isComplete > 0 ) then
				questTag = COMPLETE;
			end
			if ( questTag ) then
				questTitleTag:SetText("("..questTag..")");
				-- Shrink text to accomdate quest tags without wrapping
				tempWidth = 275 - 15 - questTitleTag:GetWidth();
				
				if ( QuestLogDummyText:GetWidth() > tempWidth ) then
					textWidth = tempWidth;
				else
					textWidth = QuestLogDummyText:GetWidth();
				end
				
				questNormalText:SetWidth(tempWidth);
				questHighlightText:SetWidth(tempWidth);
				questDisabledText:SetWidth(tempWidth);
				
				-- If there's quest tag position check accordingly
				questCheck:Hide();
				if ( IsQuestWatched(questIndex) ) then
					questCheck:SetPoint("LEFT", questLogTitle, "LEFT", textWidth+24, 0);
					questCheck:Show();
				end
			else
				questTitleTag:SetText("");
				-- Reset to max text width
				questNormalText:SetWidth(275);
				questHighlightText:SetWidth(275);
				questDisabledText:SetWidth(275);

				-- Show check if quest is being watched
				questCheck:Hide();
				if ( IsQuestWatched(questIndex) ) then
					questCheck:SetPoint("LEFT", questLogTitle, "LEFT", QuestLogDummyText:GetWidth()+24, 0);
					questCheck:Show();
				end
			end

			

			-- Color the quest title and highlight according to the difficulty level
			
			if(not level) then level = 0; end
			
			local playerLevel = UnitLevel("player");
			if ( isHeader ) then
				color = QuestDifficultyColor["header"];
			else
				color = GetDifficultyColor(level);
			end
			questTitleTag:SetTextColor(color.r, color.g, color.b);
			questLogTitle:SetTextColor(color.r, color.g, color.b);
			questNumGroupMates:SetTextColor(color.r, color.g, color.b);
			questLogTitle.r = color.r;
			questLogTitle.g = color.g;
			questLogTitle.b = color.b;
			questLogTitle:Show();
			
			-- Place the highlight and lock the highlight state
			if ( ShaguQuest_QuestLogFrame.selectedButtonID and GetQuestLogSelection() == questIndex ) then
				ShaguQuest_QuestLogHighlightFrame:SetPoint("TOPLEFT", "ShaguQuest_QuestLogTitle"..i, "TOPLEFT", 0, 0);
				ShaguQuest_QuestLogHighlightFrame:Show();
				questTitleTag:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
				questLogTitle:LockHighlight();
			else
				questLogTitle:UnlockHighlight();
			end
		else
			questLogTitle:Hide();
		end
	end
		
	-- Set the expand/collapse all button texture
	local numHeaders = 0;
	local notExpanded = 0;
	-- Somewhat redundant loop, but cleaner than the alternatives
	for i=1, numEntries, 1 do
		local index = i;
		local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(i);
		if ( questLogTitleText and isHeader ) then
			numHeaders = numHeaders + 1;
			if ( isCollapsed ) then
				notExpanded = notExpanded + 1;
			end
		end
	end
	-- If all headers are not expanded then show collapse button, otherwise show the expand button
	if ( notExpanded ~= numHeaders ) then
		ShaguQuest_QuestLogCollapseAllButton.collapsed = nil;
		ShaguQuest_QuestLogCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	else
		ShaguQuest_QuestLogCollapseAllButton.collapsed = 1;
		ShaguQuest_QuestLogCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	end

	-- Update Quest Count
	ShaguQuest_QuestLogQuestCount:SetText(format(QUEST_LOG_COUNT_TEMPLATE, numQuests, MAX_QUESTLOG_QUESTS));
	ShaguQuest_QuestLogCountMiddle:SetWidth(ShaguQuest_QuestLogQuestCount:GetWidth());

	-- If no selection then set it to the first available quest
	if ( GetQuestLogSelection() == 0 ) then
		QuestLog_SetFirstValidSelection();
	end

	-- Determine whether the selected quest is pushable or not
	if ( numEntries == 0 ) then
		ShaguQuest_QuestFramePushQuestButton:Disable();
	elseif ( GetQuestLogPushable() and GetNumPartyMembers() > 0 ) then
		ShaguQuest_QuestFramePushQuestButton:Enable();
	else
		ShaguQuest_QuestFramePushQuestButton:Disable();
	end
end



local normal_QuestLog_SetSelection = QuestLog_SetSelection;

function QuestLog_SetSelection(questID)
	local selectedQuest;
	if ( questID == 0 ) then
		ShaguQuest_QuestLogDetailScrollFrame:Hide();
		return 0;
	end

	-- Get xml id
	local id = questID - FauxScrollFrame_GetOffset(ShaguQuest_QuestLogListScrollFrame);
	
	SelectQuestLogEntry(questID);
	local titleButton = getglobal("ShaguQuest_QuestLogTitle"..id);
	local titleButtonTag = getglobal("ShaguQuest_QuestLogTitle"..id.."Tag");
	
	local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(questID);
	if ( isHeader ) then
		if ( isCollapsed ) then
			ExpandQuestHeader(questID);
			MakeQuestHeaderList();
			return 0;
		else
			CollapseQuestHeader(questID);
			MakeQuestHeaderList();
			return 0;
		end
	else
		-- Set newly selected quest and highlight it
		ShaguQuest_QuestLogFrame.selectedButtonID = questID;
		local scrollFrameOffset = FauxScrollFrame_GetOffset(ShaguQuest_QuestLogListScrollFrame);
		if ( questID > scrollFrameOffset and questID <= (scrollFrameOffset + ShaguQuest_QUESTS_DISPLAYED) and questID <= GetNumQuestLogEntries() ) then
			titleButton:LockHighlight();
			titleButtonTag:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			
			ShaguQuest_QuestLogSkillHighlight:SetVertexColor(titleButton.r, titleButton.g, titleButton.b);
			ShaguQuest_QuestLogHighlightFrame:SetPoint("TOPLEFT", "ShaguQuest_QuestLogTitle"..id, "TOPLEFT", 5, 0);
			ShaguQuest_QuestLogHighlightFrame:Show();
		end
	end
	if ( GetQuestLogSelection() > GetNumQuestLogEntries() ) then
		return 0;
	end
	QuestLog_UpdateQuestDetails();
	return 1;
end


local normal_QuestLog_UpdateQuestDetails = QuestLog_UpdateQuestDetails;

function QuestLog_UpdateQuestDetails(doNotScroll)
	local questID = GetQuestLogSelection();
	local questTitle = GetQuestLogTitle(questID);
	if ( not questTitle ) then
		questTitle = "";
	end
	if ( IsCurrentQuestFailed() ) then
		questTitle = questTitle.." - ("..TEXT(FAILED)..")";
	end
	ShaguQuest_QuestLogQuestTitle:SetText(questTitle);

	local questDescription;
	local questObjectives;
	questDescription, questObjectives = GetQuestLogQuestText();
	ShaguQuest_QuestLogObjectivesText:SetText(questObjectives);
	
	local questTimer = GetQuestLogTimeLeft();
	if ( questTimer ) then
		ShaguQuest_QuestLogFrame.hasTimer = 1;
		ShaguQuest_QuestLogFrame.timePassed = 0;
		ShaguQuest_QuestLogTimerText:Show();
		ShaguQuest_QuestLogTimerText:SetText(TEXT(TIME_REMAINING).." "..SecondsToTime(questTimer));
		ShaguQuest_QuestLogObjective1:SetPoint("TOPLEFT", "ShaguQuest_QuestLogTimerText", "BOTTOMLEFT", 0, -10);
	else
		ShaguQuest_QuestLogFrame.hasTimer = nil;
		ShaguQuest_QuestLogTimerText:Hide();
		ShaguQuest_QuestLogObjective1:SetPoint("TOPLEFT", "ShaguQuest_QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
	end
	
	-- Show Quest Watch if track quest is checked
	local numObjectives = GetNumQuestLeaderBoards();
	
	for i=1, numObjectives, 1 do
		local string = getglobal("ShaguQuest_QuestLogObjective"..i);
		local text;
		local type;
		local finished;
		text, type, finished = GetQuestLogLeaderBoard(i);
		if ( not text or strlen(text) == 0 ) then
			text = type;
		end
		if ( finished ) then
			string:SetTextColor(0.2, 0.2, 0.2);
			text = text.." ("..TEXT(COMPLETE)..")";
		else
			string:SetTextColor(0, 0, 0);
		end
		string:SetText(text);
		string:Show();
		QuestFrame_SetAsLastShown(string);
	end

	for i=numObjectives + 1, MAX_OBJECTIVES, 1 do
		getglobal("ShaguQuest_QuestLogObjective"..i):Hide();
	end

	-- If there's money required then anchor and display it
	if ( GetQuestLogRequiredMoney() > 0 ) then
		if ( numObjectives > 0 ) then
			ShaguQuest_QuestLogRequiredMoneyText:SetPoint("TOPLEFT", "ShaguQuest_QuestLogObjective"..numObjectives, "BOTTOMLEFT", 0, -4);
		else
			ShaguQuest_QuestLogRequiredMoneyText:SetPoint("TOPLEFT", "ShaguQuest_QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
		end
		
		MoneyFrame_Update("ShaguQuest_QuestLogRequiredMoneyFrame", GetQuestLogRequiredMoney());
		
		if ( GetQuestLogRequiredMoney() > GetMoney() ) then
			-- Not enough money
			ShaguQuest_QuestLogRequiredMoneyText:SetTextColor(0, 0, 0);
			SetMoneyFrameColor("ShaguQuest_QuestLogRequiredMoneyFrame", 1.0, 0.1, 0.1);
		else
			ShaguQuest_QuestLogRequiredMoneyText:SetTextColor(0.2, 0.2, 0.2);
			SetMoneyFrameColor("ShaguQuest_QuestLogRequiredMoneyFrame", 1.0, 1.0, 1.0);
		end
		ShaguQuest_QuestLogRequiredMoneyText:Show();
		ShaguQuest_QuestLogRequiredMoneyFrame:Show();
	else
		ShaguQuest_QuestLogRequiredMoneyText:Hide();
		ShaguQuest_QuestLogRequiredMoneyFrame:Hide();
	end

	if ( GetQuestLogRequiredMoney() > 0 ) then
		ShaguQuest_QuestLogDescriptionTitle:SetPoint("TOPLEFT", "ShaguQuest_QuestLogRequiredMoneyText", "BOTTOMLEFT", 0, -10);
	elseif ( numObjectives > 0 ) then
		ShaguQuest_QuestLogDescriptionTitle:SetPoint("TOPLEFT", "ShaguQuest_QuestLogObjective"..numObjectives, "BOTTOMLEFT", 0, -10);
	else
		if ( questTimer ) then
			ShaguQuest_QuestLogDescriptionTitle:SetPoint("TOPLEFT", "ShaguQuest_QuestLogTimerText", "BOTTOMLEFT", 0, -10);
		else
			ShaguQuest_QuestLogDescriptionTitle:SetPoint("TOPLEFT", "ShaguQuest_QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
		end
	end
	if ( questDescription ) then
		ShaguQuest_QuestLogQuestDescription:SetText(questDescription);
		QuestFrame_SetAsLastShown(ShaguQuest_QuestLogQuestDescription);
	end
	local numRewards = GetNumQuestLogRewards();
	local numChoices = GetNumQuestLogChoices();
	local money = GetQuestLogRewardMoney();

	if ( (numRewards + numChoices + money) > 0 ) then
		ShaguQuest_QuestLogRewardTitleText:Show();
		QuestFrame_SetAsLastShown(ShaguQuest_QuestLogRewardTitleText);
	else
		ShaguQuest_QuestLogRewardTitleText:Hide();
	end

	QuestFrameItems_Update("QuestLog");
	if ( not doNotScroll ) then
		ShaguQuest_QuestLogDetailScrollFrameScrollBar:SetValue(0);
	end
	ShaguQuest_QuestLogDetailScrollFrame:UpdateScrollChildRect();
end



local normal_QuestFrame_SetAsLastShown = QuestFrame_SetAsLastShown;
function QuestFrame_SetAsLastShown(frame, spacerFrame)
	if ( not spacerFrame ) then
		spacerFrame = ShaguQuest_QuestLogSpacerFrame;
	end
	spacerFrame:SetPoint("TOP", frame, "BOTTOM", 0, 0);
end



local normal_QuestLogTitleButton_OnClick = QuestLogTitleButton_OnClick;
function QuestLogTitleButton_OnClick(button)
	local questName = this:GetText();
	local questIndex = this:GetID() + FauxScrollFrame_GetOffset(ShaguQuest_QuestLogListScrollFrame);
	
	if(button == "LeftButton") then
		if ( IsShiftKeyDown() ) then
			if( IsControlKeyDown() ) then
				if ( this.isHeader ) then
					return;
				end
				if ( not ChatFrameEditBox:IsVisible() ) then
					ShaguQuest_ClearTracker();
					AddQuestWatch(questIndex);
					QuestWatch_Update();
				end
			else
				-- If header then return
				local questLogTitleText, isHeader, isCollapsed, firstTrackable, lastTrackable, numTracked, numUntracked;
				lastTrackable = -1;
				numTracked = 0;
				numUntracked = 0;
				local track = false;
				if ( this.isHeader ) then
	
					for i=1, GetNumQuestLogEntries(), 1 do
						questLogTitleText, _, _, isHeader, isCollapsed, _ = GetQuestLogTitle(i);
						if ( questLogTitleText == questName ) then
							track = true;
							firstTrackable = i+1;
						elseif ( track ) then
							if ( not isHeader ) then
								if( IsQuestWatched(i) ) then
									numTracked = numTracked+1;
									RemoveQuestWatch(i);
								else
									numUntracked = numUntracked+1;
									RemoveQuestWatch(i);
								end;
							end
							if ( isHeader and questLogTitleText ~= questName ) then
								lastTrackable = i-1;
								break;
							end
						end
					end
					if ( lastTrackable == -1 ) then
						lastTrackable = GetNumQuestLogEntries();
					end
					if ( numUntracked == 0 ) then
						-- Untrack all
						for i=firstTrackable, lastTrackable, 1 do
							RemoveQuestWatch(i);
						end
						QuestWatch_Update();
					else
						-- Track all
						for i=firstTrackable, lastTrackable, 1 do
							AddQuestWatch(i);
						end
						QuestWatch_Update();
					end
					QuestLog_Update();
					return;
				end
				
				-- Otherwise try to track it or put it into chat
				if ( ChatFrameEditBox:IsVisible() ) then
					-- Trim leading whitespace
					ChatFrameEditBox:Insert(gsub(this:GetText(), " *(.*)", "%1"));
				else
					-- Shift-click toggles quest-watch on this quest.
					if ( IsQuestWatched(questIndex) ) then
						RemoveQuestWatch(questIndex);
						QuestWatch_Update();
					else
						--[[ Set error if no objectives
						if ( GetNumQuestLeaderBoards(questIndex) == 0 ) then
							UIErrorsFrame:AddMessage(QUEST_WATCH_NO_OBJECTIVES, 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
							return;
						end]]-- 
						-- Set an error message if trying to show too many quests
						if ( GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS ) then
							UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS), 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
							return;
						end
						AddQuestWatch(questIndex);
						QuestWatch_Update();
					end
				end
			end
		end
		
		if(this.isHeader) then
			if ( ShaguQuest_OrganizeFrame:IsVisible() ) then
				ShaguQuest_OrganizeFrame_Text:SetText(questName);
				ShaguQuest_OrganizeFrame_Text:ClearFocus();
				
				ShaguQuest_OrganizeFunctions(questName);
				ShaguQuest_OrganizeFrame:Hide();
			end
		end
		
	end
	
	if(QuestLog_SetSelection(questIndex) == 1) then
		if(not ShaguQuest_QuestLogFrame_Description:IsVisible() and not IsShiftKeyDown() and not IsControlKeyDown() and QuestlogOptions[ShaguQuest_Player].RestoreUponSelect == 1) then
			ShaguQuest_Maximize();
		end
	end
	
	
	if(button == "LeftButton") then
		if( not IsShiftKeyDown() and IsControlKeyDown() ) then
			if ( ChatFrameEditBox:IsVisible() ) then
				AddQuestStatusToChatFrame(questIndex, questName);
			end
		end
	else
		if ( not this.isHeader ) then
			if ( ShaguQuest_IsQuestWatched(questIndex) ) then
				ShaguQuest_Organize_Popup_Track_Text:SetText(ShaguQuest_POPUP_UNTRACK);
			else
				ShaguQuest_Organize_Popup_Track_Text:SetText(ShaguQuest_POPUP_TRACK);
			end
			ShaguQuest_Organize_Popup:ClearAllPoints();
			ShaguQuest_Organize_Popup:SetPoint("TOPLEFT", this, "TOPLEFT", 24, 0);
			ShaguQuest_Organize_Popup:Raise();
			ShaguQuest_Organize_Popup:Show();
		end
	end

	QuestLog_Update();
end


function AddQuestStatusToChatFrame(questIndex, questName)
	local text, type, finished;
	if ( ChatFrameEditBox:IsVisible() ) then		
		local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questIndex);
		
		if(isComplete) then
			ChatFrameEditBox:Insert("(Complete) ");
		end
		
		ChatFrameEditBox:Insert(questLogTitleText);
		
		local numObjectives = GetNumQuestLeaderBoards();
		if (numObjectives>0) then
			ChatFrameEditBox:Insert(": ");
			for i=1, numObjectives, 1 do
				text, type, finished = GetQuestLogLeaderBoard(i);
				if(not text or strlen(text) == 0) then
					text = type;
				end
				ChatFrameEditBox:Insert(text);
				if(i < numObjectives) then
					ChatFrameEditBox:Insert(", ");
				end
			end
		end		
	end
end


-- Only called on load
function ManageQuestHeaders()
	QuestLog_SetSelection(GetQuestLogSelection());
	ShaguQuest_Temp.hasManaged = true;
	if(QuestlogOptions[ShaguQuest_Player].HeaderList) then
					
		local questLogTitleText, isHeader, isCollapsed;
		local numHeaders = table.getn(QuestlogOptions[ShaguQuest_Player].HeaderList);
		local numEntries = GetNumQuestLogEntries();
		
		if(numHeaders > 0) then
		
			for i=numEntries, 1, -1 do
				questLogTitleText, _, _, isHeader, isCollapsed = GetQuestLogTitle(i);
				
				if(isHeader) then
					for j=1, numHeaders, 1 do
						if(questLogTitleText == QuestlogOptions[ShaguQuest_Player].HeaderList[j]) then
							CollapseQuestHeader(i);
						end
					end
				end
				
			end
			
		end
	end
end

function MakeQuestHeaderList()
	QuestlogOptions[ShaguQuest_Player].HeaderList = {};

	local numEntries = GetNumQuestLogEntries();
	local questLogTitleText, isHeader, isCollapsed;
	
	for j=numEntries, 1, -1 do
		questLogTitleText, _, _, isHeader, isCollapsed = GetQuestLogTitle(j);
		if (isHeader and isCollapsed) then
			table.insert(QuestlogOptions[ShaguQuest_Player].HeaderList, questLogTitleText);
		end
	end
end




local normal_QuestLog_UpdatePartyInfoTooltip = QuestLog_UpdatePartyInfoTooltip;

function QuestLog_UpdatePartyInfoTooltip()
	local index = this:GetID() + FauxScrollFrame_GetOffset(ShaguQuest_QuestLogListScrollFrame);
	local numPartyMembers = GetNumPartyMembers();
	if ( numPartyMembers == 0 or this.isHeader ) then
		return;
	end
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	local questLogTitleText = GetQuestLogTitle(index);
	GameTooltip:SetText(questLogTitleText);

	local partyMemberOnQuest;
	for i=1, numPartyMembers do
		if ( IsUnitOnQuest(index, "party"..i) ) then
			if ( not partyMemberOnQuest ) then
				GameTooltip:AddLine(HIGHLIGHT_FONT_COLOR_CODE..PARTY_QUEST_STATUS_ON..FONT_COLOR_CODE_CLOSE);
				partyMemberOnQuest = 1;
			end
			GameTooltip:AddLine(LIGHTYELLOW_FONT_COLOR_CODE..UnitName("party"..i)..FONT_COLOR_CODE_CLOSE);
		end
	end
	if ( not partyMemberOnQuest ) then
		GameTooltip:AddLine(HIGHLIGHT_FONT_COLOR_CODE..PARTY_QUEST_STATUS_NONE..FONT_COLOR_CODE_CLOSE);
	end
	GameTooltip:Show();
end


local normal_QuestLogCollapseAllButton_OnClick = QuestLogCollapseAllButton_OnClick;
function QuestLogCollapseAllButton_OnClick()
	if (this.collapsed) then
		this.collapsed = nil;
		ExpandQuestHeader(0);
		MakeQuestHeaderList();
	else
		this.collapsed = 1;
		ShaguQuest_QuestLogListScrollFrameScrollBar:SetValue(0);
		CollapseQuestHeader(0);
		MakeQuestHeaderList();
	end
end


old_GetQuestLogTitle = GetQuestLogTitle;
function GetQuestLogTitle(questIndex)
	local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete;
	
	
	if (not ShaguQuest_UpdateDB()) then
		questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete =  old_GetQuestLogTitle(questIndex);
	end
	if(ShaguQuest_Temp.savedQuestIDMap and ShaguQuest_Temp.savedQuestIDMap[questIndex]) then
		if(ShaguQuest_Temp.savedQuestIDMap[questIndex].questID) then
			questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = old_GetQuestLogTitle(ShaguQuest_Temp.savedQuestIDMap[questIndex].questID);
		else
			return ShaguQuest_Temp.savedQuestIDMap[questIndex].header, 0, nil, true, nil, nil;
		end
	end
	
	if ( isHeader  or not questLogTitleText ) then
	else
		if ( not QuestLevel_Quest2Level[questLogTitleText] ) then
			local queststorage = "";
			queststorage = QuestLevel_StorageSet(queststorage, "levelmin", level);
			if (questTag ~= NIL) then
				queststorage = QuestLevel_StorageSet(queststorage, "elite", "x");
			end
			QuestLevel_Quest2Level[questLogTitleText] = queststorage;
		else
			local queststorage = QuestLevel_Quest2Level[questLogTitleText];
			local levelmin = tonumber(QuestLevel_StorageGet(queststorage, "levelmin"));
			local levelmax = QuestLevel_StorageGet(queststorage, "levelmax");
			if ( levelmax == nil ) then
				levelmax = levelmin;
			else
				levelmax = tonumber(levelmax);
			end
			if (levelmin > level) then
				queststorage = QuestLevel_StorageSet(queststorage, "levelmin", level);
				queststorage = QuestLevel_StorageSet(queststorage, "levelmax", levelmax);
			end
			if (levelmax < level) then
				queststorage = QuestLevel_StorageSet(queststorage, "levelmax", level);
			end
			if (questTag ~= NIL and QuestLevel_StorageGet(queststorage, "elite") == nil) then
				queststorage = QuestLevel_StorageSet(queststorage, "elite", "");
			end
			QuestLevel_Quest2Level[questLogTitleText] = queststorage;
		end
	end
	
	return questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete;
end




local old_QuestFrameItems_Update = QuestFrameItems_Update;
function QuestFrameItems_Update(questState)
	local isQuestLog = 0;
	if ( questState == "QuestLog" ) then
		isQuestLog = 1;
		questState = "ShaguQuest_QuestLog";
	end
	local numQuestRewards;
	local numQuestChoices;
	local numQuestSpellRewards = 0;
	local money;
	local spacerFrame;
	if ( isQuestLog == 1 ) then
		numQuestRewards = GetNumQuestLogRewards();
		numQuestChoices = GetNumQuestLogChoices();
		if ( GetQuestLogRewardSpell() ) then
			numQuestSpellRewards = 1;
		end
		money = GetQuestLogRewardMoney();
		spacerFrame = ShaguQuest_QuestLogSpacerFrame;
	else
		numQuestRewards = GetNumQuestRewards();
		numQuestChoices = GetNumQuestChoices();
		if ( GetRewardSpell() ) then
			numQuestSpellRewards = 1;
		end
		money = GetRewardMoney();
		spacerFrame = QuestSpacerFrame;
	end

	local totalRewards = numQuestRewards + numQuestChoices + numQuestSpellRewards;
	local questItemName = questState.."Item";
	local material = QuestFrame_GetMaterial();
	local  questItemReceiveText = getglobal(questState.."ItemReceiveText")
	if ( totalRewards == 0 and money == 0 ) then
		getglobal(questState.."RewardTitleText"):Hide();
	else
		getglobal(questState.."RewardTitleText"):Show();
		QuestFrame_SetTitleTextColor(getglobal(questState.."RewardTitleText"), material);
		QuestFrame_SetAsLastShown(getglobal(questState.."RewardTitleText"), spacerFrame);
	end
	if ( money == 0 ) then
		getglobal(questState.."MoneyFrame"):Hide();
	else
		getglobal(questState.."MoneyFrame"):Show();
		QuestFrame_SetAsLastShown(getglobal(questState.."MoneyFrame"), spacerFrame);
		MoneyFrame_Update(questState.."MoneyFrame", money);
	end
	
	for i=totalRewards + 1, MAX_NUM_ITEMS, 1 do
		getglobal(questItemName..i):Hide();
	end
	local questItem, name, texture, quality, isUsable, numItems = 1;
	if ( numQuestChoices > 0 ) then
		getglobal(questState.."ItemChooseText"):Show();
		QuestFrame_SetTextColor(getglobal(questState.."ItemChooseText"), material);
		QuestFrame_SetAsLastShown(getglobal(questState.."ItemChooseText"), spacerFrame);
		for i=1, numQuestChoices, 1 do	
			questItem = getglobal(questItemName..i);
			questItem.type = "choice";
			numItems = 1;
			if ( isQuestLog == 1 ) then
				name, texture, numItems, quality, isUsable = GetQuestLogChoiceInfo(i);
			else
				name, texture, numItems, quality, isUsable = GetQuestItemInfo(questItem.type, i);
			end
			questItem:SetID(i)
			questItem:Show();
			-- For the tooltip
			questItem.rewardType = "item"
			QuestFrame_SetAsLastShown(questItem, spacerFrame);
			getglobal(questItemName..i.."Name"):SetText(name);
			SetItemButtonCount(questItem, numItems);
			SetItemButtonTexture(questItem, texture);
			if ( isUsable ) then
				SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0);
			else
				SetItemButtonTextureVertexColor(questItem, 0.9, 0, 0);
				SetItemButtonNameFrameVertexColor(questItem, 0.9, 0, 0);
			end
			if ( i > 1 ) then
				if ( mod(i,2) == 1 ) then
					questItem:SetPoint("TOPLEFT", questItemName..(i - 2), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..(i - 1), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", questState.."ItemChooseText", "BOTTOMLEFT", -3, -5);
			end
			
		end
	else
		getglobal(questState.."ItemChooseText"):Hide();
	end
	local rewardsCount = 0;
	if ( numQuestRewards > 0 or money > 0 or numQuestSpellRewards > 0) then
		QuestFrame_SetTextColor(questItemReceiveText, material);
		-- Anchor the reward text differently if there are choosable rewards
		if ( numQuestChoices > 0  ) then
			questItemReceiveText:SetText(TEXT(REWARD_ITEMS));
			local index = numQuestChoices;
			if ( mod(index, 2) == 0 ) then
				index = index - 1;
			end
			questItemReceiveText:SetPoint("TOPLEFT", questItemName..index, "BOTTOMLEFT", 3, -5);
		else 
			questItemReceiveText:SetText(TEXT(REWARD_ITEMS_ONLY));
			questItemReceiveText:SetPoint("TOPLEFT", questState.."RewardTitleText", "BOTTOMLEFT", 3, -5);
		end
		questItemReceiveText:Show();
		QuestFrame_SetAsLastShown(questItemReceiveText, spacerFrame);
		-- Setup mandatory rewards
		for i=1, numQuestRewards, 1 do
			questItem = getglobal(questItemName..(i + numQuestChoices));
			questItem.type = "reward";
			numItems = 1;
			if ( isQuestLog == 1 ) then
				name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i);
			else
				name, texture, numItems, quality, isUsable = GetQuestItemInfo(questItem.type, i);
			end
			questItem:SetID(i)
			questItem:Show();
			-- For the tooltip
			questItem.rewardType = "item";
			QuestFrame_SetAsLastShown(questItem, spacerFrame);
			getglobal(questItemName..(i + numQuestChoices).."Name"):SetText(name);
			SetItemButtonCount(questItem, numItems);
			SetItemButtonTexture(questItem, texture);
			if ( isUsable ) then
				SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0);
			else
				SetItemButtonTextureVertexColor(questItem, 0.5, 0, 0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 0, 0);
			end
			
			if ( i > 1 ) then
				if ( mod(i,2) == 1 ) then
					questItem:SetPoint("TOPLEFT", questItemName..((i + numQuestChoices) - 2), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..((i + numQuestChoices) - 1), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", questState.."ItemReceiveText", "BOTTOMLEFT", -3, -5);
			end
			rewardsCount = rewardsCount + 1;
		end
		-- Setup spell reward
		if ( numQuestSpellRewards > 0 ) then
			if ( isQuestLog == 1 ) then
				texture, name = GetQuestLogRewardSpell();
			else
				texture, name = GetRewardSpell();
			end
			questItem = getglobal(questItemName..(rewardsCount + numQuestChoices + 1));
			questItem:Show();
			-- For the tooltip
			questItem.rewardType = "spell";
			SetItemButtonCount(questItem, 0);
			SetItemButtonTexture(questItem, texture);
			getglobal(questItemName..(rewardsCount + numQuestChoices + 1).."Name"):SetText(name);
			if ( rewardsCount > 0 ) then
				if ( mod(rewardsCount,2) == 0 ) then
					questItem:SetPoint("TOPLEFT", questItemName..((rewardsCount + numQuestChoices) - 1), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..((rewardsCount + numQuestChoices)), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", questState.."ItemReceiveText", "BOTTOMLEFT", -3, -5);
			end
		end
	else	
		questItemReceiveText:Hide();
	end
	if ( questState == "QuestReward" ) then
		QuestFrameCompleteQuestButton:Enable();
		QuestFrameRewardPanel.itemChoice = 0;
		QuestRewardItemHighlight:Hide();
	end
end


function QuestLogFrame_LockCorner()
	local Left = ShaguQuest_QuestLogFrame:GetLeft();
	local Top = ShaguQuest_QuestLogFrame:GetTop();
	if (Left and Top) then
		ShaguQuest_QuestLogFrame:ClearAllPoints();
		ShaguQuest_QuestLogFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", Left , Top);
		QuestlogOptions[ShaguQuest_Player].LogLockPoints = {};
		QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointone = Left;
		QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointtwo = Top;
	elseif (QuestlogOptions[ShaguQuest_Player].LogLockPoints and
					QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointone and
					QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointtwo) then
		ShaguQuest_QuestLogFrame:ClearAllPoints();
		ShaguQuest_QuestLogFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointone,QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointtwo);
	end
end



function LookForCompletedQuests(ding)
	if ( not QuestlogOptions[ShaguQuest_Player].CompletedQuests ) then
		QuestlogOptions[ShaguQuest_Player].CompletedQuests = {};
	end

	local questID;
	local numEntries = GetNumQuestLogEntries();
	local questTitle, isComplete, isHeader;
	
	for i=1, numEntries, 1 do
		questID = i;
		questTitle, _, _, isHeader, _, isComplete = GetQuestLogTitle(questID);
		
		if(QuestlogOptions[ShaguQuest_Player].CompletedQuests[questTitle]) then
			QuestlogOptions[ShaguQuest_Player].CompletedQuests[questTitle].isOk = true;
		else
			QuestlogOptions[ShaguQuest_Player].CompletedQuests[questTitle] = {};
			QuestlogOptions[ShaguQuest_Player].CompletedQuests[questTitle].isOk = true;
		end
		
		if ( (not isHeader) and isComplete and ( not QuestlogOptions[ShaguQuest_Player].CompletedQuests[questTitle].isCompleted ) ) then
			QuestlogOptions[ShaguQuest_Player].CompletedQuests[questTitle].isCompleted = true;
			if( (ding == nil) or (ding~=false)) then
				UIErrorsFrame:AddMessage(questTitle.." Completed!", 1.0, 0.8, 0.0, 1.0, UIERRORS_HOLD_TIME);
				PlaySound("GnomeExploration");
			end
		end
	end
	
	--clean up
	for quest in QuestlogOptions[ShaguQuest_Player].CompletedQuests do
		if ( QuestlogOptions[ShaguQuest_Player].CompletedQuests[quest].isOk ) then
			QuestlogOptions[ShaguQuest_Player].CompletedQuests[quest].isOk = false;
		else
			QuestlogOptions[ShaguQuest_Player].CompletedQuests[quest] = nil;
		end
	end
end
