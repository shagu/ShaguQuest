-- French localization for Extended Questlog 3.5
-- Thanks to Shaeck, khellendros and Trucifix
-- Extended QuestLog is Copyright © 2006 Daniel Rehn

--[[--------------------------------------------------------------------------------
Special Keys in French:
-- é = \195\169
-- è = \195\168
-- ê = \195\170

Questlog = Journal des quêtes ( Non traduit par manque de place)
Tracker = Le suivi des quêtes ( Non traduit par manque de place)
-----------------------------------------------------------------------------------]]

if ( GetLocale() == "frFR" ) then


ShaguQuest_QUEST_LOG = "Extention du Questlog";

ShaguQuest_OPTIONS = "Options";
ShaguQuest_OPTIONS_INFO = "Ouvrir les options du Questlog";
ShaguQuest_OPTIONS_TITLE = ShaguQuest_QUEST_LOG.." "..ShaguQuest_OPTIONS;

ShaguQuest_QUEST_WATCH_TOOLTIP = "Shift-click sur une qu\195\170te pour ajouter ou enlever du Tracker.\n\nCtrl-click pour ajouter le statut actuel dans la fen\195\170tre de chat.\n\nCtrl-Shift-click pour effacer du Tracker et ajouter la qu\195\170te cliqu\195\169e.";

ShaguQuest_SHRINK = "Normal";
ShaguQuest_EXTEND = "Agrandir";
ShaguQuest_RESTORE = "Restaurer";

ShaguQuest_MINIMIZE_TIP = "Restaurer le QuestLog";
ShaguQuest_MAXIMIZE_TIP = "Agrandir le Questlog";

ShaguQuest_LOG_OPTIONS = "Options du Journal";
ShaguQuest_SHOW_QUEST_LEVELS = "Montrer le niveau des qu\195\170tes";
ShaguQuest_RESTORE_UPON_SELECT = "Agrandir la s\195\169lection";
ShaguQuest_MINIMIZE_UPON_CLOSE = "R\195\169duire si fermer (Taille normal r\195\169ouverture)";
ShaguQuest_LOCK_QUESTLOG = "V\195\169rouiller le QuestLog";
ShaguQuest_OPACITY = "Transparence du Journal";

ShaguQuest_COLOR_OPTIONS = "Options des couleurs";
ShaguQuest_ZONE_COLOR = "Modifier la couleur de la zone";
ShaguQuest_HEADER_COLOR = "Modifier la couleur d'en-t\195\170te";
ShaguQuest_OBJECTIVE_COLOR = "Modifier la couleur des objectifs";
ShaguQuest_FADE_HEADER = "La couleur d'en-t\195\170te fane";
ShaguQuest_FADE_OBJECTIVE = "La couleur des objectifs fane";
ShaguQuest_TRACKER_BG = "Couleur de l'arri\195\168re plan du Tracker";
ShaguQuest_RESTORE_COLORS = "Restaurer les couleurs";

ShaguQuest_QUEST_TRACKER = "Extension du Tracker";

ShaguQuest_TRACKER_OPTIONS = "Options du Tracker";
ShaguQuest_USE_TRACKER_LISTING = "Utiliser la liste du Tracker";
ShaguQuest_SHOW_ZONES = "Montrer les zones dans le Tracker";
ShaguQuest_SORT_TRACKER = "Trier les qu\195\170tes du Tracker";
ShaguQuest_LOCK_TRACKER = "V\195\169rouiller le Tracker";
ShaguQuest_ADD_NEW = "Ajouter les nouvelles qu\195\170tes dans le Tracker"; --Traduction incertaine
ShaguQuest_ADD_UNTRACKED = "Arr\195\170ter de suivre la progression des qu\195\170tes";
ShaguQuest_REMOVE_FINISHED = "Enlever les qu\195\170tes termin\195\169es du Traker";
ShaguQuest_MINIMIZE_FINISHED = "Cacher les objectifs des qu\195\170tes accomplis";
ShaguQuest_SHOW_MINIMIZER = "Montrer le bouton de r\195\169duction du Tracker";
ShaguQuest_TRACKERFONTSIZE = "Taille de la police du Tracker";


--new
--Some masks
EQL_QUEST_ACCEPTED = "Qu\195\170te accept\195\169e:";
EQL_COMPLETE = "%(Accompli%)";

--Organize Strings
ShaguQuest_ORGANIZE_TITLE = "Organisation des qu\195\170tes"
ShaguQuest_ORGANIZE_TEXT = "Cliquer sur un lieu ou tapper\nun nouveau et appuyer sur OK"

ShaguQuest_POPUP_MOVE = "D\195\169placer la qu\195\170te dans un autre groupe";
ShaguQuest_POPUP_RESET = "Restaurer la qu\195\170te dans son groupe d'origine";
ShaguQuest_POPUP_RESETALL = "Restaurer toutes les qu\195\170tes";
ShaguQuest_POPUP_CANCEL = "Annuler";
ShaguQuest_OKAY = "OK";
ShaguQuest_POPUP_TRACK = "Suivre la qu\195\170te";
ShaguQuest_POPUP_UNTRACK = "Arr\195\170ter de suivre la qu\195\170te";


--Load
ShaguQuest_LOAD_TIP = "Charger les options";


-- new to 3.5.6
ShaguQuest_HIDE_COMPLETED_OBJECTIVES = "Cacher individuelement les objectifs accomplis";
ShaguQuest_AUTO_COMPLETE_QUESTS = "Valider automatiquement les qu\195\170tes accomplies";
ShaguQuest_SHOW_OBJECTIVE_MARKERS = "Montrer les marquages des objectifs";
ShaguQuest_LEVELS_ONLY_IN_LOG = "Seulement dans le Questlog et le Tracker";


-- news 3.6.0
ShaguQuest_TOOLTIP_OPTIONS = "Options Tooltip";
ShaguQuest_SHOW_ITEM_TOOLTIP = "Montrer un objet appropri\195\169 \195\160 une qu\195\170te dans le Tooltip";
ShaguQuest_SHOW_MOB_TOOLTIP = "Montrer un mosntre appropri\195\169 \195\160 une qu\195\170te dans le Tooltip";
ShaguQuest_INFO_ON_QUEST_COMPLETE = "Informer sur l'accomplissement d'une qu\195\170te";
ShaguQuest_TOOLTIP_COLOR = "Modifier la couleur des infos dans le Tooltip";


end
