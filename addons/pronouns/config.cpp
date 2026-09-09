#include "dialog\SQF_UserInput.hpp"

class CfgPatches
{
    class SQF_Anomalies
    {
        author = "Scout, Queen & Friends";
		name = "pronouns";
		url = "";
		requiredAddons[] = 
        {
            "ace_nametags"
        };
		requiredVersion = 2.22;
		units[] = {};
		weapons[] = {};
    };
};



class Extended_PostInit_EventHandlers
{
    class SQF_Pronouns_Scripts
    {
        init = "call compile preprocessFileLineNumbers '\z\sqf\addons\pronouns\XEH_postInit.sqf'";
    };
};

class CfgFunctions
{
    class SQF 
    {
        class functions
        {
            file = "\z\sqf\addons\pronouns\functions";
            class drawPronouns{};
            class getPronouns{};
            class onDrawPronoun{};
            class updatePronounSettings{};
            class selectPronoun{};
        };
    };
};


class CfgVehicles
{
    class Man;
    class CAManBase: Man
    {
        class ACE_SelfActions {
            class SQF_Pronouns {
                displayName = "Set Pronouns";
                condition = "";
                exceptions[] = {};
                statement = "createDialog 'SQF_UserInput_Dialog'";
                //icon = "\z\dance.paa";
            };
        };
    };
};
