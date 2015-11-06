

function EQL_QuestTracker_OnLoad()
	this:RegisterEvent("QUEST_FINISHED");
	this:RegisterEvent("QUEST_COMPLETE");
  this:RegisterEvent("VARIABLES_LOADED");
  this:RegisterEvent("UI_INFO_MESSAGE"); 
  this:RegisterEvent("CHAT_MSG_SYSTEM");
  this:RegisterEvent("UNIT_QUEST_LOG_CHANGED");
end

function ShaguQuest_QuestWatchFrame_OnUpdate(elapsed)
	ShaguQuest_Temp.updateTime = ShaguQuest_Temp.updateTime + elapsed;
	if(ShaguQuest_Temp.updateTime >= ShaguQuest_Temp.updateTarget) then
		ShaguQuest_Temp.updateTime = 0;
		ShaguQuest_Temp.updateTarget = 3;
		
		if(ShaguQuest_Temp.manageHeaders) then
			ShaguQuest_Temp.manageHeaders = false;
			ManageQuestHeaders();
		end
		
		MagageTrackedQuests();
		QuestWatch_Update();
	end
end

function EQL_QuestTracker_OnEvent(event)
	if (event == "CHAT_MSG_SYSTEM" and QuestlogOptions[ShaguQuest_Player].AddNew == 1) then
		if string.find(arg1, EQL_QUEST_ACCEPTED.." .+") then
			local temp = string.gsub(arg1, EQL_QUEST_ACCEPTED.." ", "");
			-- Got name, add to tracker
			ShaguQuest_Temp.AddTrack = temp;
			ShaguQuest_Temp.updateTime = 0;
			ShaguQuest_Temp.updateTarget = 1;
		end
	end
	
	if(event == "UI_INFO_MESSAGE") then
		if(QuestlogOptions[ShaguQuest_Player].AddUntracked == 1) then
			if (string.find (arg1, ".+%s%d+/%d+")) then
				local temp = string.gsub(arg1, " %d+/%d+", "");
				FindAndAddQuestToTracker(temp);
			elseif (string.find (arg1, ".+%s"..EQL_COMPLETE)) then
				local temp = string.gsub(arg1, " "..EQL_COMPLETE, "");
				FindAndAddQuestToTracker(temp);
			end
		end
	end
	
	if (event == "VARIABLES_LOADED") then
		if(QuestlogOptions[ShaguQuest_Player] and QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"]) then
			QuestWatchFrameBackdrop:SetBackdropBorderColor( QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].r,
																											QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].g,
																											QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].b );
			QuestWatchFrameBackdrop:SetBackdropColor( QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].r,
																											QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].g,
																											QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].b );
																											
			QuestWatchFrameBackdrop:SetAlpha(QuestlogOptions[ShaguQuest_Player].Color["TrackerBG"].a);
		end
			
		if(QuestlogOptions[ShaguQuest_Player].LockTracker == 1) then
			ShaguQuest_QuestWatchFrame:SetUserPlaced(0);
			ShaguQuest_QuestWatchFrame:RegisterForDrag(0);
			ShaguQuest_QuestWatchFrame:SetMovable(false);
			ShaguQuest_QuestWatchFrame:EnableMouse(false);
		else
			ShaguQuest_QuestWatchFrame:RegisterForDrag("LeftButton");
		end
		
		if (QuestlogOptions[ShaguQuest_Player].LockPoints and
				QuestlogOptions[ShaguQuest_Player].LockPoints.corner and
				QuestlogOptions[ShaguQuest_Player].LockPoints.pointone and
				QuestlogOptions[ShaguQuest_Player].LockPoints.pointtwo) then
			
			ShaguQuest_QuestWatchFrame:ClearAllPoints();
			ShaguQuest_QuestWatchFrame:SetPoint(QuestlogOptions[ShaguQuest_Player].LockPoints.corner,"UIParent","BOTTOMLEFT",QuestlogOptions[ShaguQuest_Player].LockPoints.pointone,QuestlogOptions[ShaguQuest_Player].LockPoints.pointtwo);		
		end
		
		SetTrackerFontSize();
		
		ShaguQuest_Temp.updateTime = 0;
		ShaguQuest_Temp.updateTarget = 1;
		ShaguQuest_Temp.manageHeaders = true;

	end
	if ( event == "QUEST_FINISHED" or event == "QUEST_COMPLETE" ) then
		MagageTrackedQuests();
	end
	
	if( event == "QUESTLOG_CHANGED" and not ShaguQuest_Temp.firstManagement ) then
		MagageTrackedQuests();
		ShaguQuest_Temp.firstManagement = true;
	end
end

				

local old_QuestWatch_Update = QuestWatch_Update;
-- QuestWatch functions
function QuestWatch_Update()

	if(not ShaguQuest_Temp.hasManaged) then
		QuestWatchFrame:Hide();
		return;
	end
	-- MagageTrackedQuests();
	
	if ( QuestlogOptions[ShaguQuest_Player].TrackerIsMinimized == 1 ) then
		QuestWatch_SetMinimized();
		return;
	end

	local numObjectives;
	local questWatchMaxWidth = 0;
	local tempWidth;
	local watchText;
	local text, type, finished;
	local questTitle
	local watchTextIndex = 1;
	local questIndex;
	local objectivesCompleted;	
	local level;
	local tempColor, tempColor2, tempColor3;
	local tempArray = {}, tempI;
	local tempObj, tempDone, tempLevel, tempTag;
	
	local qwHeight=12;	
	local questLogTitleText, isComplete, isCompleted, isRemoved;
	local currentHeader = nil;
	local temp, isCollapsed, isOk;

	for i=1, table.getn(QuestlogOptions[ShaguQuest_Player].QuestWatches), 1 do
		isRemoved = false;
		questIndex = ShaguQuest_GetQuestIndexForWatch(i);
		if ( questIndex ) then
			_, level, _, _, _, isCompleted = GetQuestLogTitle(questIndex);
			numObjectives = GetNumQuestLeaderBoards(questIndex);
			
			-- Check Header
			temp, isCollapsed = GetQuestHeaderForWatch(i);
			if (currentHeader == nil or currentHeader ~= temp) then
				currentHeader = temp;
				if(QuestlogOptions[ShaguQuest_Player].ShowZonesInTracker == 1) then
					watchText = getglobal("ShaguQuest_QuestWatchLine"..watchTextIndex);
					if(watchText ~= nil) then
						watchText:SetText(currentHeader);
						tempWidth = watchText:GetWidth();
						-- Set the anchor of the title line a little lower
						if ( watchTextIndex > 1 ) then
							watchText:SetPoint("TOPLEFT", "ShaguQuest_QuestWatchLine"..(watchTextIndex - 1), "BOTTOMLEFT", 0, -4);
							qwHeight = qwHeight+4;
						end
						if (QuestlogOptions[ShaguQuest_Player].CustomZoneColor == 1) then
							watchText:SetTextColor(QuestlogOptions[ShaguQuest_Player].Color["Zone"].r, QuestlogOptions[ShaguQuest_Player].Color["Zone"].g, QuestlogOptions[ShaguQuest_Player].Color["Zone"].b);
						else
							watchText:SetTextColor(1, 1, 1);
						end
						watchText:Show();
						if ( tempWidth > questWatchMaxWidth ) then
							questWatchMaxWidth = tempWidth;
						end
					end
					watchTextIndex = watchTextIndex + 1;
				end
			end
			
			if(QuestlogOptions[ShaguQuest_Player].RemoveFinished == 1 and isCompleted) then
				isRemoved = true;
			end
			
			if(isCollapsed == nil and questIndex > 0 and not isRemoved) then
				-- Set title
				questLogTitleText, tempLevel, tempTag, _, _, isComplete = GetQuestLogTitle(questIndex);
				watchText = getglobal("ShaguQuest_QuestWatchLine"..watchTextIndex);
				if(watchText ~= nil and questLogTitleText ~= nil) then
					if(QuestlogOptions[ShaguQuest_Player].ShowQuestLevels == 1) then
						if (tempTag ~= NIL) then
							tempLevel = tempLevel.."+";
						end
						watchText:SetText("  ".."["..tempLevel.."] "..questLogTitleText);
					else
						watchText:SetText("  "..questLogTitleText);
					end
					tempWidth = watchText:GetWidth();
					-- Set the anchor of the title line a little lower
					if ( watchTextIndex > 1 ) then
					 	watchText:SetPoint("TOPLEFT", "ShaguQuest_QuestWatchLine"..(watchTextIndex - 1), "BOTTOMLEFT", 0, -4);
						qwHeight = qwHeight+4;
					end
					watchText:Show();
					if ( tempWidth > questWatchMaxWidth ) then
						questWatchMaxWidth = tempWidth;
					end
				end
				watchTextIndex = watchTextIndex + 1;
				
				if(QuestlogOptions[ShaguQuest_Player].MinimizeFinished == 1 and isCompleted) then
					numObjectives = 0;
				end
				
				
				local markerID = 0;
				
				if ( numObjectives > 0 ) then
					objectivesCompleted = 0;
					tempObj = 0;
					tempDone = 0;
					for j=1, numObjectives do
						text, type, finished = GetQuestLogLeaderBoard(j, questIndex);
						
						if ( finished and QuestlogOptions[ShaguQuest_Player].RemoveCompletedObjectives == 1 ) then
							-- Do nothing
						else
						
							watchText = getglobal("ShaguQuest_QuestWatchLine"..watchTextIndex);
							if(watchText ~= nil) then
								-- Set Objective text
								if ( QuestlogOptions[ShaguQuest_Player].ShowObjectiveMarkers == 1 ) then
									if (QuestlogOptions[ShaguQuest_Player].UseTrackerListing == 1) then -- Tracker Listing
										watchText:SetText("    "..ShaguQuest_TrackerLists[QuestlogOptions[ShaguQuest_Player].TrackerList][markerID]..") "..text);
									else
										watchText:SetText("    "..ShaguQuest_TrackerSymbols[QuestlogOptions[ShaguQuest_Player].TrackerSymbol].." "..text);
									end
								else
									watchText:SetText("    "..text);
								end
								
								
								-- Color the objectives
								if (QuestlogOptions[ShaguQuest_Player].CustomObjetiveColor == 1) then
									tempColor = { r=QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"].r,
																g=QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"].g,
																b=QuestlogOptions[ShaguQuest_Player].Color["ObjectiveEmpty"].b };
																
									tempColor2 = { r=QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"].r,
																 g=QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"].g,
																 b=QuestlogOptions[ShaguQuest_Player].Color["ObjectiveComplete"].b };
								else
									tempColor = {r=0.8, g=0.8, b=0.8};
									tempColor2 = {r=HIGHLIGHT_FONT_COLOR.r, g=HIGHLIGHT_FONT_COLOR.g, b=HIGHLIGHT_FONT_COLOR.b};
								end
								
								
								if ( finished ) then
									watchText:SetTextColor(tempColor2.r, tempColor2.g, tempColor2.b);
									objectivesCompleted = objectivesCompleted + 1;
								else
									tempI = 0;
									tempArray = {};
									for v in string.gfind(text, "%d+") do
										tempI = tempI+1;
										table.insert (tempArray, v);
									end
									if (tempI == 0) then
										tempI = 2;
										tempArray[1] = "0";
										tempArray[2] = "1";
									 elseif (tempI == 1) then
										tempI = 2;
										tempArray[2] = 99999;
									end
									tempObj  = tempObj + tempArray[tempI];
									tempDone = tempDone + tempArray[tempI-1];
									
									if (QuestlogOptions[ShaguQuest_Player].FadeObjectiveColor == 1) then
										tempColor3 = ShaguQuest_FadeColors(tempColor, tempColor2, tempArray[tempI-1], tempArray[tempI]);
									else
										tempColor3 = tempColor;
									end
									watchText:SetTextColor(tempColor3.r, tempColor3.g, tempColor3.b);
								end
								
								
								tempWidth = watchText:GetWidth();
								if ( tempWidth > questWatchMaxWidth ) then
									questWatchMaxWidth = tempWidth;
								end
								watchText:SetPoint("TOPLEFT", "ShaguQuest_QuestWatchLine"..(watchTextIndex - 1), "BOTTOMLEFT", 0, 0);
								watchText:Show();
							end
							watchTextIndex = watchTextIndex + 1;
								
							markerID = markerID+1;
						end --if not complete... bla bla bla
					end -- For
				else
					tempObj = 1;
					tempDone = 0;
					numObjectives = 0;
					objectivesCompleted = -1;
				end
				
				-- Brighten the quest title if all the quest objectives were met
				watchText = getglobal("ShaguQuest_QuestWatchLine"..watchTextIndex-markerID-1);
				
				if (QuestlogOptions[ShaguQuest_Player].CustomHeaderColor == 1) then
					if (QuestlogOptions[ShaguQuest_Player].FadeHeaderColor == 1) then
						if ( isComplete or objectivesCompleted == numObjectives ) then
								tempColor = {	r=QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].r,
															g=QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].g,
															b=QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].b };
						else
								tempColor3 = {r=QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].r,
															g=QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].g,
															b=QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].b };
															
								tempColor2 = {r=QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].r,
															g=QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].g,
															b=QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].b };
								tempColor = ShaguQuest_FadeColors(tempColor3, tempColor2, tempDone, tempObj);
						end
					else
						if ( isComplete or objectivesCompleted == numObjectives ) then
								tempColor = {	r=QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].r,
															g=QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].g,
															b=QuestlogOptions[ShaguQuest_Player].Color["HeaderComplete"].b };
						else
								tempColor = {	r=QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].r,
															g=QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].g,
															b=QuestlogOptions[ShaguQuest_Player].Color["HeaderEmpty"].b };
						end
					end
					watchText:SetTextColor(tempColor.r, tempColor.g, tempColor.b);
				else
					if ( isComplete or  objectivesCompleted == numObjectives ) then
							watchText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
					else
							watchText:SetTextColor(0.75, 0.61, 0);
					end
				end
				
				
			
			end
			
		end
	end

	-- Set tracking indicator
	if ( GetNumQuestWatches() > 0 ) then
		ShaguQuest_QuestLogTrackTracking:SetVertexColor(0, 1.0, 0);
	else
		ShaguQuest_QuestLogTrackTracking:SetVertexColor(1.0, 0, 0);
	end
	
	-- If no watch lines used then hide the frame and return
	if ( watchTextIndex == 1 ) then
		ShaguQuest_QuestWatchFrame:Hide();
		return;
	else
		ShaguQuest_QuestWatchFrame:Show();
		ShaguQuest_QuestWatchFrame:SetHeight(watchTextIndex * (QuestlogOptions[ShaguQuest_Player].TrackerFontHeight+1) + qwHeight);
		ShaguQuest_QuestWatchFrame:SetWidth(questWatchMaxWidth+12);
	end

	-- Hide unused watch lines
	if(watchTextIndex < MAX_QUESTWATCH_LINES) then
		for i=watchTextIndex, MAX_QUESTWATCH_LINES do
			getglobal("ShaguQuest_QuestWatchLine"..i):Hide();
		end
	end

	QuestWatchFrameBackdrop:SetPoint("TOPLEFT", "ShaguQuest_QuestWatchFrame", "TOPLEFT", -8, -4);

	-- UIParent_ManageFramePositions();
	if (not ShaguQuest_Temp.movingWatchFrame) then
		if (QuestlogOptions[ShaguQuest_Player].LockPoints and
			QuestlogOptions[ShaguQuest_Player].LockPoints.corner and
			QuestlogOptions[ShaguQuest_Player].LockPoints.pointone and
			QuestlogOptions[ShaguQuest_Player].LockPoints.pointtwo) then
			ShaguQuest_QuestWatchFrame:ClearAllPoints();
			ShaguQuest_QuestWatchFrame:SetPoint(QuestlogOptions[ShaguQuest_Player].LockPoints.corner,"UIParent","BOTTOMLEFT",QuestlogOptions[ShaguQuest_Player].LockPoints.pointone,QuestlogOptions[ShaguQuest_Player].LockPoints.pointtwo);
		end
	end
	
end

-- ShaguQuest_QuestWatchFrame = QuestWatchFrame;


-- Functions
function ShaguQuest_FadeColors(tempColor, tempColor2, done, obj)
	local color = {r=0, g=0, b=0};
	local multiplier;
	
	multiplier = (done / obj);
	color.r = tempColor.r + ((tempColor2.r - tempColor.r)*multiplier);
	color.g = tempColor.g + ((tempColor2.g - tempColor.g)*multiplier);
	color.b = tempColor.b + ((tempColor2.b - tempColor.b)*multiplier);
	
	return color;
end


-- Old QuestRacking
local Original_RemoveQuestWatch = RemoveQuestWatch;
local Original_IsQuestWatched = IsQuestWatched;
local Original_GetNumQuestWatches = GetNumQuestWatches;
local Original_AddQuestWatch = AddQuestWatch;
local Original_GetQuestIndexForWatch = GetQuestIndexForWatch;


function SortWatchedQuests()
	if (QuestlogOptions[ShaguQuest_Player].ShowZonesInTracker == 1) then
		table.sort(QuestlogOptions[ShaguQuest_Player].QuestWatches);
	else
		if(QuestlogOptions[ShaguQuest_Player].SortTrackerItems == 1) then
			-- Make theese sort on title rather than zone+level+title		
			table.sort(QuestlogOptions[ShaguQuest_Player].QuestWatches, SortCompare);
			
		end
	end
end

function SortCompare(first, second)
	local temp = string.gsub(first, ".+,%d+,[%[%d+%+*%]]*", "");
	
	local temp2 = string.gsub(second, ".+,%d+,[%[%d+%+*%]]*", "");
	
	if(temp < temp2) then
		return true;
	end
	return false;
end


-- QuestlogOptions.QuestWatches
function ShaguQuest_AddQuestWatch(questIndex)
	local questName, level = GetQuestLogTitle(questIndex);
	
	local questLogHeader, tempId;
	
	isHeader = false;
	tempId = questIndex;
	while (not isHeader) do
		questLogHeader, _, _, isHeader = GetQuestLogTitle(tempId);
		tempId = tempId-1;	
	end	

	table.insert(QuestlogOptions[ShaguQuest_Player].QuestWatches, questLogHeader..","..level..","..questName);

	SortWatchedQuests();

	MagageTrackedQuests();
end

function ShaguQuest_RemoveQuestWatch(questIndex)
	local questName, level = GetQuestLogTitle(questIndex);
	
	local questLogHeader, isHeader, tempId;
	
	isHeader = false;
	tempId = questIndex;
	while (not isHeader) do
		questLogHeader, _, _, isHeader = GetQuestLogTitle(tempId);
		tempId = tempId-1;	
	end
	
	local temp = questLogHeader..","..level..","..questName;
	
	if(table.getn(QuestlogOptions[ShaguQuest_Player].QuestWatches) > 0) then
		for i=1, table.getn(QuestlogOptions[ShaguQuest_Player].QuestWatches) do
			if (QuestlogOptions[ShaguQuest_Player].QuestWatches[i] == temp) then
				table.remove(QuestlogOptions[ShaguQuest_Player].QuestWatches , i);
				break;
			end
		end
	end
	
	SortWatchedQuests();

	MagageTrackedQuests();
end

function ShaguQuest_IsQuestWatched(questIndex)
	local questName, level = GetQuestLogTitle(questIndex);
	local questLogHeader, isHeader, tempId;
	
	isHeader = false;
	tempId = questIndex;
	while (not isHeader and tempId > 0) do
		questLogHeader, _, _, isHeader = GetQuestLogTitle(tempId);
		tempId = tempId-1;
		-- if(tempId <= 0) then
		--	questLogHeader, _, _, isHeader = GetQuestLogTitle(1);
		--	break;
		-- end	
	end
	
	local temp = questLogHeader..","..level..","..questName;
	if(table.getn(QuestlogOptions[ShaguQuest_Player].QuestWatches) > 0) then
		for i=1, table.getn(QuestlogOptions[ShaguQuest_Player].QuestWatches) do
			if (QuestlogOptions[ShaguQuest_Player].QuestWatches[i] == temp) then
				return true;
			end
		end
	end
	return false;
end

function GetNumQuestWatches()
	return table.getn(QuestlogOptions[ShaguQuest_Player].QuestWatches);
end

function ShaguQuest_GetQuestIndexForWatch(id)
	local numEntries = GetNumQuestLogEntries();
	local questLogTitleText, level;
	local questLogHeader, isHeader, tempId;
	local questFound = false;
	local temp, currentHeader=nil;
	
	
	for i=1, numEntries, 1 do
		questLogTitleText, level, _, isHeader, _ = GetQuestLogTitle(i);
		if (isHeader) then
			currentHeader = questLogTitleText;
		else
			temp = currentHeader..","..level..","..questLogTitleText;
			if ( temp == QuestlogOptions[ShaguQuest_Player].QuestWatches[id] ) then
				return i;
			end
		end
	end
	return 0;
end

function GetQuestHeaderForWatch(questIndex)
	if(QuestlogOptions[ShaguQuest_Player].QuestWatches[questIndex]) then
		local numEntries = GetNumQuestLogEntries();
		local questLogHeader, isCollapsed;
		local s = QuestlogOptions[ShaguQuest_Player].QuestWatches[questIndex];
		local temp=nil;
		for w in string.gfind(s, "[^,]+") do
			if(temp == nil) then
				temp = w;
				break;
			end
		end
		for i=1, numEntries, 1 do
			questLogHeader, _, _, _, isCollapsed = GetQuestLogTitle(i);
			if(questLogHeader == temp) then
				return questLogHeader, isCollapsed;
			end
		end
		return temp, true;
	end
	return "", false;
end




function MagageTrackedQuests()
	ShaguQuest_Temp.QuestList = {};
	QuestlogOptions[ShaguQuest_Player].HeaderList = {};
	
	local tempHeaderList = {};
	local numEntries = GetNumQuestLogEntries();
	local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete;
	local currentHeader = nil;
	local temp;
	
	-- Make Header List
	for j=numEntries, 1, -1 do
		questLogTitleText, _, _, isHeader, isCollapsed = GetQuestLogTitle(j);
		if (isHeader and isCollapsed) then
			tempHeaderList[j] = 1;
			table.insert(QuestlogOptions[ShaguQuest_Player].HeaderList, questLogTitleText);
			ExpandQuestHeader(j);
		else
			tempHeaderList[j] = 0;
		end
	end
	
	-- Make quest list
	local numEntries2 = GetNumQuestLogEntries();
	for j=1, numEntries2, 1 do
		questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(j);

		if (isHeader) then
			currentHeader = questLogTitleText;
		else
			temp = currentHeader..","..level..","..questLogTitleText;
			table.insert(ShaguQuest_Temp.QuestList, temp);
			
			
			if (ShaguQuest_Temp.AddTrack and ShaguQuest_Temp.AddTrack == questLogTitleText) then
				table.insert(QuestlogOptions[ShaguQuest_Player].QuestWatches, temp);
				ShaguQuest_Temp.AddTrack = nil;
			end
			
			-- If complete, remove it from the tracker...
			if (QuestlogOptions[ShaguQuest_Player].RemoveFinished == 1 and isComplete) then
				for x=1, table.getn(QuestlogOptions[ShaguQuest_Player].QuestWatches) do
					if (QuestlogOptions[ShaguQuest_Player].QuestWatches[x] == temp) then
						table.remove(QuestlogOptions[ShaguQuest_Player].QuestWatches , x);
						break;
					end
				end
			end
		end
	end
	
	-- Clear Header List
	for j=1, numEntries, 1 do
		if(tempHeaderList[j] == 1) then
			CollapseQuestHeader(j);
		end
	end
	
	-- Compare all tracked items to list
	local numWatches = table.getn(QuestlogOptions[ShaguQuest_Player].QuestWatches);
	local numEntries = table.getn(ShaguQuest_Temp.QuestList);
	local found = false;
	for i=numWatches, 1, -1 do
		found = false;
		for j=0, numEntries, 1 do
			if (QuestlogOptions[ShaguQuest_Player].QuestWatches[i] == ShaguQuest_Temp.QuestList[j]) then
				found = true;
				break;
			end
		end
		if(not found) then
			table.remove(QuestlogOptions[ShaguQuest_Player].QuestWatches, i);
		end
	end
	
	SortWatchedQuests();		
end



function ShaguQuest_ClearTracker()
	QuestlogOptions[ShaguQuest_Player].QuestWatches = {};
end





function QuestWatchFrame_LockCornerForGrowth()
	local Left = ShaguQuest_QuestWatchFrame:GetLeft();
	local Right = ShaguQuest_QuestWatchFrame:GetRight();
	local Top = ShaguQuest_QuestWatchFrame:GetTop();
	local Bottom = ShaguQuest_QuestWatchFrame:GetBottom();
	local lock;
	local pointone;
	local pointtwo;
	local TOPBOTTOM_MEDIAN = 384;
	local LEFTRIGHT_MEDIAN = 512;
	if (Left and Right and Top and Bottom) then
		if (Bottom < TOPBOTTOM_MEDIAN and Top > TOPBOTTOM_MEDIAN) then
			local topcross = Top - TOPBOTTOM_MEDIAN;
			local bottomcross = TOPBOTTOM_MEDIAN - Bottom;
			if (bottomcross > topcross) then
				lock = "BOTTOM";
				pointtwo = Bottom;
			else
				lock = "TOP";
				pointtwo = Top;
			end
		elseif (Top > TOPBOTTOM_MEDIAN) then
			lock = "TOP";
			pointtwo = Top;
		elseif (Bottom < TOPBOTTOM_MEDIAN) then
			lock = "BOTTOM";
			pointtwo = Bottom;
		end
		if (Left < LEFTRIGHT_MEDIAN and Right > LEFTRIGHT_MEDIAN) then
			local leftcross = LEFTRIGHT_MEDIAN - Left;
			local rightcross = Right - LEFTRIGHT_MEDIAN;
			if (rightcross > leftcross) then
				lock = lock.."RIGHT";
				pointone = Right;
			else
				lock = lock.."LEFT";
				pointone = Left;
			end
		elseif (Left < LEFTRIGHT_MEDIAN) then
			lock = lock.."LEFT";
			pointone = Left;
		elseif (Right > LEFTRIGHT_MEDIAN) then
			lock = lock.."RIGHT";
			pointone = Right;
		end
		if (lock and lock ~= "" and pointone and pointtwo) then
			ShaguQuest_QuestWatchFrame:ClearAllPoints();
			ShaguQuest_QuestWatchFrame:SetPoint(lock,"UIParent","BOTTOMLEFT",pointone,pointtwo);
			QuestlogOptions[ShaguQuest_Player].LockPoints = {};
			QuestlogOptions[ShaguQuest_Player].LockPoints.corner = lock;
			QuestlogOptions[ShaguQuest_Player].LockPoints.pointone = pointone;
			QuestlogOptions[ShaguQuest_Player].LockPoints.pointtwo = pointtwo;
		elseif (QuestlogOptions[ShaguQuest_Player].LockPoints and
			QuestlogOptions[ShaguQuest_Player].LockPoints.corner and
			QuestlogOptions[ShaguQuest_Player].LockPoints.pointone and
			QuestlogOptions[ShaguQuest_Player].LockPoints.pointtwo) then
			ShaguQuest_QuestWatchFrame:ClearAllPoints();
			ShaguQuest_QuestWatchFrame:SetPoint(QuestlogOptions[ShaguQuest_Player].LockPoints.corner,"UIParent","BOTTOMLEFT",QuestlogOptions[ShaguQuest_Player].LockPoints.pointone,QuestlogOptions[ShaguQuest_Player].LockPoints.pointtwo);
		end
	end
end


function FindAndAddQuestToTracker(theObjective)
	local oldSelection = GetQuestLogSelection();
	local questID;
	local numEntries = GetNumQuestLogEntries();
	local questTitle;
	local numObjectives;

	-- local tempHeaderList = {};
	local numEntries2 = GetNumQuestLogEntries();
	local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete;
	local text, typ, finished;
	
	--[[ Make Header List
	for j=numEntries2, 1, -1 do
		_, _, _, isHeader, isCollapsed = GetQuestLogTitle(j);
		if (isHeader and isCollapsed) then
			tempHeaderList[j] = 1;
			ExpandQuestHeader(j);
		else
			tempHeaderList[j] = 0;
		end
	end ]]--
	
	-- Find that quest!
	local found = false;
	for i=1, numEntries, 1 do
		questID = i;
		questTitle, _, _, isHeader = GetQuestLogTitle(questID);
		if (not isHeader) then
			SelectQuestLogEntry(questID);
			if(questTitle and not IsQuestWatched(questID)) then				
				numObjectives = GetNumQuestLeaderBoards();
				if(numObjectives > 0) then	
					for j=1, numObjectives, 1 do
						text, typ, finished = GetQuestLogLeaderBoard(j);
						if(not text or strlen(text) == 0) then
							text = typ;
						end
						text = string.gsub(text, " %d+/%d+", "");
						text = string.gsub(text, " "..EQL_COMPLETE, "");
						if(theObjective == text) then
							ShaguQuest_Temp.AddTrack = questTitle;
							found = true;
						end
						if(found) then
							break;
						end
					end
				end
			end
		end
		if(found) then
			break;
		end
	end
	
	--[[ Clear Header List
	for j=1, numEntries2, 1 do
		if(tempHeaderList[j] == 1) then
			CollapseQuestHeader(j);
		end
	end ]]--
	
	SelectQuestLogEntry(oldSelection);
	
	MagageTrackedQuests();
end


function QuestWatch_SetMinimized()
	if ( GetNumQuestWatches() == 0 ) then
		ShaguQuest_QuestWatchFrame:Hide();
		return;
	end
	
	for i=2, MAX_QUESTWATCH_LINES, 1 do
		getglobal("ShaguQuest_QuestWatchLine"..i):Hide();
	end
	
	ShaguQuest_QuestWatchLine1:SetText(ShaguQuest_QUEST_TRACKER.."   ("..GetNumQuestWatches()..")");
	ShaguQuest_QuestWatchLine1:SetTextColor(1.0, 0.82, 0.0);
	
	
	ShaguQuest_QuestWatchFrame:Show();
	ShaguQuest_QuestWatchFrame:SetHeight(QuestlogOptions[ShaguQuest_Player].TrackerFontHeight+1 + 22);
	ShaguQuest_QuestWatchFrame:SetWidth(ShaguQuest_QuestWatchLine1:GetWidth()+36);

	QuestWatchFrameBackdrop:SetPoint("TOPLEFT", "ShaguQuest_QuestWatchFrame", "TOPLEFT", -8, -4);

	-- UIParent_ManageFramePositions();
	if (QuestlogOptions[ShaguQuest_Player].LockPoints and
		QuestlogOptions[ShaguQuest_Player].LockPoints.corner and
		QuestlogOptions[ShaguQuest_Player].LockPoints.pointone and
		QuestlogOptions[ShaguQuest_Player].LockPoints.pointtwo) then
		ShaguQuest_QuestWatchFrame:ClearAllPoints();
		ShaguQuest_QuestWatchFrame:SetPoint(QuestlogOptions[ShaguQuest_Player].LockPoints.corner,"UIParent","BOTTOMLEFT",QuestlogOptions[ShaguQuest_Player].LockPoints.pointone,QuestlogOptions[ShaguQuest_Player].LockPoints.pointtwo);
	end
end

