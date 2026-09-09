
/*
 * Author: Whoever tf wrote this from ACE + Queen
 * on draw3d
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call sqf_fnc_onDrawPronoun;
 *
 * 
 */

// Don't show nametags in spectator or if RscDisplayMPInterrupt is open
if ((isNull ACE_player) || {!alive ACE_player} || {!isNull (findDisplay 49)}) exitWith {};

private _flags = [[], ace_nametags_fnc_getCachedFlags, ACE_player, "ace_nametags_flagsCache", 2] call ace_common_fnc_cachedCall;

_flags params ["_drawPronouns", "_drawRank", "_enabledTagsNearby", "_enabledTagsCursor", "_maxDistance"];

private _onKeyPressAlphaMax = 1;
if (ace_nametags_showPlayerNames == 3) then {
    _onKeyPressAlphaMax = 2 + (ace_nametags_showNamesTime - CBA_missionTime);
    _enabledTagsNearby = _enabledTagsNearby || {_onKeyPressAlphaMax > 0}
};
if (ace_nametags_showPlayerNames == 4) then {
    _onKeyPressAlphaMax = 2 + (ace_nametags_showNamesTime - CBA_missionTime);
    _enabledTagsCursor = _onKeyPressAlphaMax > 0;
};

private _camPosAGL = positionCameraToWorld [0, 0, 0];
if !((_camPosAGL select 0) isEqualType 0) exitWith {}; // handle RHS / bugged vehicle slots

private _camPosASL = AGLToASL _camPosAGL;

// Show nametag for the unit behind the cursor or its commander
if (_enabledTagsCursor) then {
    private _target = cursorTarget;
    if !(_target isKindOf "CAManBase") then {
        // When cursorTarget is on a vehicle show the nametag for the commander.
        if (_target in allUnitsUAV) then {
            _target = objNull;
        } else {
            _target = effectiveCommander _target;
        };
    };
    if (isNull _target) exitWith {};
};

// Show nametags for nearby units
if (_enabledTagsNearby) then {
    // Find valid targets and cache them
    private _targets = [[], {
        private _fnc_basicChecks = {
            params ["_unit"];
            private _forceShowTags = _unit getVariable ["ace_nametags_fnc_forceShowTags", false];
            _unit != ACE_player && {_forceShowTags || (side group _unit) == (side group ACE_player)} &&
            {ace_nametags_showNamesForAI || _forceShowTags || {_unit call ace_common_fnc_isPlayer}}
        };

        private _nearMen = nearestObjects [_camPosAGL, ["CAManBase"], _maxDistance + 7];
        _nearMen = _nearMen select {
            _x call _fnc_basicChecks &&
            {lineIntersectsSurfaces [_camPosASL, eyePos _x, ACE_player, _x] isEqualTo []} &&
            {!isObjectHidden _x}
        };
        private _crewMen = [];
        if (!isNull objectParent ACE_player) then {
            _crewMen = (crew vehicle ACE_player) select {
                _x call _fnc_basicChecks &&
                {lineIntersectsSurfaces [_camPosASL, eyePos _x, ACE_player, _x, true, 1, "GEOM", "NONE"] isEqualTo []} &&
                {!isObjectHidden _x}
            };
        };
        (_nearMen + _crewMen)
    }, missionNamespace, "ace_nametags_fnc_nearMen", 0.5] call ace_common_fnc_cachedCall;

    {
        private _target = _x;

        if !(isNull _target) then {
            private _drawSoundwave = (ace_nametags_showSoundWaves > 0) && {[_target] call ace_nametags_fnc_isSpeaking};
            if (_enabledTagsCursor && {!_drawSoundwave}) exitWith {}; // (Cursor Only && showSoundWaves==2) - quick exit

            private _relPos = (visiblePositionASL _target) vectorDiff _camPosASL;
            private _distance = vectorMagnitude _relPos;

            // Fade on border
            private _centerOffsetFactor = 1;
            if (ace_nametags_showPlayerNames == 5) then {
                private _screenPos = worldToScreen (_target modelToWorld (_target selectionPosition "head"));
                if (_screenPos isNotEqualTo []) then {
                    // Distance from center / half of screen width
                    _centerOffsetFactor = 1 - ((_screenPos distance2D [0.5, 0.5]) / (safeZoneW / 3));
                } else {
                    _centerOffsetFactor = 0;
                };
            };

            private _alphaMax = _onKeyPressAlphaMax;
            if ((ace_nametags_showSoundWaves == 2) && _drawSoundwave) then {
                _drawPronouns = _drawSoundwave;
                _drawRank = false;
                _alphaMax = 1;
            };
            // Alpha:
            // - base value determined by GVAR(playerNamesMaxAlpha)
            // - decreases when _distance > _maxDistance
            // - increases when the unit is speaking
            // - it's clamped by the value of _onKeyPressAlphaMax unless soundwaves are forced on and the unit is talking
            private _alpha = (((1 + ([0, 0.2] select _drawSoundwave) - 0.2 * (_distance - _maxDistance)) min 1) * ace_nametags_playerNamesMaxAlpha * _centerOffsetFactor) min _alphaMax;

            if (_alpha > 0) then {
                [ACE_player, _target, _alpha, _distance * 0.026, _drawPronouns] call sqf_fnc_drawPronouns;
            };
        };
    } forEachReversed _targets;
};
