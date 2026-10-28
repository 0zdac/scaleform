-- GameSense CS:GO Legacy 2015/2016 Scaleform HUD
-- Standalone port of inspoo/scaleform.cpp and inspoo/files/*.js.
local enabled=ui.new_checkbox("MISC","Miscellaneous","Legacy Scaleform HUD")
local COLORS={[0]="#e8e8e8",[1]="#ffffff",[2]="#96c8ff",[3]="#356eff",[4]="#c864ff",[5]="#ff2924",[6]="#ff7124",[7]="#fff724",[8]="#3eff24",[9]="#24ff90",[10]="#ff7999",[11]="#d0d198"}
local dirty,force,win_dirty,death_dirty,team_dirty=false,false,false,false,false
local last_color,last_alpha,last_weapon,last_showcount,last_pos=nil,nil,nil,nil,nil
local function run(js,name)
 local ok,err=pcall(function() panorama.loadstring(js,"CSGOHud")() end)
 if not ok then
  client.log("[Legacy Scaleform HUD] Panorama error in "..(name or "unnamed")..": "..tostring(err))
 end
 return ok
end
local function weapon_index() local lp=entity.get_local_player(); if not lp then return nil end; local w=entity.get_player_weapon(lp); if not w then return nil end; return entity.get_prop(w,"m_iItemDefinitionIndex") end
local health_and_ammo_js=[=[var contextPanel = $.GetContextPanel();
contextPanel.FindChildTraverse('HudHealthArmor').style.marginLeft = '0px';
var hudHa = contextPanel.FindChildTraverse('HudHealthArmor');
/* <---- REMOVALS ----> */
hudHa.FindChildTraverse('HudHealthBG').style.backgroundColor = '#00000000';
hudHa.FindChildTraverse('HudArmorBG').style.backgroundColor = '#00000000';
/* <--------> */
for (var hud_container of hudHa.FindChildrenWithClassTraverse('hud-HA-icon-container')) {
    hud_container.style.x = '10px';
    hud_container.style.y = '3px';
    hud_container.style.width = '30px';
    hud_container.style.height = '100%';
    hud_container.style.opacity = '1.0';
    hud_container.style.marginTop = '-1px';
}
for (var hudHaArmor of hudHa.FindChildrenWithClassTraverse('hud-HA-armor1')) {
    hudHaArmor.style.x = '38px';
    hudHaArmor.style.y = '3px';
    hudHaArmor.style.width = '65px';
    hudHaArmor.style.fontFamily = 'Stratum2, "Arial Unicode MS"';
    hudHaArmor.style.fontSize = '42px';
    hudHaArmor.style.fontWeight = 'bold';
    hudHaArmor.style.color = '#ffffff';
    hudHaArmor.style.letterSpacing = '0px';
    hudHaArmor.style.horizontalAlign = 'left';
    hudHaArmor.style.textShadow = '0px 0px 3px 0.0 #000000DD';
    hudHaArmor.style.marginLeft = '5px';
}
for (var hudHaHealth of hudHa.FindChildrenWithClassTraverse('hud-HA-health1')) {
    hudHaHealth.style.x = '38px';
    hudHaHealth.style.y = '3px';
    hudHaHealth.style.width = '65px';
    hudHaHealth.style.fontFamily = 'Stratum2, "Arial Unicode MS"';
    hudHaHealth.style.fontSize = '42px';
    hudHaHealth.style.fontWeight = 'bold';
    hudHaHealth.style.color = '#ffffff';
    hudHaHealth.style.letterSpacing = '0px';
    hudHaHealth.style.horizontalAlign = 'center';
    hudHaHealth.style.textShadow = '0px 0px 3px 0.0 #000000DD';
    hudHaHealth.style.marginLeft = '5px';
}
for (var hudHaText of hudHa.FindChildrenWithClassTraverse('hud-HA-text')) {
    hudHaText.style.x = '42px';
    hudHaText.style.y = '4px';
    hudHaText.style.S2MixBlendMode = 'SRGBadditive';
    hudHaText.style.transform = 'scaleY(1.05)';
}
for (var hudHaBar of hudHa.FindChildrenWithClassTraverse('hud-HA-bar')) {
    hudHaBar.style.x = '108px';
    hudHaBar.style.y = '34px';
    hudHaBar.style.backgroundColor = '#03030399';
}
for (var hudHaGeneric of hudHa.FindChildrenWithClassTraverse('hud-HA')) {
    hudHaGeneric.style.width = '465px';
    hudHaGeneric.style.height = '55px';
    hudHaGeneric.style.verticalAlign = 'bottom';
    hudHaGeneric.style.opacity = '0.0';
    hudHaGeneric.style.transitionProperty = 'opacity';
    hudHaGeneric.style.transitionTimingFunction = 'ease-in-out';
    hudHaGeneric.style.transitionDuration = '0.3s';
    hudHaGeneric.style.marginLeft = '0px';
    if (hudHaGeneric.BHasClass('hud-HA--active')) {
        for (var hudHaGeneric_active of hudHa.FindChildrenWithClassTraverse('hud-HA--active')) {
            hudHaGeneric_active.style.opacity = '1.0';
        }
    }
}
for (var survival of hudHa.FindChildrenWithClassTraverse('survival')) {
    for (var inner of survival.FindChildrenWithClassTraverse('hud-HA')) {
        inner.style.width = '550px';
    }
}
for (var hudHaBg of hudHa.FindChildrenWithClassTraverse('hud-HA-bg')) {
    hudHaBg.style.flowChildren = 'right';
    hudHaBg.style.width = '100%';
    hudHaBg.style.height = '100%';
    hudHaBg.style.opacity = '1.0';
}
for (var hudHaBgH of hudHa.FindChildrenWithClassTraverse('hud-HA-bg-h')) {
    hudHaBgH.style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/hp.png")'; // HP.png
    hudHaBgH.style.backgroundSize = '107% 100%';
    hudHaBgH.style.backgroundImgOpacity = '1';
    hudHaBgH.style.width = '200px';
    hudHaBgH.style.height = '100%';
    hudHaBgH.style.horizontalAlign = 'left';
}

for (var hudHaBgA of hudHa.FindChildrenWithClassTraverse('hud-HA-bg-a')) {
    hudHaBgA.style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/armor.png")'; // Armor.png
    hudHaBgA.style.backgroundSize = '100% 100%';
    hudHaBgA.style.backgroundImgOpacity = '1.0';
    hudHaBgA.style.width = '210px';
    hudHaBgA.style.height = '100%';
    hudHaBgA.style.opacity = '1';
    hudHaBgA.style.horizontalAlign = 'left';
    hudHaBgA.style.overflow = 'noclip';
}

for (var onDmg of hudHa.FindChildrenWithClassTraverse('hud-HA--on-damage')) {
    for (var dmg of onDmg.FindChildrenWithClassTraverse('hud-HA-text')) {
        dmg.style.washColor = '#ff0000';
    }
}

for (var oncrit of hudHa.FindChildrenWithClassTraverse('hud-HA--critical')) {
    for (var hudHaBg of oncrit.FindChildTraverse('HudHealthArmor').FindChildrenWithClassTraverse('hud-HA-bg-h')) {
        hudHaBg.style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/hpred.png")';
        hudHaBg.style.backgroundImgOpacity = '1';
    }
}

for (var health of contextPanel.FindChildTraverse('HudHealthArmor').FindChildrenWithClassTraverse('hud-HA-icon--health')) {

    health.SetImage('https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/healtharmor/hp.png');
	health.style.width = '55px';
	health.style.height = '55px';
    health.style.marginTop = '0px';
    health.style.overflow = 'noclip';
    health.style.backgroundColor = '#00000000';
}

for (var shield of contextPanel.FindChildTraverse('HudHealthArmor').FindChildrenWithClassTraverse('hud-HA-icon--helmet')) {
    shield.SetImage('https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/healtharmor/helmet.png');
	shield.style.width = '55px';
	shield.style.height = '55px';
    shield.style.marginTop = '0px';
    shield.style.overflow = 'noclip';
    shield.style.backgroundColor = '#00000000';
}

for (var shield of contextPanel.FindChildTraverse('HudHealthArmor').FindChildrenWithClassTraverse('hud-HA-icon--armor')) {
    shield.SetImage('https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/healtharmor/armor.png');
	shield.style.width = '55px';
	shield.style.height = '55px';
    shield.style.marginTop = '0px';
    shield.style.overflow = 'noclip';
    shield.style.backgroundColor = '#00000000';
}]=]
local weapon_select_js=[=[var weapon_selection_bg = $.GetContextPanel().FindChildrenWithClassTraverse('weapon-row-background');
var weapon_selection = $.GetContextPanel().FindChildrenWithClassTraverse('weapon-row');
var weapon_selection_number = $.GetContextPanel().FindChildrenWithClassTraverse('weapon-row-number');
for (var j = 0; j < 9; j++) {
    for (rarity of $.GetContextPanel().FindChildrenWithClassTraverse("weapon-selection-item--rarity-" + (j == 8 ? 99 : j))) {
        if (j == 0)
            rarity.Children()[0].Children()[0].style.imgShadow = '0px 0px 0px 0 transparent';
        for (name of rarity.GetParent().GetParent().FindChildrenWithClassTraverse('weapon-selection-item-name-text')) {
            name.style.textShadowFast = '0px 0px transparent';
            name.style.fontWeight = 'bold';
            if (name.text == "Zeus x27")
                name.style.color = '#FFFFFF';
            else
                name.style.color = j == 0 ? '#FFFFFF' :
                    j == 1 ? '#b0c3d9' :
                        j == 2 ? '#5e98d9' :
                            j == 3 ? '#4b69ff' :
                                j == 4 ? '#8847ff' :
                                    j == 5 ? '#d32ce6' :
                                        j == 6 ? '#eb4b4b' :
                                            j == 7 ? '#e4ae39' :
                                                '#ffd700';
        }
    }
}
for (var i = 0; i < 8; i++) {
    if (weapon_selection[i] != undefined && weapon_selection[i].IsSizeValid()) {
        weapon_selection_bg[i].style.backgroundColor = 'transparent';
        weapon_selection_bg[i].style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/weapon.png")';
        weapon_selection_bg[i].style.backgroundSize = '100% 100%';
        weapon_selection_bg[i].style.width = '320px';
        weapon_selection_bg[i].style.horizontalAlign = 'right';
        weapon_selection[i].style.height = '80px';
        weapon_selection_number[i].style.marginTop = '-28px';
        weapon_selection_number[i].style.textShadowFast = '0px 0px transparent';
        weapon_selection_bg[i].style.opacity = '0.55'; //'{1}';
    }
}]=]
local deathnotices_js=[=[var contextPanel = $.GetContextPanel();
for (var dnBackground of contextPanel.FindChildrenWithClassTraverse('DeathNoticeBGBorder')) {

	dnBackground.style.border = '0px solid #00000000';
	dnBackground.style.boxShadow = 'inset #00000000 0px 0px 0px 0px;';
	dnBackground.style.borderRadius = '5px';
	dnBackground.style.height = '110%';
	dnBackground.style.width = '105%';
	dnBackground.style.paddingTop = "0px";
	dnBackground.style.height = '36px';
}

for (var dnBackgroundg of contextPanel.FindChildrenWithClassTraverse('DeathNoticeBG')) {
	dnBackgroundg.style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/fade.png")';
	dnBackgroundg.style.backgroundSize = '100% 100%';
	dnBackgroundg.style.backgroundColor = '#00000000';
	dnBackgroundg.style.opacity = '0.7';
}

for (var dnBackgroundgradient of contextPanel.FindChildrenWithClassTraverse('DeathNoticeBGGradient')) {
	dnBackgroundgradient.style.height = '100%';
	dnBackgroundgradient.style.width = '100%';
	dnBackgroundgradient.opacity = '0.76';
	dnBackgroundgradient.verticalAlign = 'center';
	dnBackgroundgradient.style.boxShadow = 'inset #000000 0px 0px 2px';
}


for (var dnIcon of contextPanel.FindChildrenWithClassTraverse('DeathNoticeIcon')) {
	if (dnIcon.id === "Weapon") {
		dnIcon.style.height = '24px';
		dnIcon.style.verticalAlign = 'top';
		dnIcon.style.uiScale = "70%";
		dnIcon.style.transform = 'translateY(2px)';
		dnIcon.style.margin = '0px 5px 0px 5px';

	} else {
		dnIcon.style.height = '22px';
		dnIcon.style.verticalAlign = 'top';
		dnIcon.style.uiScale = "80%";
		dnIcon.style.margin = '0px 5px 0px 5px';

	}
}

for (var dnT of contextPanel.FindChildrenWithClassTraverse('DeathNoticeTColor')) {
	dnT.style.color = '#f5ca68';
	dnT.style.textShadow = '0px 0px 0px #00000000';
	dnT.style.fontFamily = 'Stratum2, "Arial Unicode MS"';
	dnT.style.fontSize = '21px';
	dnT.style.fontWeight = 'bold';
	dnT.style.letterSpacing = '0.20px';
	dnT.style.verticalAlign = 'bottom';
	dnT.style.textOverflow = 'ellipsis';
	dnT.style.transform = 'scaleX(0.99) scaleY(1.03) translateY(1.9px)';
	dnT.style.S2MixBlendMode = 'SRGBadditive';
}
for (var dnCt of contextPanel.FindChildrenWithClassTraverse('DeathNoticeCTColor')) {
	dnCt.style.color = '#98abd5';
	dnCt.style.textShadow = '0px 0px 0px #00000000';
	dnCt.style.fontFamily = 'Stratum2, "Arial Unicode MS"';
	dnCt.style.fontSize = '21px';
	dnCt.style.fontWeight = 'bold';
	dnCt.style.letterSpacing = '0.20px';
	dnCt.style.verticalAlign = 'bottom';
	dnCt.style.textOverflow = 'ellipsis';
	dnCt.style.transform = 'scaleX(0.99) scaleY(1.03) translateY(1.9px)';
	dnCt.style.S2MixBlendMode = 'SRGBadditive';
}


for (var deathnotice of contextPanel.FindChildrenWithClassTraverse('DeathNotice')) {
	deathnotice.FindChildTraverse('NoScopeIcon').style.visibility = 'collapse';
	deathnotice.FindChildTraverse('ThroughSmokeIcon').style.visibility = 'collapse';
	deathnotice.FindChildTraverse('AttackerBlindIcon').style.visibility = 'collapse';
	deathnotice.FindChildTraverse('Domination').style.visibility = 'collapse';

	deathnotice.style.margin = '0px -8px 1px 18px';


	if (deathnotice.BHasClass('DeathNotice_Killer')) {
		for (var killer of contextPanel.FindChildTraverse('HudDeathNotice').FindChildrenWithClassTraverse('DeathNotice_Killer')) {
			for (var content of killer.FindChildrenWithClassTraverse('DeathNoticeBG')) {
				content.style.border = '1.5px solid #b3070d;';
				content.style.borderRadius = '3px';
				content.style.backgroundColor = 'black';
				content.style.opacity = '0.8';
			}
		}
	}
	if (deathnotice.BHasClass('DeathNotice_Victim')) {
		for (var victim of contextPanel.FindChildTraverse('HudDeathNotice').FindChildrenWithClassTraverse('DeathNotice_Victim')) {
			for (var content of victim.FindChildrenWithClassTraverse('DeathNoticeBG')) {

				content.style.backgroundColor = '#a81313';
				content.style.borderRadius = '3px';
				content.style.boxShadow = 'inset #e10000e6 0px 0px 1px;';
				content.style.opacity = '1';
			}
		}
	}
}]=]
local teamcount_avatar_js=[=[var hudTeamCounter = $.GetContextPanel().FindChildTraverse('HudTeamCounter');
var teamSmallContainerCT = hudTeamCounter ? hudTeamCounter.FindChildTraverse('TeamSmallContainerCT') : null;
var teamSmallContainerT = hudTeamCounter ? hudTeamCounter.FindChildTraverse('TeamSmallContainerT') : null;
if (teamSmallContainerCT) { teamSmallContainerCT.style.width='400px'; teamSmallContainerCT.style.marginRight='-2px'; teamSmallContainerCT.style.horizontalAlign='right'; }
if (teamSmallContainerT) { teamSmallContainerT.style.width='400px'; teamSmallContainerT.style.marginLeft='6px'; teamSmallContainerT.style.horizontalAlign='left'; }
function applyClass(className, callback) {
    if (!hudTeamCounter) return;
    var panels = hudTeamCounter.FindChildrenWithClassTraverse(className);
    for (var i = 0; i < panels.length; i++) callback(panels[i]);
}
applyClass('AvatarL__Default--CT', function(p) { p.style.backgroundSize='92% 86%'; p.style.backgroundPosition='50% 25%'; p.style.backgroundRepeat='no-repeat'; });
applyClass('AvatarL__Default--T', function(p) { p.style.backgroundSize='92% 86%'; p.style.backgroundPosition='50% 25%'; p.style.backgroundRepeat='no-repeat'; });
applyClass('AvatarL__PlayerColor', function(p) { p.style.y='-2px'; p.style.width='24px'; p.style.height='12px'; p.style.marginLeft='0px'; p.style.horizontalAlign='center'; p.style.imgShadow='0px 0px 1px 1.0 #000000CC'; });
applyClass('AvatarL__Internal', function(p) { p.style.height='59px'; p.style.width='85%'; p.style.horizontalAlign='center'; p.style.verticalAlign='top'; p.style.backgroundColor='#7f7f7f'; });
applyClass('AvatarL_HealthBarBG', function(p) { p.style.verticalAlign='bottom'; p.style.marginBottom='1.5px'; p.style.marginRight='1.5px'; p.style.marginLeft='1.5px'; p.style.height='4.55px'; p.style.backgroundColor='#00000040'; p.style.position='absolute'; });
applyClass('AvatarL__ImageBG', function(p) { p.style.width='85%'; p.style.height='59px'; });
applyClass('AvatarL', function(p) { p.style.width='58px'; p.style.height='100px'; p.style.overflow='noclip'; });
applyClass('AvatarS', function(p) { p.style.width='54px'; });
applyClass('AvatarS__Internal', function(p) { p.style.opacity='1'; p.style.width='25px'; p.style.height='28.6px'; p.style.backgroundColor='#7f7f7f'; p.style.verticalAlign='top'; });
applyClass('AvatarS__PlayerImage', function(p) { p.style.backgroundColor='black'; p.style.width='100%'; p.style.height='100%'; p.style.verticalAlign='middle'; });
applyClass('AvatarS__HealthBar', function(p) { p.style.height='3px'; p.style.verticalAlign='bottom'; });
applyClass('AvatarS__Default--CT', function(p) { p.style.backgroundSize='100% 180%'; p.style.backgroundPosition='center'; p.style.height='100%'; p.style.marginRight='9px'; });
applyClass('AvatarS__Default--CT', function(p) { p.style.backgroundImage='url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/teamcounter/teamcounter_alivebgCT.png")'; });
applyClass('AvatarS__Default--T', function(p) { p.style.backgroundSize='100% 180%'; p.style.backgroundPosition='center'; p.style.height='100%'; p.style.marginLeft='9px'; p.style.backgroundImage='url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/teamcounter/teamcounter_alivebgT.png")'; });
applyClass('AvatarImageT__Color', function(p) { p.style.backgroundColor='#87663e'; p.style.border='2px solid #8a6a41'; });
applyClass('AvatarImageT__InternalColor', function(p) { p.style.backgroundColor='#FFFFFF'; });
applyClass('AvatarImageCT__Color', function(p) { p.style.backgroundColor='#72859d'; p.style.border='2px solid #72859d'; });
applyClass('AvatarImageCT__InternalColor', function(p) { p.style.backgroundColor='#FFFFFF'; });
applyClass('Avatar__PlayerOutline--None', function(p) { p.style.border='0px solid #0000000'; });
applyClass('Avatar__PlayerOutline--White', function(p) { p.style.border='2px solid white'; });
applyClass('Avatar__PlayerOutline--T', function(p) { p.style.backgroundColor='#756337'; p.style.border='1px solid #87663e'; });
applyClass('Avatar__PlayerOutline--CT', function(p) { p.style.backgroundColor='#7C858F'; p.style.border='1px solid #4F5D6D'; });
applyClass('Avatar__HealthBar--Normal', function(p) { p.style.backgroundColor='#99ae91'; });
applyClass('TeamCounter__AliveCT', function(p) { p.style.width='55px'; p.style.height='55px'; });
applyClass('TeamCounter__AliveT', function(p) { p.style.width='55px'; p.style.height='55px'; });]=]
local teamcount_score_js=[=[var contextPanel = $.GetContextPanel();
// Teamcount (only score style)
var hudTeamCounter = contextPanel.FindChildTraverse('HudTeamCounter');
hudTeamCounter.style.height = '100%';

var aliveTextT = hudTeamCounter.FindChildTraverse('AliveTextT');
var aliveTextCT = hudTeamCounter.FindChildTraverse('AliveTextCT');

aliveTextT.style.fontSize = '13px';
aliveTextCT.style.fontSize = '13px';

aliveTextT.style.fontWeight = 'light';
aliveTextCT.style.fontWeight = 'light';

aliveTextCT.style.letterSpacing = '0px';
aliveTextT.style.letterSpacing = '0px';

aliveTextCT.style.marginBottom = '-2px';
aliveTextT.style.marginBottom = '-2px';

aliveTextCT.style.marginTop = '-1px';
aliveTextT.style.marginTop = '-1px';

aliveTextT.style.textShadow = '1px 1px 1px 2.0 #000000';
aliveTextCT.style.textShadow = '1px 1px 1px 2.0 #000000';

aliveTextT.style.fontFamily = 'Stratum2';
aliveTextCT.style.fontFamily = 'Stratum2';

aliveTextT.style.color = '#483a2a';
aliveTextCT.style.color = '#454b51';

aliveTextT.style.opacity = '0.57';
aliveTextCT.style.opacity = '0.57';

aliveTextCT.style.horizontalAlign = 'center';
aliveTextT.style.horizontalAlign = 'center';

var winsT = hudTeamCounter.FindChildTraverse('ScoreT');
var winsCT = hudTeamCounter.FindChildTraverse('ScoreCT');
//winsT.style.fontFamily = 'Stratum2 Bold Monodigit';
//winsCT.style.fontFamily = 'Stratum2 Bold Monodigit';

winsT.style.marginTop = '-1px';
winsCT.style.marginTop = '-1px';

winsT.style.color = '#B99636';
winsCT.style.color = '#6f9ec4';

winsT.style.S2MixBlendMode = 'SRGBadditive';
winsCT.style.S2MixBlendMode = 'SRGBadditive';

var timer = hudTeamCounter.FindChildTraverse('TimerText');
//timer.style.fontFamily = 'Stratum2 Bold Monodigit';
//timer.style.marginLeft = '-2px';
timer.style.marginTop = '-3px';
timer.style.marginBottom = '4px';
timer.style.width = '100%';
timer.style.height = '100%';
timer.style.opacity = '1';
timer.style.fontSize = '28px';
timer.style.fontWeight = 'bold';
timer.style.verticalAlign = 'center';
timer.style.fontFamily = 'Stratum2';
timer.style.letterSpacing = '0px';
timer.style.S2MixBlendMode = 'SRGBadditive';
var __list_0 = contextPanel.FindChildTraverse('HudTeamCounter').FindChildrenWithClassTraverse('TeamCounter__AliveT');
for (var __i_0 = 0; __i_0 < __list_0.length; __i_0++) {
    var tAlive = __list_0[__i_0];
    tAlive.style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/teamcounter/teamcounter_alivebgT.png")';
}
var __list_1 = contextPanel.FindChildTraverse('HudTeamCounter').FindChildrenWithClassTraverse('TeamCounter__AliveCT');
for (var __i_1 = 0; __i_1 < __list_1.length; __i_1++) {
    var ctAlive = __list_1[__i_1];
    ctAlive.style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/teamcounter/teamcounter_alivebgCT.png")';
}
var __list_2 = contextPanel.FindChildTraverse('HudTeamCounter').FindChildrenWithClassTraverse('TeamCounter__AliveCount');
for (var __i_2 = 0; __i_2 < __list_2.length; __i_2++) {
    var scoreText = __list_2[__i_2];
    scoreText.style.color = '#ffffff';
}

var aliveBackgroundCT = hudTeamCounter.FindChildTraverse('AliveBackgroundCT');
var aliveBackgroundT = hudTeamCounter.FindChildTraverse('AliveBackgroundT');
if (aliveBackgroundCT) { aliveBackgroundCT.style.width='55px'; aliveBackgroundCT.style.height='55px'; aliveBackgroundCT.style.backgroundImage='url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/teamcounter/teamcounter_alivebgCT.png")'; }
if (aliveBackgroundT) { aliveBackgroundT.style.width='55px'; aliveBackgroundT.style.height='55px'; aliveBackgroundT.style.backgroundImage='url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/teamcounter/teamcounter_alivebgT.png")'; }
var smallContainerCT = hudTeamCounter.FindChildTraverse('TeamSmallContainerCT');
var smallContainerT = hudTeamCounter.FindChildTraverse('TeamSmallContainerT');
if (smallContainerCT) { smallContainerCT.style.width='400px'; smallContainerCT.style.marginRight='-2px'; smallContainerCT.style.horizontalAlign='right'; }
if (smallContainerT) { smallContainerT.style.width='400px'; smallContainerT.style.marginLeft='6px'; smallContainerT.style.horizontalAlign='left'; }
var oldT = hudTeamCounter.FindChildrenWithClassTraverse('AvatarS__Default--T');
for (var oldTi = 0; oldTi < oldT.length; oldTi++) { oldT[oldTi].style.backgroundImage='url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/teamcounter/teamcounter_alivebgT.png")'; }
var oldCT = hudTeamCounter.FindChildrenWithClassTraverse('AvatarS__Default--CT');
for (var oldCTi = 0; oldCTi < oldCT.length; oldCTi++) { oldCT[oldCTi].style.backgroundImage='url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/teamcounter/teamcounter_alivebgCT.png")'; }

var __list_3 = contextPanel.FindChildrenWithClassTraverse('AlertText');
for (var __i_3 = 0; __i_3 < __list_3.length; __i_3++) {
    var sentChat = __list_3[__i_3];
    sentChat.style.backgroundColor = 'gradient( linear, 100% 0%, 0% 0%, from( #00000000 ), color-stop( 0.7, #00000077 ), to( #00000077 ) )';
    sentChat.style.textShadow = '1px 1px 2px #00000055';
    sentChat.style.fontFamily = 'Stratum2';
    sentChat.style.fontWeight = 'normal';
    sentChat.style.fontSize = '21.5px';
    sentChat.style.letterSpacing = '.43px';
    sentChat.style.paddingLeft = '28px';
    sentChat.style.paddingBottom = '0px';
}]=]
local alerts_js=[=[var contextPanel = $.GetContextPanel();
var joinPanelCTBG = "https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/fade.png";
var joinPanelTBG = "https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/fade.png";
var joinPanelBotBG = "https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/fade.png";

for (var hudHint of contextPanel.FindChildrenWithClassTraverse('hud-hint')) {
    hudHint.style.backgroundImage = "url('https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/fade.png')";
    hudHint.style.backgroundColor = '#00000000';
    hudHint.style.width = '450px';
    hudHint.style.height = '109px';
    hudHint.style.backgroundSize = '100% 100%';
    hudHint.style.overflow = 'noclip';
    hudHint.style.backgroundRepeat = 'no-repeat';
    hudHint.style.transform = 'translateY(-100px)';

}

for (var hudHintIcon of contextPanel.FindChildrenWithClassTraverse('hud-hint_icon')) {
    hudHintIcon.style.visibility = 'visible';
    hudHintIcon.style.width = '64px';
    hudHintIcon.style.height = '64px';
    hudHintIcon.style.horizontalAlign = 'left';
    hudHintIcon.style.verticalAlign = 'center';
    hudHintIcon.style.marginLeft = '18px';
    if (hudHintIcon.SetImage) hudHintIcon.SetImage('https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/icons/ui/alert.png');
}
for (var hint of contextPanel.FindChildrenWithClassTraverse('hud-hint__icon')) {
    hint.style.visibility = 'collapse';
}


for (var hudHintText of contextPanel.FindChildrenWithClassTraverse('hud-hint__text')) {
    hudHintText.style.width = '75%';
    hudHintText.style.horizontalAlign = 'right';
    hudHintText.style.textAlign = 'left';
    hudHintText.style.height = '100%';
    hudHintText.style.verticalAlign = 'top';

}

for (var hudHintPriorityLabel of contextPanel.FindChildrenWithClassTraverse('hud-hint__priority-label')) {
    hudHintPriorityLabel.style.horizontalAlign = 'left';
    hudHintPriorityLabel.style.x = '0px';
    hudHintPriorityLabel.style.width = '250px';
    hudHintPriorityLabel.style.overflow = 'noclip';
    hudHintPriorityLabel.style.fontSize = '24px';
    hudHintPriorityLabel.style.fontFamily = 'Stratum2';
    hudHintPriorityLabel.style.color = '#ff5454';
    hudHintPriorityLabel.style.opacity = '0.9';
    hudHintPriorityLabel.style.textAlign = 'left';
    hudHintPriorityLabel.style.letterSpacing = '0px';
    hudHintPriorityLabel.style.marginTop = '5px';

}

for (var hudHintLabel of contextPanel.FindChildrenWithClassTraverse('hud-hint__label')) {
    hudHintLabel.style.horizontalAlign = 'left';
    hudHintLabel.style.height = '90px';
    hudHintLabel.style.verticalAlign = 'top';
    hudHintLabel.style.fontSize = '22px';
    hudHintLabel.style.opacity = '0.9'
}

var hudTeamCounter = contextPanel.FindChildTraverse('HudTeamCounter');
for (var hrTop of hudTeamCounter.FindChildrenWithClassTraverse('hrTop')) {
    hrTop.style.visibility = 'collapse'; // removal
}


var joinPanelCT = hudTeamCounter.FindChildTraverse('JoinPanelCT');
joinPanelCT.style.width = '630px';
joinPanelCT.style.height = '56px';
joinPanelCT.style.horizontalAlign = 'center';
joinPanelCT.style.flowChildren = 'none';
joinPanelCT.style.backgroundImage = `url(${joinPanelCTBG})`;
joinPanelCT.style.backgroundSize = '100% 100%';

var joinPanelT = hudTeamCounter.FindChildTraverse('JoinPanelT');
joinPanelT.style.width = '630px';
joinPanelT.style.height = '56px';
joinPanelT.style.horizontalAlign = 'center';
joinPanelT.style.flowChildren = 'none';
joinPanelT.style.backgroundImage = `url(${joinPanelTBG})`;
joinPanelT.style.backgroundSize = '100% 100%';

var joinPanelBot = hudTeamCounter.FindChildTraverse('JoinPanelBot');
joinPanelBot.style.width = '630px';
joinPanelBot.style.height = '56px';
joinPanelBot.style.horizontalAlign = 'center';
joinPanelBot.style.flowChildren = 'none';
joinPanelBot.style.backgroundImage = `url(${joinPanelBotBG})`;
joinPanelBot.style.backgroundSize = '100% 100%';

var entryTextCt = hudTeamCounter.FindChildTraverse('JoinTextCT');
entryTextCt.style.fontSize = '26px';
entryTextCt.style.fontWeight = 'black';
entryTextCt.style.horizontalAlign = 'center';
entryTextCt.style.verticalAlign = 'top';
entryTextCt.style.letterSpacing = '0px';
entryTextCt.style.marginTop = '12px';
entryTextCt.style.opacity = '0.85';
entryTextCt.style.backgroundColor = 'none';
entryTextCt.style.backgroundImage = 'none';
entryTextCt.style.backgroundSize = '100% 100%';
entryTextCt.style.overflow = 'noclip';
entryTextCt.style.backgroundRepeat = 'no-repeat';
entryTextCt.style.backgroundPosition = '40px -5px';
entryTextCt.style.marginLeft = '0%';

var entryTextT = hudTeamCounter.FindChildTraverse('JoinTextT');
entryTextT.style.fontSize = '26px';
entryTextT.style.fontWeight = 'black';
entryTextT.style.horizontalAlign = 'center';
entryTextT.style.verticalAlign = 'top';
entryTextT.style.letterSpacing = '0px';
entryTextT.style.marginTop = '12px';
entryTextT.style.opacity = '0.85';
entryTextT.style.backgroundColor = 'none';
entryTextT.style.backgroundImage = 'none';
entryTextT.style.backgroundSize = '100% 100%';
entryTextT.style.overflow = 'noclip';
entryTextT.style.backgroundRepeat = 'no-repeat';
entryTextT.style.backgroundPosition = '40px -5px';
var entryTextBot = hudTeamCounter.FindChildTraverse('JoinTextBot');
entryTextBot.style.fontSize = '26px';
entryTextBot.style.fontWeight = 'black';
entryTextBot.style.horizontalAlign = 'center';
entryTextBot.style.verticalAlign = 'top';
entryTextBot.style.letterSpacing = '0px';
entryTextBot.style.marginTop = '12px';
entryTextBot.style.opacity = '0.85';
entryTextBot.style.backgroundColor = 'none';
entryTextBot.style.backgroundImage = 'none';
entryTextBot.style.backgroundSize = '100% 100%';
entryTextBot.style.overflow = 'noclip';
entryTextBot.style.backgroundRepeat = 'no-repeat';
entryTextBot.style.backgroundPosition = '40px -5px';
entryTextBot.style.marginLeft = '0%';

// Top alerts (warmup, start etc)

var hal = contextPanel.FindChildTraverse('HudAlerts');
hal.style.width = '883px';
hal.style.height = '44px';
hal.style.marginTop = '-40px';

for (var hrbot of hal.FindChildrenWithClassTraverse('hrBot')) { hrbot.style.visibility = 'collapse'; }
for (var hrtop of hal.FindChildrenWithClassTraverse('hrTop')) { hrtop.style.visibility = 'collapse'; }

var hal = contextPanel.FindChildTraverse('HudAlerts');
hal.style.width = '883px';
hal.style.height = '44px';
hal.style.marginTop = '-40px';
for (var hrbot of hal.FindChildrenWithClassTraverse('hrBot')) { hrbot.style.visibility = 'collapse'; }
for (var hrtop of hal.FindChildrenWithClassTraverse('hrTop')) { hrtop.style.visibility = 'collapse'; }

var alertText = contextPanel.FindChildTraverse('AlertText');
alertText.style.opacity = '1';
alertText.style.fontSize = '30px';
alertText.style.fontWeight = 'bold';
alertText.style.verticalAlign = 'center';
alertText.style.fontFamily = 'Stratum2';
alertText.style.letterSpacing = '0px';
alertText.style.marginTop = '5px';

var alertBg = contextPanel.FindChildTraverse('AlertBg');
alertBg.style.opacity = '1';
alertBg.style.height = '44px';
alertBg.style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/main/materials/panorama/images/hud/fade.png")';
alertBg.style.backgroundImgOpacity = '0.95';
alertBg.style.backgroundSize = '100% 100%';
alertBg.style.backgroundRepeat = 'no-repeat';
alertBg.style.backgroundColor = '#00000000';]=]
local radar_js=[=[
            var radar = $.GetContextPanel().FindChildTraverse('HudRadar');
			var dashboardbg = $.GetContextPanel().FindChildrenWithClassTraverse('hud-radar')[0].GetChild(0);
            var radar_content = radar.FindChildTraverse('Radar');
            var radar_label = radar.FindChildTraverse('DashboardLabel');
            var label_container = radar_label.GetParent();
            var radar_old_round = radar.FindChildTraverse('Radar__Round--Border');
            var radar_old_square = radar.FindChildTraverse('Radar__Square--Border');
            radar.style.marginTop = '2px';
            radar_content.style.marginTop = '-4px';
            radar_label.style.S2MixBlendMode = 'SRGBadditive';
            radar_label.style.opacity = '0.75';
            radar_label.style.fontWeight = 'medium';
            radar_label.style.letterSpacing = '0.5px';
            radar_label.style.fontSize = '27px';
            radar_label.style.margin = '4px 0px 0px 16px';
            radar_label.style.textOverflow = 'noclip';
            label_container.style.backgroundColor = '#FF000000';
            label_container.style.marginTop = '-2px';
            label_container.style.width = '276px';
            label_container.style.height = '46px';
            label_container.style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/refs/heads/main/materials/panorama/images/hud/location_corner.png")';
            label_container.style.backgroundSize = '100% 100%';
            radar_old_round.style.borderRadius = '50% / 50%';
            radar_old_round.style.borderWidth = '2px';
            radar_old_round.style.borderStyle = 'solid';
            radar_old_round.style.borderColor = '%s';
            radar_old_round.style.opacity = '0.25';
            radar_old_round.style.S2MixBlendMode = 'SRGBadditive';
            radar_old_square.style.borderRadius = '0px';
            radar_old_square.style.borderWidth = '2px';
            radar_old_square.style.borderStyle = 'solid';
            radar_old_square.style.borderColor = '%s';
            radar_old_square.style.opacity = '0.25';
            radar_old_square.style.S2MixBlendMode = 'SRGBadditive';]=]
local weapon_panel_js=[=[
            var wpn = $.GetContextPanel().FindChildTraverse('HudWeaponPanel');
            var wpn_bg = wpn.FindChildTraverse('WeaponPanelBottomBG');
            var wpn_gradient = wpn.FindChildTraverse('WeaponPanelBottomBGGradient');
            var wpn_solid = wpn.FindChildTraverse('WeaponPanelBottomBGSolid');
            var bullet_positions = [35, 27, 19, 11, 3];
            for (var i = 1; i < 6; i++) {
                 var bullet = $.GetContextPanel().FindChildrenWithClassTraverse('AmmoAnim__BulletIcon--Pos' + i)[0];
                 bullet.style.x = bullet_positions[i - 1] + 'px';
                 bullet.style.y = '24px';
            }
            $.GetContextPanel().FindChildTraverse('AmmoTextClip').style.S2MixBlendMode = 'SRGBadditive';
            $.GetContextPanel().FindChildTraverse('HudWeaponSelection').style.marginBottom = '15px';
            wpn.style.marginRight = '0px';
            wpn.style.paddingRight = '-2px';
            wpn_bg.style.backgroundColor = 'transparent';
            wpn_bg.style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/refs/heads/main/materials/panorama/images/hud/weapon.png")';
            wpn_bg.style.backgroundSize = '100% 100%';
            wpn_solid.style.backgroundColor = 'transparent';
            wpn_gradient.style.backgroundColor = 'transparent';]=]
local money_js=[=[
            var m_p = $.GetContextPanel().FindChildTraverse('HudMoney');
            var m_bg = m_p.Children()[0];
            var m_txt = m_p.Children()[1];
            var is_behind = m_txt.Children()[2].paneltype == 'Image';
            var m_txt_lbl = m_txt.Children()[is_behind ? 3 : 2];
            var m_icon = m_txt.Children()[is_behind ? 2 : 4];
            var gi_icons = $.GetContextPanel().FindChildTraverse('HudGameIcons');
            gi_icons.style.marginTop = '33px';
            if (!is_behind)
               m_txt.MoveChildBefore(m_icon, m_txt_lbl);
            m_p.style.marginTop = '0px';
            m_p.style.height = '39px';
            m_p.style.opacity = '1.0';
            m_bg.style.marginLeft = '0px';
            m_bg.style.backgroundColor = 'transparent';
            m_bg.style.backgroundImage = 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/refs/heads/main/materials/panorama/images/hud/ammo.png")';
            m_bg.style.backgroundSize = '100% 100%';
            m_bg.style.width = '257px';
            m_txt_lbl.style.S2MixBlendMode = 'SRGBadditive';
            m_txt_lbl.style.textAlign = 'right';
            m_txt_lbl.style.width = '102px';
            m_txt_lbl.style.marginTop = '1px';
            m_txt_lbl.style.marginLeft = '0px';
            m_txt_lbl.style.letterSpacing = '0px';
            m_txt_lbl.style.fontSize = '33px';
            m_icon.style.S2MixBlendMode = 'SRGBadditive';
            m_icon.style.width = '32px';
            m_icon.style.height = '32px';
            m_icon.style.marginTop = '4px';
            m_icon.style.marginLeft = '14px';]=]
local win_js=[=[
var win_root = $.GetContextPanel().FindChildTraverse('HudWinPanel');
var win_team = win_root.FindChildrenWithClassTraverse('WinPanelTeam')[0];
var win_team_bg = win_team.FindChildrenWithClassTraverse('TeamBG__MainBG')[0];
var win_title = win_team.FindChildTraverse('Title');
var win_mvp = win_root.FindChildTraverse('MVP');
var win_mvp_content = win_mvp.GetParent();
var win_mvp_avatar = win_mvp.FindChildTraverse('MVPAvatar');
var win_mvp_star = win_mvp.FindChildrenWithClassTraverse('MVP__WinnerStar')[0];
var win_mvp_text = win_mvp.FindChildTraverse('MVPWinnerName');
var win_funfact = win_root.FindChildTraverse('Funfact');
var win_funfact_text = win_root.FindChildTraverse('FunFactText');
var did_ctwin = $.GetContextPanel().FindChildrenWithClassTraverse('WinPanelRoot--CTWin')[0] != undefined;
var did_twin = $.GetContextPanel().FindChildrenWithClassTraverse('WinPanelRoot--TWin')[0] != undefined;
var win_icon = win_team.FindChildrenWithClassTraverse('TeamBG__DefaultLogo')[0];
var win_fg = win_team.FindChildrenWithClassTraverse('TeamFG')[0];
win_root.style.y = '111px';
win_root.style.width = '818px';
win_root.style.overflow = 'noclip';
win_root.FindChildrenWithClassTraverse('WinPanelRow--Main')[0].style.height = '125px';
win_root.style.height = '500px';
win_team.style.width = '100%';
win_team.style.height = '100%';
win_title.style.fontSize = '38px';
win_title.style.fontWeight = 'bold';
win_title.style.S2MixBlendMode = 'SRGBadditive';
win_title.style.color = '#999999';
win_title.style.letterSpacing = '0px';
win_mvp_content.style.align = 'left bottom';
win_mvp_content.style.marginLeft = '21px';
win_mvp.style.horizontalAlign = 'left';
win_mvp_avatar.style.width = '60px';
win_mvp_avatar.style.height = '62px';
win_mvp_avatar.style.boxShadow = '#000000 0px 0px 4px 2px';
win_mvp_avatar.style.padding = '0px 0px 0px 0px'
win_mvp_avatar.style.backgroundColor = 'gradient(linear, 0% 0%, 0% 100%, from(#959595), to(#353535))';
win_mvp_text.style.color = '#666666';
win_mvp_text.style.S2MixBlendMode = 'SRGBadditive';
win_mvp_text.style.marginTop = '7px';
win_mvp_text.style.fontWeight = 'bold';
win_mvp_text.style.fontSize = '17.75px';
win_mvp_text.style.letterSpacing = '0px';
win_mvp_star.style.washColor = '#FBB03B';
win_mvp_star.style.marginTop = '4px';
win_mvp_star.style.marginLeft = '3px';
win_mvp_star.style.height = '19px';
win_mvp_star.style.width = '18px';
win_team_bg.style.width = '100%';
win_team_bg.style.height = '100%';
win_team_bg.style.opacity = did_twin ? '1.0' : '0.995';
win_team_bg.style.overflow = 'noclip';
win_team_bg.style.backgroundColor = 'transparent';
win_team_bg.style.backgroundImage = did_twin ? 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/refs/heads/main/materials/panorama/images/hud/mvp2.png")' :
    did_ctwin ? 'url("https://raw.githubusercontent.com/0zdac/csgo2016hud/refs/heads/main/materials/panorama/images/hud/mvp.png")' :
    'none';
win_team_bg.style.backgroundSize = '100% 100%';
win_funfact.style.y = '200px';
win_funfact.style.backgroundColor = '#000000AE';
win_funfact.style.marginTop = '2px';
win_funfact.style.marginLeft = '0px';
win_funfact.style.marginRight = '0px';
win_funfact.style.padding = '6px 6px 8px 6px';
win_funfact.style.color = '#FFFFFFBB';
win_funfact.style.width = '99.9%';
win_funfact_text.style.backgroundColor = 'transparent';
win_funfact_text.style.color = '#FFFFFFAE';
win_funfact_text.style.padding = '0px 0px 0px 0px';
win_funfact_text.style.fontSize = '18px';
win_funfact_text.style.fontWeight = 'bold';
win_funfact_text.style.S2MixBlendMode = 'SRGBadditive';
win_funfact_text.style.letterSpacing = '0px';
win_icon.style.opacity = '0';
win_icon.style.verticalAlign = 'bottom';
win_icon.style.horizontalAlign = 'right';
win_icon.style.width = '69px';
win_icon.style.marginTop = '51px';
win_icon.style.marginRight = '20px';
win_icon.style.marginBottom = '0px';
win_team.FindChildrenWithClassTraverse('TeamBG__hrBot')[0].style.opacity = '0';
win_team.FindChildrenWithClassTraverse('TeamBG__hrTop')[0].style.opacity = '0';
win_team.FindChildrenWithClassTraverse('TeamBG__hrMid')[0].style.opacity = '0';
win_team.FindChildTraverse('TeamLogo').style.opacity = '0';
function set_funfact() {
    win_funfact.style.transition = 'position 0.20s linear 0.0s';
    win_funfact.style.y = '125px';
}
function white_fade_in() {
    win_fg.style.transition = 'background-color 0.10s linear 0.0s';
    win_mvp_star.style.transition = 'wash-color 0.10s linear 0.0s';
    win_mvp_star.style.washColor = '#FFFFFF';
    win_fg.style.backgroundColor = '#FFFFFF';
}
function white_fade_out() {
    win_fg.style.transition = 'background-color 0.20s linear 0.0s';
    win_mvp_star.style.transition = 'wash-color 0.20s linear 0.0s';
    win_mvp_star.style.washColor = '#FBB03B';
    win_fg.style.backgroundColor = 'transparent';
}
$.Schedule(0.20, white_fade_in);
$.Schedule(0.30, white_fade_out);
$.Schedule(1.00, set_funfact);]=]

local function apply()
 if not ui.get(enabled) then return end
 local color=tonumber(cvar.cl_hud_color:get_int()) or 0; local alpha=tonumber(cvar.cl_hud_background_alpha:get_float()) or 0; local showcount=cvar.cl_hud_playercount_showcount and tonumber(cvar.cl_hud_playercount_showcount:get_int()) or 0; local playercount_pos=cvar.cl_hud_playercount_pos and tonumber(cvar.cl_hud_playercount_pos:get_int()) or 0; local changed=force or color~=last_color or alpha~=last_alpha
 if force and cvar.cl_showloadout then pcall(cvar.cl_showloadout.set_int,cvar.cl_showloadout,1) end
 if changed then
  local hex=COLORS[color] or COLORS[11]
  local radar_format=radar_js:gsub("%%s","__HUD_COLOR__"):gsub("%%","%%%%"):gsub("__HUD_COLOR__","%%s")
  run(string.format(radar_format,hex,hex),"radar"); run(health_and_ammo_js,"health_and_ammo")
 end
 if force then run(weapon_panel_js,"weapon_panel"); run(money_js,"money"); run(alerts_js,"alerts") end
 if force or team_dirty then local avatar_js=teamcount_avatar_js:gsub("__BOTTOM_MODE__", playercount_pos == 1 and "true" or "false"); run(teamcount_score_js,"teamcount_score"); run(avatar_js,"teamcount_avatar") end
 if force or death_dirty then run(deathnotices_js,"deathnotices") end; if force or win_dirty then run(win_js,"winpanel") end
 local wi=weapon_index(); if force or wi~=last_weapon then run(weapon_select_js,"weapon_select"); last_weapon=wi end
 last_color,last_alpha,last_showcount,last_pos=color,alpha,showcount,playercount_pos; dirty,force,win_dirty,death_dirty,team_dirty=false,false,false,false,false
end
local function mark(f) dirty=true; if f then force=true end end
client.set_event_callback("level_init",function() last_color,last_alpha,last_weapon,last_showcount,last_pos=nil,nil,nil,nil,nil; mark(true); apply(); client.delay_call(0.5,function() if ui.get(enabled) then mark(true); apply() end end) end)
client.set_event_callback("round_end",function() win_dirty=true; death_dirty=true; team_dirty=true; dirty=true end)
client.set_event_callback("player_death",function() death_dirty=true; dirty=true end)
client.set_event_callback("item_equip",function() last_weapon=nil; dirty=true end)
client.set_event_callback("shutdown",function() dirty=false; force=false end)
ui.set_callback(enabled,function() if ui.get(enabled) then last_color,last_alpha,last_weapon,last_showcount,last_pos=nil,nil,nil,nil,nil; mark(true); apply() end end)
-- Paint only observes cached ConVars; JavaScript runs only when dirty or state changes.
 client.set_event_callback("paint",function() if not ui.get(enabled) then return end; local color=tonumber(cvar.cl_hud_color:get_int()) or 0; local alpha=tonumber(cvar.cl_hud_background_alpha:get_float()) or 0; local showcount=cvar.cl_hud_playercount_showcount and tonumber(cvar.cl_hud_playercount_showcount:get_int()) or 0; local playercount_pos=cvar.cl_hud_playercount_pos and tonumber(cvar.cl_hud_playercount_pos:get_int()) or 0; if color~=last_color or alpha~=last_alpha then dirty=true end; if showcount~=last_showcount or playercount_pos~=last_pos then team_dirty=true; dirty=true end; if dirty then apply() end end)
