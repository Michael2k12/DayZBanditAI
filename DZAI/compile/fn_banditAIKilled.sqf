//AIKilled Version 0.06
//Updates current live AI count, adds loot to AI corpse if killed by a player, reveals the killer to the victim's group.
private["_weapongrade","_victim","_killer","_unitGroup","_groupLeader","_killerDist","_removeNVG"];
_victim = _this select 0;
_killer = _this select 1;

_removeNVG = _victim getVariable["removeNVG",0];
if (_removeNVG == 1) then {_victim removeWeapon "NVGoggles";}; //Remove temporary NVGs from AI.

DZAI_numAIUnits = (DZAI_numAIUnits - 1);
if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: AI killed. %1 AI units left.",DZAI_numAIUnits];};

if (!isPlayer _killer) exitWith {};

_unitGroup = group _victim;
_killerDist = _victim distance _killer;
_groupLeader = leader _unitGroup;


//Group leader will investigate killer's last known position if it is within 500 meters.
if (((random 1) < DZAI_revealChance) && (_killerDist < 500)) then {
	_unitGroup reveal [_killer,4];
	(leader _unitGroup) doMove (getPos _killer);
	diag_log "DEBUG :: Moving group leader to killer's last known position.";
};

_weapongrade = [DZAI_weaponGrades,DZAI_gradeChances1] call fnc_selectRandomWeighted;	//For pistols, calculate weapongrade using default grade chances
if (DZAI_debugLevel > 1) then {diag_log format["DZAI Extended Debug: AI killed by player. Generating loot with weapongrade %1 (fn_banditAIKilled).",_weapongrade];};
[_victim, _weapongrade] call fnc_unitSelectPistol;				// Add sidearm
[_victim] call fnc_unitConsumables;								// Add food, medical, misc, skin
[_victim] call fnc_unitTools;									// Add tools and gadget
