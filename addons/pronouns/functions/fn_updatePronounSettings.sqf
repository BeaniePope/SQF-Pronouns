/*
 * Author: Jonpas
 * Dynamically adds and removes Draw3D based on settings on run-time.
 * Modified by Queen for pronouns :D
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call ace_nametags_fnc_updateSettings
 *
 * 
 */

if (isNil "sqf_pronouns_drawHandler" && {ace_nametags_showPlayerNames != 0}) then {
    sqf_pronouns_drawHandler = addMissionEventHandler ["Draw3D", {call SQF_fnc_onDrawPronoun;}];
} else {
    if (!isNil "sqf_pronouns_drawHandler" && {ace_nametags_showPlayerNames == 0}) then {
        removeMissionEventHandler ["Draw3D", sqf_pronouns_drawHandler];
        sqf_pronouns_drawHandler = nil;
    };
};
