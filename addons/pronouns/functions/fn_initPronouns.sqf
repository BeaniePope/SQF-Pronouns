["Pronoun Setting", "LIST",
["Pronouns", "Select Pronouns"], 
"User Settings", 
[[0, 1, 2, 3, 4]
,
["she / her","he / him", "they / them", "Name Preferred", "Ask me for pronouns!"], 
4,
0,
{
    params ["_value"];
    player setVariable ["SQF_Pronouns", _value];
}
]] call CBA_fnc_addSetting;

