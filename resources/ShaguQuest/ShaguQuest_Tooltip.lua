

function ShaguQuest_Tooltip_OnLoad()
	-- this will catch mobs needed for quests
	this:RegisterEvent('UPDATE_MOUSEOVER_UNIT');
	
	-- this should catch items when you're going to sell them
	ShaguQuest_ContainerFrameItemButton_OnEnter = ContainerFrameItemButton_OnEnter;
	ContainerFrameItemButton_OnEnter = ShaguQuest_New_ContainerFrameItemButton_OnEnter;
end


function ShaguQuest_Tooltip_OnEvent(event)

    if (event == 'UPDATE_MOUSEOVER_UNIT') then
        -- check if quest mob if player wants the tooltip feature...
				if ( QuestlogOptions[ShaguQuest_Player].MobTooltip == 1 ) then
					ShaguQuest_ScanTooltip();
				end
    end

end



-- New function for container items
function ShaguQuest_New_ContainerFrameItemButton_OnEnter()
	-- call old function
	ShaguQuest_ContainerFrameItemButton_OnEnter();
	
	-- if player wants the tooltip feature...
	if ( QuestlogOptions[ShaguQuest_Player].ItemTooltip == 1 ) then
		ShaguQuest_ScanTooltip();
	end
end

function ShaguQuest_ScanTooltip()
    if ( GameTooltip ~= nil and
				 getglobal('GameTooltipTextLeft1'):IsVisible() and
				 getglobal('GameTooltipTextLeft1'):GetText() ~= nil ) then

			return ShaguQuest_ScanTooltipItem(getglobal('GameTooltipTextLeft1'):GetText());

    end
		
		return false;
end



function ShaguQuest_ScanTooltipItem(queryString)
	if(queryString == nil) then return false; end
	
	local oldSelection = GetQuestLogSelection();
		if(oldSelection < 1) then oldSelection = 1; end
		
	local questID;
	local numEntries = GetNumQuestLogEntries();
	local questTitle, level, questTag, isHeader;
	local numObjectives;
	local found = false;
	local text, typ, finished;
	
	-- loop through all quests
	for i=1, numEntries, 1 do
		questID = i;
		questTitle, level, questTag, isHeader = GetQuestLogTitle(questID);
		
		if (not isHeader) then
			SelectQuestLogEntry(questID);
			if(questTitle) then				
				numObjectives = GetNumQuestLeaderBoards();
				if(numObjectives > 0) then	
					
					-- loop through all objectives
					for j=1, numObjectives, 1 do
						text, typ, finished = GetQuestLogLeaderBoard(j);
						if(not text or strlen(text) == 0) then
							text = typ;
						end
						x = string.find(text, queryString);
						if (x ~= nil) then
						
							local completion = nil;
							
							for y, z in string.gfind(text, "(%d+)/(%d+)") do
								completion = "   ("..y.."/"..z..")";
							end
							
							-- DEFAULT_CHAT_FRAME:AddMessage("EQL: ".. y..", "..z, 1, 1, 1, 1);
							
							if ( QuestlogOptions[ShaguQuest_Player].ShowQuestLevels == 1 ) then
								if(questTag ~= NIL) then
									level = level.."+"
								end
								questTitle = "["..level.."] "..questTitle;
							end
							
							if ( QuestlogOptions[ShaguQuest_Player].CustomTooltipColor == 1 ) then
								questTitle = ShaguQuest_ColorText(questTitle, QuestlogOptions[ShaguQuest_Player].Color["Tooltip"].r, QuestlogOptions[ShaguQuest_Player].Color["Tooltip"].g, QuestlogOptions[ShaguQuest_Player].Color["Tooltip"].b);
							else
								questTitle = ShaguQuest_ColorText(questTitle, 1.0, 0.8, 0.0);
							end
							
							if (completion ~= nil) then
								questTitle = questTitle..completion;
							end
							
							-- add tooltip line
							GameTooltip:AddLine(" ", 1, 1, 1, 1);
							GameTooltip:AddLine(questTitle, 1, 1, 1, 1);	
							GameTooltip:SetHeight(GameTooltip:GetHeight() + 28);
							
							-- resize tooltip
							leng = getglobal(GameTooltip:GetName() .. "TextLeft" .. GameTooltip:NumLines()):GetStringWidth();
							leng = leng + 22;
						
							if ( leng > GameTooltip:GetWidth() ) then
								GameTooltip:SetWidth(leng);
							end
							
							found = true;
						end
						if(found) then
							break;
						end
					end -- loop through all objectives
					
				end
			end
		end
		
	end -- loop through all quests
	
end



function ShaguQuest_ScanTooltipForQuest()

end
