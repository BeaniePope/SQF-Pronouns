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
        class Super_Ball
        {
            file = "\z\sqf\addons\pronouns\functions";
            class initPronouns{};
            class drawPronouns{};
            class getPronouns{};
            class onDrawPronoun{};
            class updatePronounSettings{};
        };
    };
};
