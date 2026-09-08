
/*
 * Author: commy2, esteldunedain, Drift_91 & Queen :D
 * Draw WOKE liberal pronouns
 *
 * Arguments:
 * 0: Unit (Player) <OBJECT>
 * 1: Target <OBJECT>
 * 2: Alpha <NUMBER>
 * 3: Height offset <NUMBER>
 * 4: Draw name <BOOL>
 *
 *
 *
 * Return Value:
 * None
 *
 * Example:
 * [ACE_player, bob, 0.5, height, true] call sqf_fnc_drawPronouns
 *
 * 
 */



params ["", "_target", "", "_heightOffset"];

private _fnc_parameters = {
    params ["_player", "_target", "_alpha", "_heightOffset", "_drawPronouns"];

    //Set Text:
    private _name = if (_drawPronouns) then {
        [_target, true] call sqf_fnc_getPronouns;
    } else {
        ""
    };

    //Set Color:
    private _color = [1, 1, 1, _alpha];
    if ((group _target) != (group _player)) then {
        _color = +ace_nametag_defaultNametagColor; //Make a copy, then multiply both alpha values (allows client to decrease alpha in settings)
    } else {
        _color = +([
            "ace_nametags_nametagColorMain",
            "ace_nametags_nametagColorRed",
            "ace_nametags_nametagColorGreen",
            "ace_nametags_nametagColorBlue",
            "ace_nametags_nametagColorYellow"
        ] select (
            (["MAIN", "RED", "GREEN", "BLUE", "YELLOW"] find ([assignedTeam _target] param [0, "MAIN"])) max 0
        ));
    };
    _color set [3, (_color select 3) * _alpha];

    private _scale = [0.333, 0.5, 0.666, 0.83333, 1] select ace_nametags_tagSize;

    [
        "",
        _color,
        [],
        _scale,
        _scale,
        0,
        _name,
        2,
        (0.05 * _scale),
        "RobotoCondensed"
    ]
};

private _parameters = [_this, _fnc_parameters, _target, "sqf_pronouns_drawParameters", 0.1] call ace_common_fnc_cachedCall;
_parameters set [2, _target modelToWorldVisual ((_target selectionPosition "pilot") vectorAdd [0,0,(_heightOffset + .35)])];


drawIcon3D _parameters;
