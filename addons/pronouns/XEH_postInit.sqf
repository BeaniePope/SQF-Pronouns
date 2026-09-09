["CBA_settingsInitialized", {
    // Draw handle
    call SQF_fnc_updatePronounSettings;
}] call CBA_fnc_addEventHandler;

// Change settings accordingly when they are changed
["CBA_SettingChanged", {
    params ["_name"];
    if (_name == "ace_nametags_showPlayerNames") then {
        call SQF_fnc_updatePronounSettings;
    };
}] call CBA_fnc_addEventHandler;

