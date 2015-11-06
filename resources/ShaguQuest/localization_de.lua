-- German localization for Extended Questlog 3.5
-- Thanks to Zwixx
-- Extended QuestLog is Copyright © 2006 Daniel Rehn

--[[--------------------------------------------------------------------------------
	Special Keys in German:
	-- Ä =  \195\132
	-- Ö =  \195\150
	-- Ü =  \195\156
	-- ä =  \195\164
	-- ö =  \195\182
	-- ü =  \195\188
	-- ß =  \195\159
-----------------------------------------------------------------------------------]]

if ( GetLocale() == "deDE" ) then

ShaguQuest_QUEST_LOG = "Erweitertes QuestLog";

ShaguQuest_OPTIONS = "Optionen";
ShaguQuest_OPTIONS_INFO = "\195\150ffnet die Optionen für das erweiterte QuestLog.";
ShaguQuest_OPTIONS_TITLE = ShaguQuest_QUEST_LOG.." "..ShaguQuest_OPTIONS

ShaguQuest_QUEST_WATCH_TOOLTIP = "Shift-Klick ein Quest um es dem Tracker hinzuzufügen oder zu entfernen.\n\nCtrl-Klick um deinen aktuellen Status im Chat einzuf\195\188gen.\n\nCtrl-Shift-Klick um den Tracker zu leeren und diesen Quest einzuf\195\188gen.";

ShaguQuest_SHRINK = "Normal";
ShaguQuest_EXTEND = "Erweitert";
ShaguQuest_RESTORE = "Wiederherstellen";

ShaguQuest_MINIMIZE_TIP = "QuestLog wiederherstellen";
ShaguQuest_MAXIMIZE_TIP = "QuestLog maximieren";

ShaguQuest_LOG_OPTIONS = "Log Optionen";
ShaguQuest_SHOW_QUEST_LEVELS = "Zeige Questlevels";
ShaguQuest_RESTORE_UPON_SELECT = "Maximieren beim selektieren";
ShaguQuest_MINIMIZE_UPON_CLOSE = "Minimieren beim schlie/195/159en";
ShaguQuest_LOCK_QUESTLOG = "Sperre QuestLog";
ShaguQuest_OPACITY = "Log Transparenz";

ShaguQuest_COLOR_OPTIONS = "Farboptionen";
ShaguQuest_ZONE_COLOR = "Benutzerdefinierte Zonenfarbe";
ShaguQuest_HEADER_COLOR = "Benutzerdefinierte Kopffarbe";
ShaguQuest_OBJECTIVE_COLOR = "Benutzerdefinierte Questzielfarbe";
ShaguQuest_FADE_HEADER = "Verblassende Quests";
ShaguQuest_FADE_OBJECTIVE = "Verblassende Questziele";
ShaguQuest_TRACKER_BG = "Tracker Hintergrundfarbe";
ShaguQuest_RESTORE_COLORS = "Farben zur\195\188cksetzen";

ShaguQuest_QUEST_TRACKER = "Erweiterter Quest Tracker";

ShaguQuest_TRACKER_OPTIONS = "Tracker Optionen";
ShaguQuest_USE_TRACKER_LISTING = "Benutze Trackerliste";
ShaguQuest_SHOW_ZONES = "Zeige Zonen im Tracker";
ShaguQuest_SORT_TRACKER = "Sortiere Quests im Tracker";
ShaguQuest_LOCK_TRACKER = "Tracker sperren";
ShaguQuest_ADD_NEW = "Neue Quests im Tracker anzeigen";
ShaguQuest_ADD_UNTRACKED = "F\195\188ge Quests die in Arbeit sind dem Tracker hinzu.";
ShaguQuest_REMOVE_FINISHED = "Entferne beendete Quests aus dem Tracker";
ShaguQuest_MINIMIZE_FINISHED = "Verstecke Ziele f\195\188r beendete Quests";
ShaguQuest_SHOW_MINIMIZER = "Minimierenicon in Tracker zeigen";
ShaguQuest_TRACKERFONTSIZE = "Tracker Schriftgr\195\182\195\159e";


--new
--Some masks
EQL_QUEST_ACCEPTED = "Quest angenommen:";
EQL_COMPLETE = "%(abgeschlossen%)";

--Organize Strings
ShaguQuest_ORGANIZE_TITLE = "Quest Organizer"
ShaguQuest_ORGANIZE_TEXT = "Klicke eine Questgruppe oder\ngib eine ein und klicke OK";

ShaguQuest_POPUP_MOVE = "Verschiebe Quest in andere Gruppe";
ShaguQuest_POPUP_RESET = "Verschiebe Quest in Originalgruppe";
ShaguQuest_POPUP_RESETALL = "Alle Quests zur\195\188cksetzen";
ShaguQuest_POPUP_CANCEL = "Abbruch";
ShaguQuest_OKAY = "OK";
ShaguQuest_POPUP_TRACK = "Quest verfolgen";
ShaguQuest_POPUP_UNTRACK = "Questverfolgung deaktivieren";


--Load
ShaguQuest_LOAD_TIP = "Lade Einstellungen";


-- new to 3.5.6
ShaguQuest_HIDE_COMPLETED_OBJECTIVES = "Verstecke fertige Ziele einzeln";
ShaguQuest_AUTO_COMPLETE_QUESTS = "Quests automatisch fertig stellen";
ShaguQuest_SHOW_OBJECTIVE_MARKERS = "Zeige Zielmarkierungen";
ShaguQuest_LEVELS_ONLY_IN_LOG = "Nur in Log und Tracker";


-- 3.6.0
ShaguQuest_TOOLTIP_OPTIONS = "Tooltip Optionen";
ShaguQuest_SHOW_ITEM_TOOLTIP = "Zeige Quest im Gegenstands-Tooltip";
ShaguQuest_SHOW_MOB_TOOLTIP = "Zeige Quest im Mob-Tooltip";
ShaguQuest_INFO_ON_QUEST_COMPLETE = "Informiere bei beendetem Quest";
ShaguQuest_TOOLTIP_COLOR = "Benutzerdefinierte Tooltip-Farbe";


end
