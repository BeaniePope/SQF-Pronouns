/*
 * Author: commy2 & Queen!
 * Returns the pronouns of the object.
 *
 * Arguments:
 * 0: Object <OBJECT>
 * 1: Use effective commander name when used on vehicles <BOOL> (default: false)
 * 
 *
 * Return Value:
 * Object Name <STRING>
 *
 * Example:
 * [player, false, true] call sqf_fnc_getPronouns;
 *
 * 
 */

params ["_unit", ["_showEffective", false]];

private _pronouns = "";

if (_unit isKindOf "CAManBase") then {
    _pronouns = _unit getVariable ["SQF_Pronouns", "Ask me for Pronouns!"];
} else {
    if (_showEffective) then {
        _pronouns = [effectiveCommander _unit, false] call sqf_fnc_getPronouns;
    } else {
        _pronouns = "Ask me for Pronouns!";
    };
};

_pronouns
