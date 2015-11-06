SLASH_EXTENDEDQUESTLOG1 = "/eql";

function EQL_Options_OnLoad()
	SlashCmdList["EXTENDEDQUESTLOG"] = function(msg)
		ShaguQuest_SlashCmd(msg);
	end
  this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("QUEST_LOG_UPDATE");
end

-- Let's see how of theese are needed
old_GetNumQuestLogEntries = GetNumQuestLogEntries;
-- local existingGetQuestLogTitle = GetQuestLogTitle;
old_SelectQuestLogEntry = SelectQuestLogEntry;
old_GetQuestLogSelection = GetQuestLogSelection;
old_ExpandQuestHeader = ExpandQuestHeader;
old_CollapseQuestHeader = CollapseQuestHeader;
old_IsUnitOnQuest = IsUnitOnQuest;
-- local existingIsQuestWatched = IsQuestWatched;
-- local existingAddQuestWatch = AddQuestWatch;
-- local existingRemoveQuestWatch = RemoveQuestWatch;
-- local existingGetQuestIndexForWatch = GetQuestIndexForWatch;
old_GetNumQuestLeaderBoards = GetNumQuestLeaderBoards;
old_GetQuestLogLeaderBoard = GetQuestLogLeaderBoard;

function EQL_Options_OnEvent(event)
	-- Only for organizer...
	if ( event == "QUEST_LOG_UPDATE" ) then
		if(not ShaguQuest_Temp.GotQuestLogUpdate) then
			ShaguQuest_Temp.GotQuestLogUpdate = 1;
			ShaguQuest_RefreshOtherQuestDisplays();
			return;
		end
		ShaguQuest_UpdateDB();
	end
	
	if (event == "VARIABLES_LOADED") then
		
		EQL_Options_SetStates();
					
	end
end



function EQL_Options_SetStates()
		if(QuestlogOptions[ShaguQuest_Player].ShowQuestLevels == 1) then
			ShaguQuest_OptionsFrame_Checkbox_ShowQuestLevels:SetChecked(1);
			ShaguQuest_OptionsFrame_Checkbox_QuestLevelsOnlyInLog:Enable();
		else
			ShaguQuest_OptionsFrame_Checkbox_ShowQuestLevels:SetChecked(0);
			ShaguQuest_OptionsFrame_Checkbox_QuestLevelsOnlyInLog:Disable();
		end
		
		if(QuestlogOptions[ShaguQuest_Player].RestoreUponSelect == 1) then
			ShaguQuest_OptionsFrame_Checkbox_RestoreUponSelect:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_RestoreUponSelect:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].MinimizeUponClose == 1) then
			ShaguQuest_OptionsFrame_Checkbox_MinimizeUponClose:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_MinimizeUponClose:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].CustomZoneColor == 1) then
			ShaguQuest_OptionsFrame_Checkbox_CustomZoneColor:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_CustomZoneColor:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].CustomHeaderColor == 1) then
			ShaguQuest_OptionsFrame_Checkbox_CustomHeaderColor:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_CustomHeaderColor:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].CustomObjetiveColor == 1) then
			ShaguQuest_OptionsFrame_Checkbox_CustomObjectiveColor:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_CustomObjectiveColor:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].FadeHeaderColor == 1) then
			ShaguQuest_OptionsFrame_Checkbox_FadeHeaderColor:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_FadeHeaderColor:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].FadeObjectiveColor == 1) then
			ShaguQuest_OptionsFrame_Checkbox_FadeObjectiveColor:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_FadeObjectiveColor:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].CustomTrackerBGColor == 1) then
			ShaguQuest_OptionsFrame_Checkbox_CustomTrackerBGColor:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_CustomTrackerBGColor:SetChecked(0);
		end
		
		if ( QuestlogOptions[ShaguQuest_Player].ShowObjectiveMarkers == 1) then
			ShaguQuest_OptionsFrame_Checkbox_ShowObjectiveMarkers:SetChecked(1);
			ShaguQuest_OptionsFrame_Checkbox_UseTrackerListing:Enable();
			if(QuestlogOptions[ShaguQuest_Player].UseTrackerListing == 1) then
				ShaguQuest_OptionsFrame_Checkbox_Symbol1:Disable();
				ShaguQuest_OptionsFrame_Checkbox_Symbol2:Disable();
				ShaguQuest_OptionsFrame_Checkbox_Symbol3:Disable();
				ShaguQuest_OptionsFrame_Checkbox_Symbol4:Disable();
				ShaguQuest_OptionsFrame_Checkbox_List1:Enable();
				ShaguQuest_OptionsFrame_Checkbox_List2:Enable();
				ShaguQuest_OptionsFrame_Checkbox_List3:Enable();
				ShaguQuest_OptionsFrame_Checkbox_List4:Enable();
			else
				ShaguQuest_OptionsFrame_Checkbox_List1:Disable();
				ShaguQuest_OptionsFrame_Checkbox_List2:Disable();
				ShaguQuest_OptionsFrame_Checkbox_List3:Disable();
				ShaguQuest_OptionsFrame_Checkbox_List4:Disable();
				ShaguQuest_OptionsFrame_Checkbox_Symbol1:Enable();
				ShaguQuest_OptionsFrame_Checkbox_Symbol2:Enable();
				ShaguQuest_OptionsFrame_Checkbox_Symbol3:Enable();
				ShaguQuest_OptionsFrame_Checkbox_Symbol4:Enable();
			end
		else
			ShaguQuest_OptionsFrame_Checkbox_ShowObjectiveMarkers:SetChecked(0);
			ShaguQuest_OptionsFrame_Checkbox_UseTrackerListing:Disable();
			ShaguQuest_OptionsFrame_Checkbox_List1:Disable();
			ShaguQuest_OptionsFrame_Checkbox_List2:Disable();
			ShaguQuest_OptionsFrame_Checkbox_List3:Disable();
			ShaguQuest_OptionsFrame_Checkbox_List4:Disable();
			ShaguQuest_OptionsFrame_Checkbox_Symbol1:Disable();
			ShaguQuest_OptionsFrame_Checkbox_Symbol2:Disable();
			ShaguQuest_OptionsFrame_Checkbox_Symbol3:Disable();
			ShaguQuest_OptionsFrame_Checkbox_Symbol4:Disable();
		end
		
		if(QuestlogOptions[ShaguQuest_Player].UseTrackerListing == 1) then
			ShaguQuest_OptionsFrame_Checkbox_UseTrackerListing:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_UseTrackerListing:SetChecked(0);
		end
		
		ShaguQuest_OptionsFrame_Checkbox_List1:SetChecked(0);
		ShaguQuest_OptionsFrame_Checkbox_List2:SetChecked(0);
		ShaguQuest_OptionsFrame_Checkbox_List3:SetChecked(0);
		ShaguQuest_OptionsFrame_Checkbox_List4:SetChecked(0);
		ShaguQuest_OptionsFrame_Checkbox_Symbol1:SetChecked(0);
		ShaguQuest_OptionsFrame_Checkbox_Symbol2:SetChecked(0);
		ShaguQuest_OptionsFrame_Checkbox_Symbol3:SetChecked(0);
		ShaguQuest_OptionsFrame_Checkbox_Symbol4:SetChecked(0);
		
		getglobal("ShaguQuest_OptionsFrame_Checkbox_List"..(QuestlogOptions[ShaguQuest_Player].TrackerList+1)):SetChecked(1);
		getglobal("ShaguQuest_OptionsFrame_Checkbox_Symbol"..(QuestlogOptions[ShaguQuest_Player].TrackerSymbol+1)):SetChecked(1);
		
		
		ShaguQuest_OptionsFrame_Checkbox_ShowZones:SetChecked(0);
		ShaguQuest_OptionsFrame_Checkbox_SortTracker:Enable();
		ShaguQuest_OptionsFrame_Checkbox_SortTracker:SetChecked(0);
		
		if(QuestlogOptions[ShaguQuest_Player].ShowZonesInTracker == 1) then
			ShaguQuest_OptionsFrame_Checkbox_ShowZones:SetChecked(1);
			ShaguQuest_OptionsFrame_Checkbox_SortTracker:Disable();
			ShaguQuest_OptionsFrame_Checkbox_SortTracker:SetChecked(1);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].SortTrackerItems == 1) then
			ShaguQuest_OptionsFrame_Checkbox_SortTracker:SetChecked(1);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"]) then
			ShaguQuest_OptionsFrame_ColorSwatch_TrackerBGNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].r, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].g, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].b );
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["Zone"]) then
			ShaguQuest_OptionsFrame_ColorSwatch_ZoneNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["Zone"].r, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["Zone"].g, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["Zone"].b );
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"]) then
			ShaguQuest_OptionsFrame_ColorSwatch_Header_EmptyNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].r, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].g, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].b );
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"]) then
			ShaguQuest_OptionsFrame_ColorSwatch_Header_CompleteNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].r, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].g, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].b );
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"]) then
			ShaguQuest_OptionsFrame_ColorSwatch_Objective_EmptyNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"].r, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"].g, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"].b );
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"]) then
			ShaguQuest_OptionsFrame_ColorSwatch_Objective_CompleteNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"].r, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"].g, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"].b );
		end
		
		if(QuestlogOptions[ShaguQuest_Player].Color["Tooltip"]) then
			ShaguQuest_OptionsFrame_ColorSwatch_TooltipInfoNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["Tooltip"].r, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["Tooltip"].g, 
																																					 QuestlogOptions[ShaguQuest_Player].Color["Tooltip"].b );
		end
		
		
		
		if(QuestlogOptions[ShaguQuest_Player].LockTracker == 1) then
			ShaguQuest_OptionsFrame_Checkbox_LockTracker:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_LockTracker:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].AddNew == 1) then
			ShaguQuest_OptionsFrame_Checkbox_AddNew:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_AddNew:SetChecked(0);
		end
		
		ShaguQuest_OptionsFrame_Checkbox_RemoveFinished:SetChecked(0);
		ShaguQuest_OptionsFrame_Checkbox_MinimizeFinished:Enable();
		ShaguQuest_OptionsFrame_Checkbox_MinimizeFinished:SetChecked(0);
		
		if(QuestlogOptions[ShaguQuest_Player].RemoveFinished == 1) then
			ShaguQuest_OptionsFrame_Checkbox_RemoveFinished:SetChecked(1);
			ShaguQuest_OptionsFrame_Checkbox_MinimizeFinished:Disable();
		end
		
		if(QuestlogOptions[ShaguQuest_Player].MinimizeFinished == 1) then
			ShaguQuest_OptionsFrame_Checkbox_MinimizeFinished:SetChecked(1);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].AddUntracked == 1) then
			ShaguQuest_OptionsFrame_Checkbox_AddUntracked:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_AddUntracked:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].LockQuestLog == 1) then
			ShaguQuest_OptionsFrame_Checkbox_LockQuestLog:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_LockQuestLog:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].TrackerShowMinimizer == 1) then
			ShaguQuest_OptionsFrame_Checkbox_ShowMinimizer:SetChecked(1);
			ShaguQuest_Tracker_MinimizeButton:Show();
		else
			ShaguQuest_OptionsFrame_Checkbox_ShowMinimizer:SetChecked(0);
			ShaguQuest_Tracker_MinimizeButton:Hide();
			QuestlogOptions[ShaguQuest_Player].TrackerIsMinimized = 0;
		end
		
		-- new to 3.5.6
		
		if(QuestlogOptions[ShaguQuest_Player].AutoCompleteQuests == 1) then
			ShaguQuest_OptionsFrame_Checkbox_AutoCompleteQuests:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_AutoCompleteQuests:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].OnlyLevelsInLog == 1) then
			ShaguQuest_OptionsFrame_Checkbox_QuestLevelsOnlyInLog:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_QuestLevelsOnlyInLog:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].RemoveCompletedObjectives == 1) then
			ShaguQuest_OptionsFrame_Checkbox_HideCompletedObjectives:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_HideCompletedObjectives:SetChecked(0);
		end
		
		-- new to 3.5.9
		
		if(QuestlogOptions[ShaguQuest_Player].ItemTooltip == 1) then
			ShaguQuest_OptionsFrame_Checkbox_ShowItemTooltip:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_ShowItemTooltip:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].MobTooltip == 1) then
			ShaguQuest_OptionsFrame_Checkbox_ShowMobTooltip:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_ShowMobTooltip:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].InfoOnQuestCompletion == 1) then
			ShaguQuest_OptionsFrame_Checkbox_InfoOnQuestComplete:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_InfoOnQuestComplete:SetChecked(0);
		end
		
		if(QuestlogOptions[ShaguQuest_Player].CustomTooltipColor == 1) then
			ShaguQuest_OptionsFrame_Checkbox_CustomTooltipInfoColor:SetChecked(1);
		else
			ShaguQuest_OptionsFrame_Checkbox_CustomTooltipInfoColor:SetChecked(0);
		end
end




function ShaguQuest_Toggle_QuestLevels()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].ShowQuestLevels = 1;
		ShaguQuest_OptionsFrame_Checkbox_QuestLevelsOnlyInLog:Enable();
	else
		QuestlogOptions[ShaguQuest_Player].ShowQuestLevels = 0;
		ShaguQuest_OptionsFrame_Checkbox_QuestLevelsOnlyInLog:Disable();
	end
	
	QuestLog_Update();
	QuestWatch_Update();
end

function ShaguQuest_Toggle_RestoreUponSelect()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].RestoreUponSelect = 1;
	else
		QuestlogOptions[ShaguQuest_Player].RestoreUponSelect = 0;
	end
end

function ShaguQuest_Toggle_MinimizeUponClose()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].MinimizeUponClose = 1;
	else
		QuestlogOptions[ShaguQuest_Player].MinimizeUponClose = 0;
	end
end

function ShaguQuest_Toggle_CustomZoneColor()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].CustomZoneColor = 1;
	else
		QuestlogOptions[ShaguQuest_Player].CustomZoneColor = 0;
	end
	QuestWatch_Update();
end

function ShaguQuest_Toggle_CustomHeaderColor()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].CustomHeaderColor = 1;
	else
		QuestlogOptions[ShaguQuest_Player].CustomHeaderColor = 0;
	end
	QuestWatch_Update();
end

function ShaguQuest_Toggle_CustomObjectiveColor()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].CustomObjetiveColor = 1;
	else
		QuestlogOptions[ShaguQuest_Player].CustomObjetiveColor = 0;
	end
	QuestWatch_Update();
end


function ShaguQuest_Toggle_FadeHeaderColor()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].FadeHeaderColor = 1;
	else
		QuestlogOptions[ShaguQuest_Player].FadeHeaderColor = 0;
	end
	QuestWatch_Update();
end

function ShaguQuest_Toggle_FadeObjectiveColor()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].FadeObjectiveColor = 1;
	else
		QuestlogOptions[ShaguQuest_Player].FadeObjectiveColor = 0;
	end
	QuestWatch_Update();
end

function ShaguQuest_Toggle_CustomTrackerBGColor()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].CustomTrackerBGColor = 1;
	else
		QuestlogOptions[ShaguQuest_Player].CustomTrackerBGColor = 0;
	end
	TrackerBackground_Update();
end

--new to 3.5.6

function ShaguQuest_Toggle_ShowObjectiveMarkers()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].ShowObjectiveMarkers = 1;
		ShaguQuest_OptionsFrame_Checkbox_UseTrackerListing:Enable();
		ShaguQuest_Toggle_UseTrackerListing();
	else
		QuestlogOptions[ShaguQuest_Player].ShowObjectiveMarkers = 0;
		ShaguQuest_OptionsFrame_Checkbox_UseTrackerListing:Disable();
		ShaguQuest_OptionsFrame_Checkbox_Symbol1:Disable();
		ShaguQuest_OptionsFrame_Checkbox_Symbol2:Disable();
		ShaguQuest_OptionsFrame_Checkbox_Symbol3:Disable();
		ShaguQuest_OptionsFrame_Checkbox_Symbol4:Disable();
		ShaguQuest_OptionsFrame_Checkbox_List1:Disable();
		ShaguQuest_OptionsFrame_Checkbox_List2:Disable();
		ShaguQuest_OptionsFrame_Checkbox_List3:Disable();
		ShaguQuest_OptionsFrame_Checkbox_List4:Disable();
	end
	QuestWatch_Update();
end

-- end


function ShaguQuest_Toggle_UseTrackerListing()
	if (ShaguQuest_OptionsFrame_Checkbox_UseTrackerListing:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].UseTrackerListing = 1;
		ShaguQuest_OptionsFrame_Checkbox_List1:Enable();
		ShaguQuest_OptionsFrame_Checkbox_List2:Enable();
		ShaguQuest_OptionsFrame_Checkbox_List3:Enable();
		ShaguQuest_OptionsFrame_Checkbox_List4:Enable();
		
		ShaguQuest_OptionsFrame_Checkbox_Symbol1:Disable();
		ShaguQuest_OptionsFrame_Checkbox_Symbol2:Disable();
		ShaguQuest_OptionsFrame_Checkbox_Symbol3:Disable();
		ShaguQuest_OptionsFrame_Checkbox_Symbol4:Disable();
	else
		QuestlogOptions[ShaguQuest_Player].UseTrackerListing = 0;
		ShaguQuest_OptionsFrame_Checkbox_List1:Disable();
		ShaguQuest_OptionsFrame_Checkbox_List2:Disable();
		ShaguQuest_OptionsFrame_Checkbox_List3:Disable();
		ShaguQuest_OptionsFrame_Checkbox_List4:Disable();
		
		ShaguQuest_OptionsFrame_Checkbox_Symbol1:Enable();
		ShaguQuest_OptionsFrame_Checkbox_Symbol2:Enable();
		ShaguQuest_OptionsFrame_Checkbox_Symbol3:Enable();
		ShaguQuest_OptionsFrame_Checkbox_Symbol4:Enable();
	end
	QuestWatch_Update();
end

function ShaguQuest_Set_TrackerListing(id)
	QuestlogOptions[ShaguQuest_Player].TrackerList = id;
	ShaguQuest_OptionsFrame_Checkbox_List1:SetChecked(0);
	ShaguQuest_OptionsFrame_Checkbox_List2:SetChecked(0);
	ShaguQuest_OptionsFrame_Checkbox_List3:SetChecked(0);
	ShaguQuest_OptionsFrame_Checkbox_List4:SetChecked(0);
	getglobal("ShaguQuest_OptionsFrame_Checkbox_List"..(id+1)):SetChecked(1);
	QuestWatch_Update();
end

function ShaguQuest_Set_TrackerSymbol(id)
	QuestlogOptions[ShaguQuest_Player].TrackerSymbol = id;
	ShaguQuest_OptionsFrame_Checkbox_Symbol1:SetChecked(0);
	ShaguQuest_OptionsFrame_Checkbox_Symbol2:SetChecked(0);
	ShaguQuest_OptionsFrame_Checkbox_Symbol3:SetChecked(0);
	ShaguQuest_OptionsFrame_Checkbox_Symbol4:SetChecked(0);
	getglobal("ShaguQuest_OptionsFrame_Checkbox_Symbol"..(id+1)):SetChecked(1);
	QuestWatch_Update();
end


function ShaguQuest_Toggle_ShowZones()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].ShowZonesInTracker = 1;
		ShaguQuest_OptionsFrame_Checkbox_SortTracker:Disable();
		ShaguQuest_OptionsFrame_Checkbox_SortTracker:SetChecked(1);
	else
		QuestlogOptions[ShaguQuest_Player].ShowZonesInTracker = 0;
		ShaguQuest_OptionsFrame_Checkbox_SortTracker:Enable();
	end
	SortWatchedQuests();
	QuestWatch_Update();
end

function ShaguQuest_Toggle_SortTracker()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].SortTrackerItems = 1;
	else
		QuestlogOptions[ShaguQuest_Player].SortTrackerItems = 0;
	end
	SortWatchedQuests();
	QuestWatch_Update();
end





function ShaguQuest_OpenColorPicker(color, useOpacity, swatch)
	local c={};
	
	c.r = QuestlogOptions[ShaguQuest_Player].Color[color].r;
	c.g = QuestlogOptions[ShaguQuest_Player].Color[color].g;
	c.b = QuestlogOptions[ShaguQuest_Player].Color[color].b;
	if (useOpacity) then
		c.a = 1.0 - QuestlogOptions[ShaguQuest_Player].Color[color].a;
	end
	if(not c.a) then
		c.a = 0.0;
	end
	ShaguQuest_Temp.CurrentColor = color;
	ShaguQuest_Temp.CurrentSwatch = swatch;
	ColorPickerFrame.opacity = c.a;
	ColorPickerFrame:SetColorRGB(c.r, c.g, c.b);
	ColorPickerFrame.previousValues = {r = c.r, g = c.g, b = c.b, a = c.a};
	ColorPickerFrame.hasOpacity = useOpacity;
	ColorPickerFrame.func = ShaguQuest_SaveColorPicker;
	ColorPickerFrame.cancelFunc = ShaguQuest_CancelColorPicker;
	ColorPickerFrame:Show();
	ColorPickerFrame:Raise();
	
end

function ShaguQuest_SaveColorPicker()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	QuestlogOptions[ShaguQuest_Player].Color[ShaguQuest_Temp.CurrentColor].r = r;
	QuestlogOptions[ShaguQuest_Player].Color[ShaguQuest_Temp.CurrentColor].g = g;
	QuestlogOptions[ShaguQuest_Player].Color[ShaguQuest_Temp.CurrentColor].b = b;
	if (ColorPickerFrame.hasOpacity) then
		 QuestlogOptions[ShaguQuest_Player].Color[ShaguQuest_Temp.CurrentColor].a = 1.0 - OpacitySliderFrame:GetValue();
	end
	
	getglobal(ShaguQuest_Temp.CurrentSwatch.."NormalTexture"):SetVertexColor(r, g, b);
	
	if (not ColorPickerFrame:IsVisible()) then
		if (ShaguQuest_Temp.CurrentColor == "TrackerBG") then
			TrackerBackground_Update();
		else
			QuestWatch_Update();
		end
		ColorPickerFrame.func = nil;
		ColorPickerFrame.cancelFunc = nil;
	end
	
end

function ShaguQuest_CancelColorPicker(color)
	QuestlogOptions[ShaguQuest_Player].Color[ShaguQuest_Temp.CurrentColor].r = ColorPickerFrame.previousValues.r;
	QuestlogOptions[ShaguQuest_Player].Color[ShaguQuest_Temp.CurrentColor].g = ColorPickerFrame.previousValues.g;
	QuestlogOptions[ShaguQuest_Player].Color[ShaguQuest_Temp.CurrentColor].b = ColorPickerFrame.previousValues.b;
	if (ColorPickerFrame.hasOpacity) then
		 QuestlogOptions[ShaguQuest_Player].Color[ShaguQuest_Temp.CurrentColor].a = 1.0 - ColorPickerFrame.previousValues.a;
	end
	
	getglobal(ShaguQuest_Temp.CurrentSwatch.."NormalTexture"):SetVertexColor(ColorPickerFrame.previousValues.r, ColorPickerFrame.previousValues.g, ColorPickerFrame.previousValues.b);
	
	if (not ColorPickerFrame:IsVisible()) then
		if (ShaguQuest_Temp.CurrentColor == "TrackerBG") then
			TrackerBackground_Update();
		else
			QuestWatch_Update();
		end
		ColorPickerFrame.func = nil;
		ColorPickerFrame.cancelFunc = nil;
	end	
end

function TrackerBackground_Update()
	if(QuestlogOptions[ShaguQuest_Player].CustomTrackerBGColor == 1) then
	
		QuestWatchFrameBackdrop:SetBackdropBorderColor( QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].r,
																										QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].g,
																										QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].b );
		QuestWatchFrameBackdrop:SetBackdropColor( QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].r,
																										QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].g,
																										QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].b );																										
		QuestWatchFrameBackdrop:SetAlpha(QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].a);
		
	else
	
		QuestWatchFrameBackdrop:SetBackdropBorderColor( TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,
																										TOOLTIP_DEFAULT_BACKGROUND_COLOR.g,
																										TOOLTIP_DEFAULT_BACKGROUND_COLOR.b );
		QuestWatchFrameBackdrop:SetBackdropColor( TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,
																										TOOLTIP_DEFAULT_BACKGROUND_COLOR.g,
																										TOOLTIP_DEFAULT_BACKGROUND_COLOR.b );																							
		QuestWatchFrameBackdrop:SetAlpha(0.0);
		
	end
end



function ShaguQuest_Toggle_LockTracker()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].LockTracker = 1;
		ShaguQuest_QuestWatchFrame:SetUserPlaced(0);
		ShaguQuest_QuestWatchFrame:RegisterForDrag(0);
		ShaguQuest_QuestWatchFrame:SetMovable(false);
		ShaguQuest_QuestWatchFrame:EnableMouse(false);
	else
		QuestlogOptions[ShaguQuest_Player].LockTracker = 0;
		ShaguQuest_QuestWatchFrame:SetMovable(true);
		ShaguQuest_QuestWatchFrame:EnableMouse(true);
		ShaguQuest_QuestWatchFrame:SetUserPlaced(1);
		ShaguQuest_QuestWatchFrame:RegisterForDrag("LeftButton");
	end
end

function ShaguQuest_RestoreTracker()
	ShaguQuest_QuestWatchFrame:ClearAllPoints();
	ShaguQuest_QuestWatchFrame:SetPoint("TOPRIGHT","MinimapCluster","BOTTOMRIGHT",-100,10);
	QuestWatchFrame_LockCornerForGrowth();
end

function ShaguQuest_RestoreColors()
	QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"] = {	r = TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,
																													g = TOOLTIP_DEFAULT_BACKGROUND_COLOR.g,
																													b = TOOLTIP_DEFAULT_BACKGROUND_COLOR.b,
																													a = 0.0};
																													
	QuestlogOptions[ShaguQuest_Player].Color["Zone"] = {r = 1.0, g = 1.0, b = 1.0};
	QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"] = {r = 0.75, g = 0.61, b = 0.0};
	QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"] = {r = NORMAL_FONT_COLOR.r, g = NORMAL_FONT_COLOR.g, b = NORMAL_FONT_COLOR.b};
	QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"] = {r = 0.8, g = 0.8, b = 0.8};
	QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"] = {r = HIGHLIGHT_FONT_COLOR.r, g = HIGHLIGHT_FONT_COLOR.g, b = HIGHLIGHT_FONT_COLOR.b};
	QuestlogOptions[ShaguQuest_Player].Color["Tooltip"] = {r = 1.0, g = 0.8, b = 0.0};

	if(QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"]) then
		ShaguQuest_OptionsFrame_ColorSwatch_TrackerBGNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].r, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].g, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].b );
	end
	
	if(QuestlogOptions[ShaguQuest_Player].Color["Zone"]) then
		ShaguQuest_OptionsFrame_ColorSwatch_ZoneNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["Zone"].r, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["Zone"].g, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["Zone"].b );
	end
	
	if(QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"]) then
		ShaguQuest_OptionsFrame_ColorSwatch_Header_EmptyNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].r, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].g, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].b );
	end
	
	if(QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"]) then
		ShaguQuest_OptionsFrame_ColorSwatch_Header_CompleteNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].r, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].g, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].b );
	end
	
	if(QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"]) then
		ShaguQuest_OptionsFrame_ColorSwatch_Objective_EmptyNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"].r, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"].g, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"].b );
	end
	
	if(QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"]) then
		ShaguQuest_OptionsFrame_ColorSwatch_Objective_CompleteNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"].r, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"].g, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"].b );
	end
	
	if(QuestlogOptions[ShaguQuest_Player].Color["Tooltip"]) then
		ShaguQuest_OptionsFrame_ColorSwatch_TooltipInfoNormalTexture:SetVertexColor( QuestlogOptions[ShaguQuest_Player].Color["Tooltip"].r, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["Tooltip"].g, 
																																				 QuestlogOptions[ShaguQuest_Player].Color["Tooltip"].b );
	end
	
	TrackerBackground_Update();
	QuestWatch_Update();
end



function ShaguQuest_Toggle_AddNew()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].AddNew = 1
	else
		QuestlogOptions[ShaguQuest_Player].AddNew = 0;
	end
end

function ShaguQuest_Toggle_RemoveFinished()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].RemoveFinished = 1
		ShaguQuest_OptionsFrame_Checkbox_MinimizeFinished:Disable();
	else
		QuestlogOptions[ShaguQuest_Player].RemoveFinished = 0;
		ShaguQuest_OptionsFrame_Checkbox_MinimizeFinished:Enable();
	end
	MagageTrackedQuests();
	QuestLog_Update();
	QuestWatch_Update();
end

function ShaguQuest_Toggle_MinimizeFinished()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].MinimizeFinished = 1
	else
		QuestlogOptions[ShaguQuest_Player].MinimizeFinished = 0;
	end
	QuestWatch_Update();
end

function ShaguQuest_Toggle_AddUntracked()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].AddUntracked = 1
	else
		QuestlogOptions[ShaguQuest_Player].AddUntracked = 0;
	end	
end




function ShaguQuest_Toggle_LockQuestLog()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].LockQuestLog = 1;
		ShaguQuest_QuestLogFrame:RegisterForDrag(0);
		ShaguQuest_QuestLogFrame_Description:RegisterForDrag(0);
	else
		QuestlogOptions[ShaguQuest_Player].LockQuestLog = 0;
		ShaguQuest_QuestLogFrame:RegisterForDrag("LeftButton");
		ShaguQuest_QuestLogFrame_Description:RegisterForDrag("LeftButton");
	end
end

function ShaguQuest_RestoreQuestLog()
	ShaguQuest_QuestLogFrame:ClearAllPoints();
	ShaguQuest_QuestLogFrame:SetPoint("TOPLEFT", 0, -104);
	QuestLogFrame_LockCorner();
end




-- Organizer
function ShaguQuest_SortComparison(value1, value2)
	if(value1.header == value2.header) then
		if(value1.level == value2.level) then
			return value1.title < value2.title;
		end
		return value1.level < value2.level;
	end
	return value1.header < value2.header;
end


function ShaguQuest_UpdateDB()
	if(not ShaguQuest_Temp.GotQuestLogUpdate) then
		return nil;
	end
	local numEntries, numQuests = old_GetNumQuestLogEntries();
	if(numEntries == ShaguQuest_Temp.lastExistingNumEntries) then
		return 1;
	end
	if(ShaguQuest_Temp.lastExistingNumEntries == -1 and numEntries < 1) then
		if(not ShaguQuest_Temp.reportedNoQuests) then
			ShaguQuest_Temp.reportedNoQuests = 1;
		end
		return nil;
	end
	if(ShaguQuest_Temp.reportedNoQuests) then
		ShaguQuest_Temp.reportedNoQuests = nil;
	end
	ShaguQuest_Temp.lastExistingNumEntries = numEntries;
	local index;
	for index in QuestlogOptions[ShaguQuest_Player].OrganizerSettings do
		QuestlogOptions[ShaguQuest_Player].OrganizerSettings[index].cleanup = 1;
	end
	local i;
	local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete;
	local sortData = {};
	local j = 1;
	local lastHeader = "NoHeader";
	for i=1, numEntries, 1 do
		questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = old_GetQuestLogTitle(i);
		if(isHeader) then
			lastHeader = questLogTitleText;
		else
			sortData[j] = {};
			if(QuestlogOptions[ShaguQuest_Player].OrganizerSettings[questLogTitleText]) then
				sortData[j].header = QuestlogOptions[ShaguQuest_Player].OrganizerSettings[questLogTitleText].header;
				QuestlogOptions[ShaguQuest_Player].OrganizerSettings[questLogTitleText].cleanup = nil;
			else
				sortData[j].header = lastHeader;
			end
			sortData[j].level = level;
			sortData[j].title = questLogTitleText;
			sortData[j].questID = i;
			j = j + 1;
		end
	end
	table.sort(sortData, ShaguQuest_SortComparison);
	ShaguQuest_Temp.savedNumQuests = j - 1;
	local selectedQuest = old_GetQuestLogSelection();
	ShaguQuest_Temp.savedSelectedQuest = selectedQuest;
	ShaguQuest_Temp.savedQuestIDMap = {};
	j = 1;
	lastHeader = nil;
	for i=1, ShaguQuest_Temp.savedNumQuests, 1 do
		if(sortData[i].header ~= lastHeader) then
			lastHeader = sortData[i].header;
			ShaguQuest_Temp.savedQuestIDMap[j] = {};
			ShaguQuest_Temp.savedQuestIDMap[j].header = lastHeader;
			j = j + 1;
		end
		ShaguQuest_Temp.savedQuestIDMap[j] = {};
		ShaguQuest_Temp.savedQuestIDMap[j].questID = sortData[i].questID;
		if(ShaguQuest_Temp.savedQuestIDMap[j].questID == ShaguQuest_Temp.selectedQuest) then
			ShaguQuest_Temp.savedSelectedQuest = j;
		end
		j = j + 1;
	end
	ShaguQuest_Temp.savedNumEntries = j - 1;
	for index in QuestlogOptions[ShaguQuest_Player].OrganizerSettings do
		if(QuestlogOptions[ShaguQuest_Player].OrganizerSettings[index].cleanup) then
			QuestlogOptions[ShaguQuest_Player].OrganizerSettings[index] = nil;
		end
	end
	return 1;
end

function ShaguQuest_RefreshOtherQuestDisplays()
	ShaguQuest_Temp.lastExistingNumEntries = -1;
	old_ExpandQuestHeader(0);
end



function FixGroupChangedQuest(title, headern)
	local temp, temp2, isHeader, foundQuest, header=nil;
	if(headern ~= nil) then header = headern end
	for i=1, GetNumQuestWatches(), 1 do
		temp = string.gsub(QuestlogOptions[ShaguQuest_Player].QuestWatches[i], ".+,%d+,", "");
		if(title == temp) then
			if(header == nil) then
				-- Find the header...
				foundQuest = false;
				for j=GetNumQuestLogEntries(), 1, -1 do
					temp2, _, _, isHeader = GetQuestLogTitle(j);
					if(not foundQuest and temp2 == title) then
						foundQuest = true;
					end
					if (foundQuest and isHeader) then
						header = temp2;
						break;
					end
				end
			end
			if (header == nil) then
				SortWatchedQuests();
				return;
			end
			temp2 = string.gsub(QuestlogOptions[ShaguQuest_Player].QuestWatches[i], ",%d+,.+", "");
			temp = header..string.gsub(QuestlogOptions[ShaguQuest_Player].QuestWatches[i], temp2, "");
			QuestlogOptions[ShaguQuest_Player].QuestWatches[i] = temp;
			SortWatchedQuests();
			return;
		end
	end
end

function ShaguQuest_OrganizeFunctions(command)
		if(not ShaguQuest_UpdateDB()) then
			return;
		end
		local questID = GetQuestLogSelection();
		if(not (questID and questID > 0)) then
			return;
		end
		if(command == "!!!resetall") then
			table.foreach (QuestlogOptions[ShaguQuest_Player].OrganizerSettings, function (key, v)
        QuestlogOptions[ShaguQuest_Player].OrganizerSettings[key] = nil;
				ShaguQuest_RefreshOtherQuestDisplays();
				FixGroupChangedQuest(key, nil);
				return nil;
      end);
			QuestlogOptions[ShaguQuest_Player].OrganizerSettings = {};
			ShaguQuest_RefreshOtherQuestDisplays();
		else
			local title = GetQuestLogTitle(questID);
			if(not title) then
				return;
			end
			if(command == "!!!reset") then
				QuestlogOptions[ShaguQuest_Player].OrganizerSettings[title] = nil;
				ShaguQuest_RefreshOtherQuestDisplays();
				FixGroupChangedQuest(title, nil);
			else
				QuestlogOptions[ShaguQuest_Player].OrganizerSettings[title] = {};
				QuestlogOptions[ShaguQuest_Player].OrganizerSettings[title].header = command;
				ShaguQuest_RefreshOtherQuestDisplays();
				FixGroupChangedQuest(title, command);
			end
		end
		ShaguQuest_RefreshOtherQuestDisplays();
end


function ShaguQuest_Toggle_Track()
	if ( ShaguQuest_IsQuestWatched(GetQuestLogSelection()) ) then
		ShaguQuest_RemoveQuestWatch(GetQuestLogSelection());
	else
		ShaguQuest_AddQuestWatch(GetQuestLogSelection());
	end
	QuestLog_Update();
	QuestWatch_Update();
end


function ShaguQuest_Organize_ShowNameWindow()
	ShaguQuest_OrganizeFrame:Show();
	ShaguQuest_OrganizeFrame:Raise();
	ShaguQuest_OrganizeFrame_Text:SetFocus();
end


function ShaguQuest_SlashCmd(msg)
	if (string.len(msg) > 0) then
		if(not ShaguQuest_UpdateDB()) then
			return;
		end
		local questID = GetQuestLogSelection();
		if(not (questID and questID > 0)) then
			return;
		end
		if(msg == "resetall") then
			table.foreach (QuestlogOptions[ShaguQuest_Player].OrganizerSettings, function (key, v)
        QuestlogOptions[ShaguQuest_Player].OrganizerSettings[key] = nil;
				ShaguQuest_RefreshOtherQuestDisplays();
				FixGroupChangedQuest(key, nil);
				return nil;
      end);
			QuestlogOptions[ShaguQuest_Player].OrganizerSettings = {};
			ShaguQuest_RefreshOtherQuestDisplays();
		else
			local title = GetQuestLogTitle(questID);
			if(not title) then
				return;
			end
			if(msg == "reset") then
				QuestlogOptions[ShaguQuest_Player].OrganizerSettings[title] = nil;
				ShaguQuest_RefreshOtherQuestDisplays();
				FixGroupChangedQuest(title, nil);
			else
				QuestlogOptions[ShaguQuest_Player].OrganizerSettings[title] = {};
				QuestlogOptions[ShaguQuest_Player].OrganizerSettings[title].header = msg;
				ShaguQuest_RefreshOtherQuestDisplays();
				FixGroupChangedQuest(title, msg);
			end
		end
		ShaguQuest_RefreshOtherQuestDisplays();
	else
		DEFAULT_CHAT_FRAME:AddMessage("Usage:");
		DEFAULT_CHAT_FRAME:AddMessage("/eql - shows this message");
		DEFAULT_CHAT_FRAME:AddMessage("/eql <header> - moves the currently selected quest to this header");
		DEFAULT_CHAT_FRAME:AddMessage("/eql reset - reset the currently selected quest to its default header");
		DEFAULT_CHAT_FRAME:AddMessage("/eql resetall - resets all quests to their default headers");
	end
end




function GetNumQuestLogEntries()
	if(not ShaguQuest_UpdateDB()) then
		return old_GetNumQuestLogEntries();
	end
	return ShaguQuest_Temp.savedNumEntries, ShaguQuest_Temp.savedNumQuests;
end



function SelectQuestLogEntry(questID)
	if(not ShaguQuest_UpdateDB()) then
		return old_SelectQuestLogEntry(questID);
	end
	if(ShaguQuest_Temp.savedQuestIDMap and ShaguQuest_Temp.savedQuestIDMap[questID] and ShaguQuest_Temp.savedQuestIDMap[questID].questID) then
		ShaguQuest_Temp.savedSelectedQuest = questID;
		return old_SelectQuestLogEntry(ShaguQuest_Temp.savedQuestIDMap[questID].questID);
	end
end



function GetQuestLogSelection()
	if(not ShaguQuest_UpdateDB()) then
		return old_GetQuestLogSelection();
	end
	return ShaguQuest_Temp.savedSelectedQuest;
end




function ExpandQuestHeader(questID)
	-- DISABLED!
end

function CollapseQuestHeader(questID)
	-- DEFAULT_CHAT_FRAME:AddMessage("Collapsing quest headers will cause errors.");
	ShaguQuest_QuestLogCollapseAllButton.collapsed = nil;
end



function IsUnitOnQuest(questID, unit)
	if(not ShaguQuest_UpdateDB()) then
		return old_IsUnitOnQuest(questID, unit);
	end
	if(ShaguQuest_Temp.savedQuestIDMap and ShaguQuest_Temp.savedQuestIDMap[questID] and ShaguQuest_Temp.savedQuestIDMap[questID].questID) then
		return old_IsUnitOnQuest(ShaguQuest_Temp.savedQuestIDMap[questID].questID, unit);
	end
end



function IsQuestWatched(questID)
	if(not ShaguQuest_UpdateDB()) then
		return ShaguQuest_IsQuestWatched(questID);
	end
	if(ShaguQuest_Temp.savedQuestIDMap and ShaguQuest_Temp.savedQuestIDMap[questID] and ShaguQuest_Temp.savedQuestIDMap[questID].questID) then
		return ShaguQuest_IsQuestWatched(questID); -- ShaguQuest_IsQuestWatched(ShaguQuest_Temp.savedQuestIDMap[questID].questID);
	end
end

function AddQuestWatch(questID)
	if(not ShaguQuest_UpdateDB()) then
		return ShaguQuest_AddQuestWatch(questID);
	end
	if(ShaguQuest_Temp.savedQuestIDMap and ShaguQuest_Temp.savedQuestIDMap[questID] and ShaguQuest_Temp.savedQuestIDMap[questID].questID) then
		return ShaguQuest_AddQuestWatch(questID);-- ShaguQuest_AddQuestWatch(ShaguQuest_Temp.savedQuestIDMap[questID].questID);
	end
end

function RemoveQuestWatch(questID)
	if(not ShaguQuest_UpdateDB()) then
		return ShaguQuest_RemoveQuestWatch(questID);
	end
	if(ShaguQuest_Temp.savedQuestIDMap and ShaguQuest_Temp.savedQuestIDMap[questID] and ShaguQuest_Temp.savedQuestIDMap[questID].questID) then
		return ShaguQuest_RemoveQuestWatch(questID); -- ShaguQuest_RemoveQuestWatch(ShaguQuest_Temp.savedQuestIDMap[questID].questID);
	end
end


function GetQuestIndexForWatch(watchID)
	if(not ShaguQuest_UpdateDB()) then
		return ShaguQuest_GetQuestIndexForWatch(watchID);
	end
	
	if(ShaguQuest_Temp.savedQuestIDMap) then
	
		local mappedQuestID = ShaguQuest_GetQuestIndexForWatch(watchID);
		local questID;
		for questID in ShaguQuest_Temp.savedQuestIDMap do
			if(ShaguQuest_Temp.savedQuestIDMap[questID].questID and (ShaguQuest_Temp.savedQuestIDMap[questID].questID == mappedQuestID)) then
				return ShaguQuest_GetQuestIndexForWatch(watchID); -- return questID;
			end
		end
	end
end



function GetNumQuestLeaderBoards(questID)
	if(not questID or not ShaguQuest_UpdateDB()) then
		return old_GetNumQuestLeaderBoards(questID);
	end
	if(ShaguQuest_Temp.savedQuestIDMap and ShaguQuest_Temp.savedQuestIDMap[questID] and ShaguQuest_Temp.savedQuestIDMap[questID].questID) then
		return old_GetNumQuestLeaderBoards(ShaguQuest_Temp.savedQuestIDMap[questID].questID);
	end
end

function GetQuestLogLeaderBoard(objectiveID, questID)
	if(not questID or not ShaguQuest_UpdateDB()) then
		return old_GetQuestLogLeaderBoard(objectiveID, questID);
	end
	if(ShaguQuest_Temp.savedQuestIDMap and ShaguQuest_Temp.savedQuestIDMap[questID] and ShaguQuest_Temp.savedQuestIDMap[questID].questID) then
		return old_GetQuestLogLeaderBoard(objectiveID, ShaguQuest_Temp.savedQuestIDMap[questID].questID);
	end
end





function SetTrackerFontSize()
	local temp, t1, t2;
	
	t1, _, t2 = ShaguQuest_QuestWatchLine1:GetFont();
	
	for i=1, MAX_QUESTWATCH_LINES, 1 do
		temp = getglobal("ShaguQuest_QuestWatchLine"..i);
		--temp:SetTextHeight(QuestlogOptions[ShaguQuest_Player].TrackerFontHeight);
		temp:SetFont(t1, QuestlogOptions[ShaguQuest_Player].TrackerFontHeight, t2);
		temp:SetHeight(QuestlogOptions[ShaguQuest_Player].TrackerFontHeight+1);
	end
	
	QuestWatch_Update();
end

function ShaguQuest_Toggle_ShowMinimizer()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].TrackerShowMinimizer = 1;
		ShaguQuest_Tracker_MinimizeButton:Show();
	else
		QuestlogOptions[ShaguQuest_Player].TrackerShowMinimizer = 0;
		QuestlogOptions[ShaguQuest_Player].TrackerIsMinimized = 0;
		ShaguQuest_Tracker_MinimizeButton:Hide();
	end
	
	QuestWatch_Update();
end

function ShaguQuest_Toggle_Tracker()
	if ( QuestlogOptions[ShaguQuest_Player].TrackerIsMinimized == 1 ) then
		QuestlogOptions[ShaguQuest_Player].TrackerIsMinimized = 0;
	else
		QuestlogOptions[ShaguQuest_Player].TrackerIsMinimized = 1;
	end
	
	QuestWatch_Update();
end




function ShaguQuest_ShowLoadDropDown(button)
	if ( button == "LeftButton" ) then
		ToggleDropDownMenu(1, nil, ShaguQuest_RealmDropDown, this:GetName(), 0, 0);
		return;
	end
end


function ShaguQuest_RealmDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, ShaguQuest_RealmDropDown_Initialize, "MENU");
	UIDropDownMenu_SetButtonWidth(50);
	UIDropDownMenu_SetWidth(50);
end



function ShaguQuest_RealmDropDown_Initialize()
	
	if ( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
	
		local info = {};
		local realms = {};
		
		-- Loop through Realms and add to menu
		for i in QuestlogOptions do
			for w in string.gfind(i, "%-([^%-]+)") do
					if ( not realms[w] ) then
					
						-- Make sure every realm is only shown once
						realms[w] = 1;
						-- Realms List
						info = {};
						info.text = w;
						info.hasArrow = 1;
						info.func = nil;
						info.notCheckable = 1;
						UIDropDownMenu_AddButton(info);

					break;
				end
			end
		end

	elseif ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then

		info = {};
		info.text = UIDROPDOWNMENU_MENU_VALUE;
		info.notClickable = 1;
		info.isTitle = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

		for i in QuestlogOptions do
			for x, w in string.gfind(i, "([^%-]+)%-([^%-]+)") do
				if(w == UIDROPDOWNMENU_MENU_VALUE) then
					info = {};
					info.text = x;
					info.value = i;
					info.func = ShaguQuest_LoadCharacterSettings;
					info.notCheckable = 1;
					UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
				end
			end
		end
		
	end
end

function ShaguQuest_LoadCharacterSettings()
	-- toggle the menu.. in this case hide it
	ToggleDropDownMenu(1, nil, ShaguQuest_RealmDropDown, ShaguQuest_OptionsFrameLoadButton:GetName(), 0, 0);
	
	--load the settings...
		QuestlogOptions[ShaguQuest_Player].ShowQuestLevels = QuestlogOptions[this.value].ShowQuestLevels;
		
		QuestlogOptions[ShaguQuest_Player].RestoreUponSelect = QuestlogOptions[this.value].RestoreUponSelect;
		
		QuestlogOptions[ShaguQuest_Player].MinimizeUponClose = QuestlogOptions[this.value].MinimizeUponClose;
		
		QuestlogOptions[ShaguQuest_Player].LockQuestLog = QuestlogOptions[this.value].LockQuestLog;


		if(QuestlogOptions[ShaguQuest_Player].LockQuestLog == 1) then
			ShaguQuest_QuestLogFrame:RegisterForDrag(0);
			ShaguQuest_QuestLogFrame_Description:RegisterForDrag(0);
		else
			ShaguQuest_QuestLogFrame:RegisterForDrag("LeftButton");
			ShaguQuest_QuestLogFrame_Description:RegisterForDrag("LeftButton");
		end
		
		
		QuestlogOptions[ShaguQuest_Player].LogLockPoints = QuestlogOptions[this.value].LogLockPoints;
			
			
		if (QuestlogOptions[ShaguQuest_Player].LogLockPoints and
							QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointone and
							QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointtwo) then
			ShaguQuest_QuestLogFrame:ClearAllPoints();
			ShaguQuest_QuestLogFrame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointone,QuestlogOptions[ShaguQuest_Player].LogLockPoints.pointtwo);
		end
		
		
		QuestlogOptions[ShaguQuest_Player].MinimizeUponClose = QuestlogOptions[this.value].MinimizeUponClose;
		
		QuestlogOptions[ShaguQuest_Player].LogOpacity = QuestlogOptions[this.value].LogOpacity;
		ShaguQuest_QuestLogFrame:SetAlpha(QuestlogOptions[ShaguQuest_Player].LogOpacity);
		ShaguQuest_OptionsFrame_Slider_LogOpacity:SetValue(QuestlogOptions[ShaguQuest_Player].LogOpacity);
		
		QuestlogOptions[ShaguQuest_Player].ShowZonesInTracker = QuestlogOptions[this.value].ShowZonesInTracker;
		
		QuestlogOptions[ShaguQuest_Player].SortTrackerItems = QuestlogOptions[this.value].SortTrackerItems;
		
		QuestlogOptions[ShaguQuest_Player].CustomZoneColor = QuestlogOptions[this.value].CustomZoneColor;
		
		QuestlogOptions[ShaguQuest_Player].CustomHeaderColor = QuestlogOptions[this.value].CustomHeaderColor;
		
		QuestlogOptions[ShaguQuest_Player].CustomObjetiveColor = QuestlogOptions[this.value].CustomObjetiveColor;
		
		QuestlogOptions[ShaguQuest_Player].FadeHeaderColor = QuestlogOptions[this.value].FadeHeaderColor;
		
		QuestlogOptions[ShaguQuest_Player].FadeObjectiveColor = QuestlogOptions[this.value].FadeObjectiveColor;
		
		QuestlogOptions[ShaguQuest_Player].CustomTrackerBGColor = QuestlogOptions[this.value].CustomTrackerBGColor;
		
		QuestlogOptions[ShaguQuest_Player].UseTrackerListing = QuestlogOptions[this.value].UseTrackerListing;
		
		QuestlogOptions[ShaguQuest_Player].TrackerList = QuestlogOptions[this.value].TrackerList;
		
		QuestlogOptions[ShaguQuest_Player].TrackerSymbol = QuestlogOptions[this.value].TrackerSymbol;
		
		QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"] = {r=QuestlogOptions[this.value].Color["TrackerBG"].r, 
																											 g=QuestlogOptions[this.value].Color["TrackerBG"].g,
																											 b=QuestlogOptions[this.value].Color["TrackerBG"].b,
																											 a=QuestlogOptions[this.value].Color["TrackerBG"].a};
																											 
																											 
		QuestlogOptions[ShaguQuest_Player].Color["Zone"] = {r=QuestlogOptions[this.value].Color["Zone"].r, 
																								  g=QuestlogOptions[this.value].Color["Zone"].g,
																								  b=QuestlogOptions[this.value].Color["Zone"].b};
																											 
		QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"] = {r=QuestlogOptions[this.value].Color["HeaderEmpty"].r, 
																										 		 g=QuestlogOptions[this.value].Color["HeaderEmpty"].g,
																											 	 b=QuestlogOptions[this.value].Color["HeaderEmpty"].b};
																											 
		QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"] = {r=QuestlogOptions[this.value].Color["HeaderComplete"].r, 
																														g=QuestlogOptions[this.value].Color["HeaderComplete"].g,
																														b=QuestlogOptions[this.value].Color["HeaderComplete"].b};
																											 
		QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"] = {r=QuestlogOptions[this.value].Color["ObjectiveEmpty"].r, 
																														g=QuestlogOptions[this.value].Color["ObjectiveEmpty"].g,
																														b=QuestlogOptions[this.value].Color["ObjectiveEmpty"].b};
																											 
		QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"] = {r=QuestlogOptions[this.value].Color["ObjectiveComplete"].r, 
																															 g=QuestlogOptions[this.value].Color["ObjectiveComplete"].g,
																															 b=QuestlogOptions[this.value].Color["ObjectiveComplete"].b};
																											 
		QuestlogOptions[ShaguQuest_Player].Color["Tooltip"] = {r=QuestlogOptions[this.value].Color["Tooltip"].r, 
																										 g=QuestlogOptions[this.value].Color["Tooltip"].g,
																										 b=QuestlogOptions[this.value].Color["Tooltip"].b};


		QuestlogOptions[ShaguQuest_Player].LockTracker = QuestlogOptions[this.value].LockTracker;
		
		QuestlogOptions[ShaguQuest_Player].LockPoints = QuestlogOptions[this.value].LockPoints;
		
		QuestlogOptions[ShaguQuest_Player].AddNew = QuestlogOptions[this.value].AddNew;
		
		QuestlogOptions[ShaguQuest_Player].RemoveFinished = QuestlogOptions[this.value].RemoveFinished;
		
		QuestlogOptions[ShaguQuest_Player].MinimizeFinished = QuestlogOptions[this.value].MinimizeFinished;
		
		QuestlogOptions[ShaguQuest_Player].AddUntracked = QuestlogOptions[this.value].AddUntracked;
		
		QuestlogOptions[ShaguQuest_Player].TrackerFontHeight = QuestlogOptions[this.value].TrackerFontHeight;
		
		ShaguQuest_OptionsFrame_Slider_TrackerFontSize:SetValue(QuestlogOptions[ShaguQuest_Player].TrackerFontHeight);
		
		QuestlogOptions[ShaguQuest_Player].TrackerShowMinimizer = QuestlogOptions[this.value].TrackerShowMinimizer;
		
		QuestlogOptions[ShaguQuest_Player].TrackerIsMinimized = QuestlogOptions[this.value].TrackerIsMinimized;
		
		-- new to 3.5.6
		
		QuestlogOptions[ShaguQuest_Player].AutoCompleteQuests = QuestlogOptions[this.value].AutoCompleteQuests;
			
		QuestlogOptions[ShaguQuest_Player].RemoveCompletedObjectives = QuestlogOptions[this.value].RemoveCompletedObjectives;
		
		QuestlogOptions[ShaguQuest_Player].ShowObjectiveMarkers = QuestlogOptions[this.value].ShowObjectiveMarkers;
		
		QuestlogOptions[ShaguQuest_Player].OnlyLevelsInLog = QuestlogOptions[this.value].OnlyLevelsInLog;
		
		-- new to 3.5.9
		
		QuestlogOptions[ShaguQuest_Player].ItemTooltip = QuestlogOptions[this.value].ItemTooltip;
			
		QuestlogOptions[ShaguQuest_Player].MobTooltip = QuestlogOptions[this.value].MobTooltip;
		
		QuestlogOptions[ShaguQuest_Player].InfoOnQuestCompletion = QuestlogOptions[this.value].InfoOnQuestCompletion;
		
		QuestlogOptions[ShaguQuest_Player].CustomTooltipColor = QuestlogOptions[this.value].CustomTooltipColor;
		
	
	EQL_Options_SetStates();
	
	QuestLog_Update();
	QuestWatch_Update();
end

-- new to 3.5.6
function ShaguQuest_Toggle_AutoCompleteQuests()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].AutoCompleteQuests = 1;
	else
		QuestlogOptions[ShaguQuest_Player].AutoCompleteQuests = 0;
	end
end

function ShaguQuest_Toggle_OnlyLevelsInLog()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].OnlyLevelsInLog = 1;
	else
		QuestlogOptions[ShaguQuest_Player].OnlyLevelsInLog = 0;
	end
end

function ShaguQuest_Toggle_HideCompletedObjectives()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].RemoveCompletedObjectives = 1;
	else
		QuestlogOptions[ShaguQuest_Player].RemoveCompletedObjectives = 0;
	end
	QuestWatch_Update();
end


-- new to3.5.9

function ShaguQuest_Toggle_ShowItemTooltip()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].ItemTooltip = 1;
	else
		QuestlogOptions[ShaguQuest_Player].ItemTooltip = 0;
	end
end


function ShaguQuest_Toggle_ShowMobTooltip()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].MobTooltip = 1;
	else
		QuestlogOptions[ShaguQuest_Player].MobTooltip = 0;
	end
end

function ShaguQuest_Toggle_InfoOnQuestComplete()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].InfoOnQuestCompletion = 1;
		LookForCompletedQuests(false)
	else
		QuestlogOptions[ShaguQuest_Player].InfoOnQuestCompletion = 0;
	end
end

function ShaguQuest_Toggle_CustomTooltipInfoColor()
	if (this:GetChecked() == 1) then
		QuestlogOptions[ShaguQuest_Player].CustomTooltipColor = 1;
	else
		QuestlogOptions[ShaguQuest_Player].CustomTooltipColor = 0;
	end
end




-- end




--;
--
--