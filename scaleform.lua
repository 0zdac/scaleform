-- GameSense CS:GO Legacy 2015/2016 Scaleform HUD
-- Team-counter measurements and avatar assets ported from abandonedpools/scaleform.
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
var __list_1 = hudHa.FindChildrenWithClassTraverse('hud-HA-icon-container'); for (var __i_1 = 0; __i_1 < __list_1.length; __i_1++) { var hud_container = __list_1[__i_1];
    hud_container.style.x = '10px';
    hud_container.style.y = '3px';
    hud_container.style.width = '30px';
    hud_container.style.height = '100%';
    hud_container.style.opacity = '1.0';
    hud_container.style.marginTop = '-1px';
}
var __list_2 = hudHa.FindChildrenWithClassTraverse('hud-HA-armor1'); for (var __i_2 = 0; __i_2 < __list_2.length; __i_2++) { var hudHaArmor = __list_2[__i_2];
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
var __list_3 = hudHa.FindChildrenWithClassTraverse('hud-HA-health1'); for (var __i_3 = 0; __i_3 < __list_3.length; __i_3++) { var hudHaHealth = __list_3[__i_3];
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
var __list_4 = hudHa.FindChildrenWithClassTraverse('hud-HA-text'); for (var __i_4 = 0; __i_4 < __list_4.length; __i_4++) { var hudHaText = __list_4[__i_4];
    hudHaText.style.x = '42px';
    hudHaText.style.y = '4px';
    hudHaText.style.S2MixBlendMode = 'SRGBadditive';
    hudHaText.style.transform = 'scaleY(1.05)';
}
var __list_5 = hudHa.FindChildrenWithClassTraverse('hud-HA-bar'); for (var __i_5 = 0; __i_5 < __list_5.length; __i_5++) { var hudHaBar = __list_5[__i_5];
    hudHaBar.style.x = '108px';
    hudHaBar.style.y = '34px';
    hudHaBar.style.backgroundColor = '#03030399';
}
var __list_6 = hudHa.FindChildrenWithClassTraverse('hud-HA'); for (var __i_6 = 0; __i_6 < __list_6.length; __i_6++) { var hudHaGeneric = __list_6[__i_6];
    hudHaGeneric.style.width = '465px';
    hudHaGeneric.style.height = '55px';
    hudHaGeneric.style.verticalAlign = 'bottom';
    hudHaGeneric.style.opacity = '0.0';
    hudHaGeneric.style.transitionProperty = 'opacity';
    hudHaGeneric.style.transitionTimingFunction = 'ease-in-out';
    hudHaGeneric.style.transitionDuration = '0.3s';
    hudHaGeneric.style.marginLeft = '0px';
    if (hudHaGeneric.BHasClass('hud-HA--active')) {
        var __list_7 = hudHa.FindChildrenWithClassTraverse('hud-HA--active'); for (var __i_7 = 0; __i_7 < __list_7.length; __i_7++) { var hudHaGeneric_active = __list_7[__i_7];
            hudHaGeneric_active.style.opacity = '1.0';
        }
    }
}
var __list_8 = hudHa.FindChildrenWithClassTraverse('survival'); for (var __i_8 = 0; __i_8 < __list_8.length; __i_8++) { var survival = __list_8[__i_8];
    var __list_9 = survival.FindChildrenWithClassTraverse('hud-HA'); for (var __i_9 = 0; __i_9 < __list_9.length; __i_9++) { var inner = __list_9[__i_9];
        inner.style.width = '550px';
    }
}
var __list_10 = hudHa.FindChildrenWithClassTraverse('hud-HA-bg'); for (var __i_10 = 0; __i_10 < __list_10.length; __i_10++) { var hudHaBg = __list_10[__i_10];
    hudHaBg.style.flowChildren = 'right';
    hudHaBg.style.width = '100%';
    hudHaBg.style.height = '100%';
    hudHaBg.style.opacity = '1.0';
}
var __list_11 = hudHa.FindChildrenWithClassTraverse('hud-HA-bg-h'); for (var __i_11 = 0; __i_11 < __list_11.length; __i_11++) { var hudHaBgH = __list_11[__i_11];
    hudHaBgH.style.backgroundImage = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/hp.png")'; // HP.png
    hudHaBgH.style.backgroundSize = '107% 100%';
    hudHaBgH.style.backgroundImgOpacity = '1';
    hudHaBgH.style.width = '200px';
    hudHaBgH.style.height = '100%';
    hudHaBgH.style.horizontalAlign = 'left';
}

var __list_12 = hudHa.FindChildrenWithClassTraverse('hud-HA-bg-a'); for (var __i_12 = 0; __i_12 < __list_12.length; __i_12++) { var hudHaBgA = __list_12[__i_12];
    hudHaBgA.style.backgroundImage = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/armor.png")'; // Armor.png
    hudHaBgA.style.backgroundSize = '100% 100%';
    hudHaBgA.style.backgroundImgOpacity = '1.0';
    hudHaBgA.style.width = '210px';
    hudHaBgA.style.height = '100%';
    hudHaBgA.style.opacity = '1';
    hudHaBgA.style.horizontalAlign = 'left';
    hudHaBgA.style.overflow = 'noclip';
}

var __list_13 = hudHa.FindChildrenWithClassTraverse('hud-HA--on-damage'); for (var __i_13 = 0; __i_13 < __list_13.length; __i_13++) { var onDmg = __list_13[__i_13];
    var __list_14 = onDmg.FindChildrenWithClassTraverse('hud-HA-text'); for (var __i_14 = 0; __i_14 < __list_14.length; __i_14++) { var dmg = __list_14[__i_14];
        dmg.style.washColor = '#ff0000';
    }
}

var __list_15 = hudHa.FindChildrenWithClassTraverse('hud-HA--critical'); for (var __i_15 = 0; __i_15 < __list_15.length; __i_15++) { var oncrit = __list_15[__i_15];
    var __list_16 = oncrit.FindChildTraverse('HudHealthArmor').FindChildrenWithClassTraverse('hud-HA-bg-h'); for (var __i_16 = 0; __i_16 < __list_16.length; __i_16++) { var hudHaBg = __list_16[__i_16];
        hudHaBg.style.backgroundImage = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/hpred.png")';
        hudHaBg.style.backgroundImgOpacity = '1';
    }
}

var __list_17 = contextPanel.FindChildTraverse('HudHealthArmor').FindChildrenWithClassTraverse('hud-HA-icon--health'); for (var __i_17 = 0; __i_17 < __list_17.length; __i_17++) { var health = __list_17[__i_17];

    health.SetImage('https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/healtharmor/hp.png');
	health.style.width = '55px';
	health.style.height = '55px';
    health.style.marginTop = '0px';
    health.style.overflow = 'noclip';
    health.style.backgroundColor = '#00000000';
}

var __list_18 = contextPanel.FindChildTraverse('HudHealthArmor').FindChildrenWithClassTraverse('hud-HA-icon--helmet'); for (var __i_18 = 0; __i_18 < __list_18.length; __i_18++) { var shield = __list_18[__i_18];
    shield.SetImage('https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/healtharmor/helmet.png');
	shield.style.width = '55px';
	shield.style.height = '55px';
    shield.style.marginTop = '0px';
    shield.style.overflow = 'noclip';
    shield.style.backgroundColor = '#00000000';
}

var __list_19 = contextPanel.FindChildTraverse('HudHealthArmor').FindChildrenWithClassTraverse('hud-HA-icon--armor'); for (var __i_19 = 0; __i_19 < __list_19.length; __i_19++) { var shield = __list_19[__i_19];
    shield.SetImage('https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/healtharmor/armor.png');
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
        weapon_selection_bg[i].style.backgroundImage = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/weapon.png")';
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
var __list_20 = contextPanel.FindChildrenWithClassTraverse('DeathNoticeBGBorder'); for (var __i_20 = 0; __i_20 < __list_20.length; __i_20++) { var dnBackground = __list_20[__i_20];

	dnBackground.style.border = '0px solid #00000000';
	dnBackground.style.boxShadow = 'inset #00000000 0px 0px 0px 0px;';
	dnBackground.style.borderRadius = '5px';
	dnBackground.style.height = '110%';
	dnBackground.style.width = '105%';
	dnBackground.style.paddingTop = "0px";
	dnBackground.style.height = '36px';
}

var __list_21 = contextPanel.FindChildrenWithClassTraverse('DeathNoticeBG'); for (var __i_21 = 0; __i_21 < __list_21.length; __i_21++) { var dnBackgroundg = __list_21[__i_21];
	dnBackgroundg.style.backgroundImage = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/fade.png")';
	dnBackgroundg.style.backgroundSize = '100% 100%';
	dnBackgroundg.style.backgroundColor = '#00000000';
	dnBackgroundg.style.opacity = '0.7';
}

var __list_22 = contextPanel.FindChildrenWithClassTraverse('DeathNoticeBGGradient'); for (var __i_22 = 0; __i_22 < __list_22.length; __i_22++) { var dnBackgroundgradient = __list_22[__i_22];
	dnBackgroundgradient.style.height = '100%';
	dnBackgroundgradient.style.width = '100%';
	dnBackgroundgradient.opacity = '0.76';
	dnBackgroundgradient.verticalAlign = 'center';
	dnBackgroundgradient.style.boxShadow = 'inset #000000 0px 0px 2px';
}


var __list_23 = contextPanel.FindChildrenWithClassTraverse('DeathNoticeIcon'); for (var __i_23 = 0; __i_23 < __list_23.length; __i_23++) { var dnIcon = __list_23[__i_23];
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

var __list_24 = contextPanel.FindChildrenWithClassTraverse('DeathNoticeTColor'); for (var __i_24 = 0; __i_24 < __list_24.length; __i_24++) { var dnT = __list_24[__i_24];
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
var __list_25 = contextPanel.FindChildrenWithClassTraverse('DeathNoticeCTColor'); for (var __i_25 = 0; __i_25 < __list_25.length; __i_25++) { var dnCt = __list_25[__i_25];
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


var __list_26 = contextPanel.FindChildrenWithClassTraverse('DeathNotice'); for (var __i_26 = 0; __i_26 < __list_26.length; __i_26++) { var deathnotice = __list_26[__i_26];
	deathnotice.FindChildTraverse('NoScopeIcon').style.visibility = 'collapse';
	deathnotice.FindChildTraverse('ThroughSmokeIcon').style.visibility = 'collapse';
	deathnotice.FindChildTraverse('AttackerBlindIcon').style.visibility = 'collapse';
	deathnotice.FindChildTraverse('Domination').style.visibility = 'collapse';

	deathnotice.style.margin = '0px -8px 1px 18px';


	if (deathnotice.BHasClass('DeathNotice_Killer')) {
		var __list_27 = contextPanel.FindChildTraverse('HudDeathNotice').FindChildrenWithClassTraverse('DeathNotice_Killer'); for (var __i_27 = 0; __i_27 < __list_27.length; __i_27++) { var killer = __list_27[__i_27];
			var __list_28 = killer.FindChildrenWithClassTraverse('DeathNoticeBG'); for (var __i_28 = 0; __i_28 < __list_28.length; __i_28++) { var content = __list_28[__i_28];
				content.style.border = '1.5px solid #b3070d;';
				content.style.borderRadius = '3px';
				content.style.backgroundColor = 'black';
				content.style.opacity = '0.8';
			}
		}
	}
	if (deathnotice.BHasClass('DeathNotice_Victim')) {
		var __list_29 = contextPanel.FindChildTraverse('HudDeathNotice').FindChildrenWithClassTraverse('DeathNotice_Victim'); for (var __i_29 = 0; __i_29 < __list_29.length; __i_29++) { var victim = __list_29[__i_29];
			var __list_30 = victim.FindChildrenWithClassTraverse('DeathNoticeBG'); for (var __i_30 = 0; __i_30 < __list_30.length; __i_30++) { var content = __list_30[__i_30];

				content.style.backgroundColor = '#a81313';
				content.style.borderRadius = '3px';
				content.style.boxShadow = 'inset #e10000e6 0px 0px 1px;';
				content.style.opacity = '1';
			}
		}
	}
}]=]
local teamcount_avatar_js=[=[function runner() {
    var hudTeamCounter = $.GetContextPanel().FindChildTraverse('HudTeamCounter');
    if (!hudTeamCounter) return;

    var isBottom = GameInterfaceAPI.GetSettingString('cl_hud_playercount_pos') === '1';
    var ctUrl = 'https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/teamcounter/teamcounter_alivebgCT.png';
    var tUrl = 'https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/teamcounter/teamcounter_alivebgT.png';

    var __list_31 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarL__Default--CT'); for (var __i_31 = 0; __i_31 < __list_31.length; __i_31++) { var avatarBackground = __list_31[__i_31];
        if (avatarBackground.SetImage) avatarBackground.SetImage(ctUrl);
        avatarBackground.style.backgroundImage = 'url("' + ctUrl + '")';
        avatarBackground.style.backgroundSize = '92% 86%';
        avatarBackground.style.backgroundPosition = '50% 25%';
        avatarBackground.style.backgroundRepeat = 'no-repeat';
    }
    var __list_32 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarL__Default--T'); for (var __i_32 = 0; __i_32 < __list_32.length; __i_32++) { var avatarBackground = __list_32[__i_32];
        if (avatarBackground.SetImage) avatarBackground.SetImage(tUrl);
        avatarBackground.style.backgroundImage = 'url("' + tUrl + '")';
        avatarBackground.style.backgroundSize = '92% 86%';
        avatarBackground.style.backgroundPosition = '50% 25%';
        avatarBackground.style.backgroundRepeat = 'no-repeat';
    }
    var __list_33 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarL__PlayerColor'); for (var __i_33 = 0; __i_33 < __list_33.length; __i_33++) { var avatarClr = __list_33[__i_33];
        avatarClr.style.y = '-2px';
        avatarClr.style.width = '24px';
        avatarClr.style.height = '12px';
        avatarClr.style.marginLeft = '0px';
        avatarClr.style.horizontalAlign = 'center';
        avatarClr.style.verticalAlign = 'top';
        avatarClr.style.imgShadow = '0px 0px 1px 1.0 #000000CC';
    }
    var __list_34 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarL__Internal'); for (var __i_34 = 0; __i_34 < __list_34.length; __i_34++) { var avatarL = __list_34[__i_34];
        avatarL.style.height = '59px';
        avatarL.style.width = '85%';
        avatarL.style.marginTop = '0px';
        avatarL.style.horizontalAlign = 'center';
        avatarL.style.verticalAlign = 'top';
        avatarL.style.backgroundColor = '#7f7f7f';
    }
    var __list_35 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarL_HealthBarBG'); for (var __i_35 = 0; __i_35 < __list_35.length; __i_35++) { var avatarL = __list_35[__i_35];
        avatarL.style.verticalAlign = 'bottom';
        avatarL.style.marginBottom = '1.5px';
        avatarL.style.marginRight = '1.5px';
        avatarL.style.marginLeft = '1.5px';
        avatarL.style.height = '4.55px';
        avatarL.style.backgroundColor = '#00000040';
        avatarL.style.position = 'absolute';
    }
    var __list_36 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarL__ImageBG'); for (var __i_36 = 0; __i_36 < __list_36.length; __i_36++) { var avbg = __list_36[__i_36];
        avbg.style.width = '85%';
        avbg.style.height = '58px';
        avbg.style.marginTop = '0px';
    }
    var __list_37 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarL__PlayerImage'); for (var __i_37 = 0; __i_37 < __list_37.length; __i_37++) { var pImg = __list_37[__i_37];
        pImg.style.marginTop = '0px';
    }
    var __list_38 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarL'); for (var __i_38 = 0; __i_38 < __list_38.length; __i_38++) { var avatarL = __list_38[__i_38];
        avatarL.style.width = '62px';
        avatarL.style.height = '62px';
        avatarL.style.verticalAlign = isBottom ? 'bottom' : 'top';
        avatarL.style.overflow = 'noclip';
    }
    var __list_39 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarS'); for (var __i_39 = 0; __i_39 < __list_39.length; __i_39++) { var avatarS = __list_39[__i_39];
        avatarS.style.width = '42px';
        avatarS.style.height = '24px';
        avatarS.style.marginLeft = '1px';
        avatarS.style.marginRight = '5px';
        avatarS.style.marginBottom = '1px';
    }
    var __list_40 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarS__Internal'); for (var __i_40 = 0; __i_40 < __list_40.length; __i_40++) { var avatarS = __list_40[__i_40];
        avatarS.style.opacity = '1';
        avatarS.style.width = '100%';
        avatarS.style.height = '100%';
        avatarS.style.backgroundColor = '#7f7f7f';
        avatarS.style.verticalAlign = 'top';
        avatarS.style.horizontalAlign = 'center';
    }
    var __list_41 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarS__PlayerImage'); for (var __i_41 = 0; __i_41 < __list_41.length; __i_41++) { var avatarS = __list_41[__i_41];
        avatarS.style.backgroundColor = 'black';
        avatarS.style.width = '100%';
        avatarS.style.height = '100%';
        avatarS.style.verticalAlign = 'middle';
    }
    var __list_42 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarS__HealthBar'); for (var __i_42 = 0; __i_42 < __list_42.length; __i_42++) { var avatarS = __list_42[__i_42];
        avatarS.style.height = '3px';
        avatarS.style.verticalAlign = 'bottom';
    }
    var __list_43 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarS__Default--CT'); for (var __i_43 = 0; __i_43 < __list_43.length; __i_43++) { var avatarS = __list_43[__i_43];
        if (avatarS.SetImage) avatarS.SetImage(ctUrl);
        avatarS.style.backgroundImage = 'url("' + ctUrl + '")';
        avatarS.style.backgroundSize = '92% 86%';
        avatarS.style.backgroundPosition = '50% 25%';
        avatarS.style.backgroundRepeat = 'no-repeat';
        avatarS.style.height = '100%';
        avatarS.style.marginRight = '0px';
    }
    var __list_44 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarS__Default--T'); for (var __i_44 = 0; __i_44 < __list_44.length; __i_44++) { var avatarS = __list_44[__i_44];
        if (avatarS.SetImage) avatarS.SetImage(tUrl);
        avatarS.style.backgroundImage = 'url("' + tUrl + '")';
        avatarS.style.backgroundSize = '92% 86%';
        avatarS.style.backgroundPosition = '50% 25%';
        avatarS.style.backgroundRepeat = 'no-repeat';
        avatarS.style.height = '100%';
        avatarS.style.marginLeft = '0px';
    }
    var __list_45 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarImageT__Color'); for (var __i_45 = 0; __i_45 < __list_45.length; __i_45++) { var internalColor = __list_45[__i_45];
        internalColor.style.backgroundColor = '#87663e';
        internalColor.style.border = '2px solid #8a6a41';
    }
    var __list_46 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarImageT__InternalColor'); for (var __i_46 = 0; __i_46 < __list_46.length; __i_46++) { var internalColor = __list_46[__i_46];
        internalColor.style.backgroundColor = '#FFFFFF';
    }
    var __list_47 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarImageCT__Color'); for (var __i_47 = 0; __i_47 < __list_47.length; __i_47++) { var internalColor = __list_47[__i_47];
        internalColor.style.backgroundColor = '#72859d';
        internalColor.style.border = '2px solid #72859d';
    }
    var __list_48 = hudTeamCounter.FindChildrenWithClassTraverse('AvatarImageCT__InternalColor'); for (var __i_48 = 0; __i_48 < __list_48.length; __i_48++) { var internalColor = __list_48[__i_48];
        internalColor.style.backgroundColor = '#FFFFFF';
    }
    var __list_49 = hudTeamCounter.FindChildrenWithClassTraverse('Avatar__PlayerOutline--None'); for (var __i_49 = 0; __i_49 < __list_49.length; __i_49++) { var noOutline = __list_49[__i_49];
        noOutline.style.border = '0px solid #0000000';
    }
    var __list_50 = hudTeamCounter.FindChildrenWithClassTraverse('Avatar__PlayerOutline--White'); for (var __i_50 = 0; __i_50 < __list_50.length; __i_50++) { var avatarOutline = __list_50[__i_50];
        avatarOutline.style.border = '2px solid white';
    }
    var __list_51 = hudTeamCounter.FindChildrenWithClassTraverse('Avatar__PlayerOutline--T'); for (var __i_51 = 0; __i_51 < __list_51.length; __i_51++) { var avatarOutline = __list_51[__i_51];
        avatarOutline.style.backgroundColor = '#756337';
        avatarOutline.style.border = '1px solid #87663e';
    }
    var __list_52 = hudTeamCounter.FindChildrenWithClassTraverse('Avatar__PlayerOutline--CT'); for (var __i_52 = 0; __i_52 < __list_52.length; __i_52++) { var avatarOutline = __list_52[__i_52];
        avatarOutline.style.backgroundColor = '#7C858F';
        avatarOutline.style.border = '1px solid #4F5D6D';
    }
    var __list_53 = hudTeamCounter.FindChildrenWithClassTraverse('Avatar__HealthBar--Normal'); for (var __i_53 = 0; __i_53 < __list_53.length; __i_53++) { var av = __list_53[__i_53];
        av.style.backgroundColor = '#99ae91';
    }
}
runner();
$.Schedule(0.3, runner);]=]
local teamcount_score_js=[=[function score_runner() {
    var contextPanel = $.GetContextPanel();
    var hudTeamCounter = contextPanel.FindChildTraverse('HudTeamCounter');
    if (!hudTeamCounter) return;

    var isBottom = GameInterfaceAPI.GetSettingString('cl_hud_playercount_pos') === '1';
    hudTeamCounter.style.height = isBottom ? 'fit-children' : '100%';
    hudTeamCounter.style.verticalAlign = isBottom ? 'bottom' : 'top';

    var aliveTextT = hudTeamCounter.FindChildTraverse('AliveTextT');
    var aliveTextCT = hudTeamCounter.FindChildTraverse('AliveTextCT');

    if (aliveTextT && aliveTextCT) {
        aliveTextT.style.fontSize = '13px';
        aliveTextCT.style.fontSize = '13px';
        aliveTextT.style.fontWeight = 'light';
        aliveTextT.style.fontSize = '13px';
        aliveTextT.style.color = '#999999';
        aliveTextT.style.opacity = '0.57';
        aliveTextCT.style.fontWeight = 'light';
        aliveTextCT.style.fontSize = '13px';
        aliveTextCT.style.color = '#999999';
        aliveTextCT.style.opacity = '0.57';
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
    }

    var winsT = hudTeamCounter.FindChildTraverse('ScoreT');
    var winsCT = hudTeamCounter.FindChildTraverse('ScoreCT');
    if (winsT && winsCT) {
        winsT.style.marginTop = '-1px';
        winsCT.style.marginTop = '-1px';
        winsT.style.color = '#B99636';
        winsCT.style.color = '#6f9ec4';
        winsT.style.S2MixBlendMode = 'SRGBadditive';
        winsCT.style.S2MixBlendMode = 'SRGBadditive';
    }

    var timer = hudTeamCounter.FindChildTraverse('TimerText');
    if (timer) {
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
    }

    var bgCT = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/ct.png")';
    var bgT = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/t.png")';

    var __list_54 = hudTeamCounter.FindChildrenWithClassTraverse('TeamCounter__AliveT'); for (var __i_54 = 0; __i_54 < __list_54.length; __i_54++) { var tAlive = __list_54[__i_54];
        tAlive.style.backgroundImage = bgT;
        tAlive.style.backgroundSize = '100% 100%';
        tAlive.style.backgroundPosition = 'center';
        tAlive.style.backgroundRepeat = 'no-repeat';
        tAlive.style.width = '50px';
        tAlive.style.height = '53px';
        tAlive.style.marginLeft = '3px';
        tAlive.style.marginBottom = '2px';
    }
    var __list_55 = hudTeamCounter.FindChildrenWithClassTraverse('TeamCounter__AliveCT'); for (var __i_55 = 0; __i_55 < __list_55.length; __i_55++) { var ctAlive = __list_55[__i_55];
        ctAlive.style.backgroundImage = bgCT;
        ctAlive.style.backgroundSize = '100% 100%';
        ctAlive.style.backgroundPosition = 'center';
        ctAlive.style.backgroundRepeat = 'no-repeat';
        ctAlive.style.width = '50px';
        ctAlive.style.height = '53px';
        ctAlive.style.marginRight = '3px';
        ctAlive.style.marginBottom = '2px';
    }
    var aliveBackgroundT = hudTeamCounter.FindChildTraverse('AliveBackgroundT');
    var aliveBackgroundCT = hudTeamCounter.FindChildTraverse('AliveBackgroundCT');
    if (aliveBackgroundT) {
        aliveBackgroundT.style.backgroundImage = bgT;
        aliveBackgroundT.style.backgroundSize = '100% 100%';
        aliveBackgroundT.style.backgroundPosition = 'center';
        aliveBackgroundT.style.backgroundRepeat = 'no-repeat';
        aliveBackgroundT.style.width = '50px';
        aliveBackgroundT.style.height = '53px';
        aliveBackgroundT.style.marginLeft = '3px';
        aliveBackgroundT.style.marginBottom = '2px';
    }
    if (aliveBackgroundCT) {
        aliveBackgroundCT.style.backgroundImage = bgCT;
        aliveBackgroundCT.style.backgroundSize = '100% 100%';
        aliveBackgroundCT.style.backgroundPosition = 'center';
        aliveBackgroundCT.style.backgroundRepeat = 'no-repeat';
        aliveBackgroundCT.style.width = '50px';
        aliveBackgroundCT.style.height = '53px';
        aliveBackgroundCT.style.marginRight = '3px';
        aliveBackgroundCT.style.marginBottom = '2px';
    }

    var __list_56 = hudTeamCounter.FindChildrenWithClassTraverse('TeamCounter__AliveCount'); for (var __i_56 = 0; __i_56 < __list_56.length; __i_56++) { var scoreText = __list_56[__i_56];
        scoreText.style.color = '#ffffff';
    }

    var __list_57 = contextPanel.FindChildrenWithClassTraverse('AlertText'); for (var __i_57 = 0; __i_57 < __list_57.length; __i_57++) { var sentChat = __list_57[__i_57];
        sentChat.style.backgroundColor = 'gradient( linear, 100% 0%, 0% 0%, from( #00000000 ), color-stop( 0.7, #00000077 ), to( #00000077 ) )';
        sentChat.style.textShadow = '1px 1px 2px #00000055';
        sentChat.style.fontFamily = 'Stratum2';
        sentChat.style.fontWeight = 'normal';
        sentChat.style.fontSize = '21.5px';
        sentChat.style.letterSpacing = '.43px';
        sentChat.style.paddingLeft = '28px';
        sentChat.style.paddingBottom = '0px';
    }
}
score_runner();
$.Schedule(0.1, score_runner);]=]
local alerts_js=[=[var contextPanel = $.GetContextPanel();
var joinPanelCTBG = "https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/fade.png";
var joinPanelTBG = "https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/fade.png";
var joinPanelBotBG = "https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/fade.png";

var __list_58 = contextPanel.FindChildrenWithClassTraverse('hud-hint'); for (var __i_58 = 0; __i_58 < __list_58.length; __i_58++) { var hudHint = __list_58[__i_58];
    hudHint.style.backgroundImage = "url('https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/fade.png')";
    hudHint.style.backgroundColor = '#00000000';
    hudHint.style.width = '450px';
    hudHint.style.height = '109px';
    hudHint.style.backgroundSize = '100% 100%';
    hudHint.style.overflow = 'noclip';
    hudHint.style.backgroundRepeat = 'no-repeat';
    hudHint.style.transform = 'translateY(-100px)';

}

var __list_59 = contextPanel.FindChildrenWithClassTraverse('hud-hint_icon'); for (var __i_59 = 0; __i_59 < __list_59.length; __i_59++) { var hudHintIcon = __list_59[__i_59];
    hudHintIcon.style.visibility = 'visible';
    hudHintIcon.style.width = '64px';
    hudHintIcon.style.height = '64px';
    hudHintIcon.style.horizontalAlign = 'left';
    hudHintIcon.style.verticalAlign = 'center';
    hudHintIcon.style.marginLeft = '18px';
    if (hudHintIcon.SetImage) hudHintIcon.SetImage('https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/icons/ui/alert.png');
}
var __list_60 = contextPanel.FindChildrenWithClassTraverse('hud-hint__icon'); for (var __i_60 = 0; __i_60 < __list_60.length; __i_60++) { var hint = __list_60[__i_60];
    hint.style.visibility = 'collapse';
}


var __list_61 = contextPanel.FindChildrenWithClassTraverse('hud-hint__text'); for (var __i_61 = 0; __i_61 < __list_61.length; __i_61++) { var hudHintText = __list_61[__i_61];
    hudHintText.style.width = '75%';
    hudHintText.style.horizontalAlign = 'right';
    hudHintText.style.textAlign = 'left';
    hudHintText.style.height = '100%';
    hudHintText.style.verticalAlign = 'top';

}

var __list_62 = contextPanel.FindChildrenWithClassTraverse('hud-hint__priority-label'); for (var __i_62 = 0; __i_62 < __list_62.length; __i_62++) { var hudHintPriorityLabel = __list_62[__i_62];
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

var __list_63 = contextPanel.FindChildrenWithClassTraverse('hud-hint__label'); for (var __i_63 = 0; __i_63 < __list_63.length; __i_63++) { var hudHintLabel = __list_63[__i_63];
    hudHintLabel.style.horizontalAlign = 'left';
    hudHintLabel.style.height = '90px';
    hudHintLabel.style.verticalAlign = 'top';
    hudHintLabel.style.fontSize = '22px';
    hudHintLabel.style.opacity = '0.9'
}

var hudTeamCounter = contextPanel.FindChildTraverse('HudTeamCounter');
var __list_64 = hudTeamCounter.FindChildrenWithClassTraverse('hrTop'); for (var __i_64 = 0; __i_64 < __list_64.length; __i_64++) { var hrTop = __list_64[__i_64];
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

var __list_65 = hal.FindChildrenWithClassTraverse('hrBot'); for (var __i_65 = 0; __i_65 < __list_65.length; __i_65++) { var hrbot = __list_65[__i_65]; hrbot.style.visibility = 'collapse'; }
var __list_66 = hal.FindChildrenWithClassTraverse('hrTop'); for (var __i_66 = 0; __i_66 < __list_66.length; __i_66++) { var hrtop = __list_66[__i_66]; hrtop.style.visibility = 'collapse'; }

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
alertBg.style.backgroundImage = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/fade.png")';
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
            label_container.style.backgroundImage = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/location_corner.png")';
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
            wpn_bg.style.backgroundImage = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/weapon.png")';
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
            m_bg.style.backgroundImage = 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/ammo.png")';
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
win_team_bg.style.backgroundImage = did_twin ? 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/mvp2.png")' :
    did_ctwin ? 'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/mvp.png")' :
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

local abandonedpools_override_js=[=[
var root = $.GetContextPanel();
function AP_each(cls, fn) {
    var list = root.FindChildrenWithClassTraverse(cls);
    for (var i = 0; i < list.length; i++) fn(list[i]);
}
function AP_id(id) { return root.FindChildTraverse(id); }
function AP_style(p, values) {
    if (!p) return;
    for (var k in values) p.style[k] = values[k];
}

// abandonedpools/scaleform: hudteamcounter.css
var tc = AP_id('HudTeamCounter');
if (tc) {
    AP_each('AvatarL', function(p) { AP_style(p, {width:'62px', height:'62px', marginLeft:'-2.25px', marginRight:'-2.25px', overflow:'noclip'}); });
    AP_each('AvatarL__ImageBG', function(p) { AP_style(p, {width:'85%', height:'58px'}); });
    AP_each('AvatarL__Internal', function(p) { AP_style(p, {width:'100%', height:'112%', horizontalAlign:'middle', verticalAlign:'top'}); });
    AP_each('AvatarS', function(p) { AP_style(p, {width:'42px', height:'24px', marginLeft:'1px', marginRight:'5px', marginBottom:'1px', marginTop:'0px'}); });
    AP_each('AvatarS__Internal', function(p) { AP_style(p, {width:'100%', height:'100%', horizontalAlign:'center', verticalAlign:'middle', backgroundColor:'#7f7f7f'}); });
    AP_each('AvatarS__PlayerImage', function(p) { AP_style(p, {width:'100%', height:'100%', verticalAlign:'middle', backgroundColor:'black'}); });
    AP_each('AvatarS__HealthBar', function(p) { AP_style(p, {height:'3px', verticalAlign:'bottom'}); });
    AP_each('AvatarS__Default--CT', function(p) { AP_style(p, {backgroundImage:'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/teamcounter/teamcounter_alivebgCT.png)', backgroundSize:'100% auto', backgroundPosition:'center', backgroundRepeat:'no-repeat', borderTop:'1px solid #7da1bfDD', borderLeft:'1px solid #7da1bfDD', borderRight:'1px solid #7da1bfDD', borderBottom:'4px solid #7da1bfEE'}); });
    AP_each('AvatarS__Default--T', function(p) { AP_style(p, {backgroundImage:'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/teamcounter/teamcounter_alivebgT.png)', backgroundSize:'100% auto', backgroundPosition:'center', backgroundRepeat:'no-repeat', borderTop:'1px solid #a19570', borderRight:'1px solid #a19570DD', borderLeft:'1px solid #a19570DD', borderBottom:'4px solid #a19e77EE'}); });
    AP_each('AvatarL__Default--CT', function(p) { p.style.backgroundImage='url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/teamcounter/teamcounter_alivebgCT.png")'; });
    AP_each('AvatarL__Default--T', function(p) { p.style.backgroundImage='url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/teamcounter/teamcounter_alivebgT.png")'; });
    AP_style(AP_id('TeamSmallContainerCT'), {width:'400px', marginRight:'-2px', horizontalAlign:'right'});
    AP_style(AP_id('TeamSmallContainerT'), {width:'400px', marginLeft:'6px', horizontalAlign:'left'});
    AP_style(AP_id('AliveBackgroundCT'), {width:'50px', height:'53px', marginRight:'3px', marginBottom:'2px'});
    AP_style(AP_id('AliveBackgroundT'), {width:'50px', height:'53px', marginLeft:'3px', marginBottom:'2px'});
    AP_style(AP_id('AliveCountCT'), {fontSize:'40px', fontWeight:'bold', color:'#ffffff', marginTop:'2px', marginBottom:'-11px', horizontalAlign:'center', textAlign:'center'});
    AP_style(AP_id('AliveCountT'), {fontSize:'40px', fontWeight:'bold', color:'#ffffff', marginTop:'2px', marginBottom:'-11px', horizontalAlign:'center', textAlign:'center'});
    AP_style(AP_id('AliveTextCT'), {fontSize:'13px', fontWeight:'light', color:'#999999', opacity:'0.57', marginTop:'-1px', letterSpacing:'0px', horizontalAlign:'center'});
    AP_style(AP_id('AliveTextT'), {fontSize:'13px', fontWeight:'light', color:'#999999', opacity:'0.57', marginTop:'-1px', letterSpacing:'0px', horizontalAlign:'center'});
    AP_style(AP_id('ScoreCT'), {marginTop:'-1px', color:'#6f9ec4'});
    AP_style(AP_id('ScoreT'), {marginTop:'-1px', color:'#B99636'});
    AP_style(AP_id('TimerText'), {marginTop:'-3px', marginBottom:'4px', fontSize:'28px', fontWeight:'bold', fontFamily:'Stratum2', letterSpacing:'0px'});
}

// abandonedpools/scaleform: hudradar.css
var radar = AP_id('Radar');
AP_style(radar, {x:'0px', y:'40px', width:'300px', height:'300px'});
AP_style(AP_id('Radar__Round'), {width:'260px', height:'260px', horizontalAlign:'center', verticalAlign:'center'});
AP_style(AP_id('Radar__Round--Inner'), {width:'250px', height:'250px', horizontalAlign:'center', verticalAlign:'center'});
AP_style(AP_id('Radar__Square'), {width:'280px', height:'280px', horizontalAlign:'left', verticalAlign:'top', marginLeft:'1px'});
AP_style(AP_id('Radar__Square--Inner'), {width:'270px', height:'270px', horizontalAlign:'center', verticalAlign:'center'});
AP_style(AP_id('DashboardLabel'), {marginTop:'7px', marginLeft:'18px', fontSize:'26px', fontFamily:'Stratum2', fontWeight:'bold'});

// abandonedpools/scaleform: hudhealtharmor.css
AP_each('hud-HA', function(p) { AP_style(p, {width:'465px', height:'55px', verticalAlign:'bottom', marginLeft:'0px'}); });
AP_each('hud-HA-text', function(p) { AP_style(p, {width:'70px'}); });
AP_each('hud-HA-icon-container', function(p) { AP_style(p, {x:'10px', y:'3px', width:'30px', height:'100%', marginTop:'-1px'}); });
AP_each('hud-HA-health', function(p) { AP_style(p, {height:'100%', paddingRight:'3px', marginLeft:'3px'}); });
AP_each('hud-HA-armor', function(p) { AP_style(p, {height:'100%', paddingRight:'10px'}); });
AP_each('hud-HA-bar', function(p) { AP_style(p, {x:'104px', y:'32px', backgroundColor:'#03030399'}); });
AP_each('hud-HA-text', function(p) { AP_style(p, {fontFamily:'Stratum2', fontSize:'42px', fontWeight:'bold', letterSpacing:'-1px', horizontalAlign:'center', marginLeft:'5px'}); });
AP_each('hud-HA-bg-health', function(p) { AP_style(p, {width:'200px', height:'100%', backgroundSize:'107% 100%'}); });
AP_each('hud-HA-bg-armor', function(p) { AP_style(p, {width:'100%', height:'100%', backgroundSize:'100% 100%'}); });

// abandonedpools/scaleform: hudweaponpanel.css and hudweaponselection.css
var weaponBottom = AP_id('WeaponPanelBottom');
AP_style(weaponBottom, {height:'55px'});
AP_each('WeaponPanel', function(p) { AP_style(p, {fontFamily:'Stratum2', opacity:'1', transitionDuration:'0.25s'}); });
AP_style(AP_id('AmmoBackground'), {height:'59px', width:'340px', horizontalAlign:'right', verticalAlign:'bottom', backgroundImage:'url("https://raw.githubusercontent.com/abandonedpools/scaleform/master/p_scaleform/materials/panorama/images/hud/ammo.png)', backgroundSize:'100% 100%'});
AP_style(AP_id('WeaponPanelBottomContent'), {height:'100%', flowChildren:'right', horizontalAlign:'right'});
AP_each('AmmoAnim__BulletIcon--Pos1', function(p) { p.style.marginLeft='4px'; });
AP_each('AmmoAnim__BulletIcon--Pos2', function(p) { p.style.marginLeft='4px'; });
AP_each('AmmoAnim__BulletIcon--Pos3', function(p) { p.style.marginLeft='4px'; });
AP_each('AmmoAnim__BulletIcon--Pos4', function(p) { p.style.marginLeft='4px'; });
AP_each('AmmoAnim__BulletIcon--Pos5', function(p) { p.style.marginLeft='4px'; });

// abandonedpools/scaleform: hudmoney.css
AP_each('money', function(p) { AP_style(p, {height:'140px', marginTop:'-52px', marginBottom:'-12px'}); });
AP_each('money-text-bg', function(p) { AP_style(p, {width:'250px', height:'38px', verticalAlign:'middle', marginLeft:'0px'}); });
AP_each('money-text', function(p) { AP_style(p, {flowChildren:'right', verticalAlign:'middle', textAlign:'center', marginLeft:'9px'}); });
AP_each('money-text-label', function(p) { AP_style(p, {fontFamily:'Stratum2 Bold', fontSize:'31px', fontWeight:'bold', marginTop:'2px', marginLeft:'26px', letterSpacing:'-0.4px'}); });
AP_each('money-text-buy-icon', function(p) { AP_style(p, {width:'28px', height:'28px', marginTop:'5px', marginLeft:'3px'}); });

// abandonedpools/scaleform: huddeathnotice.css
var dn = AP_id('HudDeathNotice');
AP_style(dn, {marginTop:'72px', paddingRight:'3px', horizontalAlign:'right'});
AP_each('DeathNotice', function(p) { AP_style(p, {height:'36px', horizontalAlign:'right', marginBottom:'1px'}); });
AP_each('DeathNoticeContent', function(p) { AP_style(p, {flowChildren:'right', padding:'6px 10px 3px 10px'}); });
AP_each('DeathNoticeContentLabel', function(p) { AP_style(p, {fontFamily:'Stratum2', fontSize:'20px', fontWeight:'bold', marginLeft:'2px', marginRight:'2px'}); });
AP_each('DeathNoticeCTColor', function(p) { p.style.color='#93abd2'; });
AP_each('DeathNoticeTColor', function(p) { p.style.color='#d7c788'; });
AP_each('DeathNoticeFadedColor', function(p) { p.style.color='#888888'; });
AP_style(AP_id('Weapon'), {visibility:'visible', margin:'-2px 4px 0px 4px', maxWidth:'57px'});

// abandonedpools/scaleform: hudwinpanel.css
var winRoot = AP_id('HudWinPanel');
AP_each('WinPanelRoot', function(p) { AP_style(p, {width:'818px', height:'500px', horizontalAlign:'center', y:'112px'}); });
AP_each('WinPanelRow--Main', function(p) { p.style.height='126px'; });
AP_each('WinPanelRow__Title', function(p) { AP_style(p, {width:'99.75%', marginLeft:'2px', marginRight:'2px', fontSize:'19px'}); });
AP_each('WinPanelMVP', function(p) { AP_style(p, {fontFamily:'Stratum2'}); });

// abandonedpools/scaleform: hudalerts.css
var alerts = root.FindChildTraverse('HudAlerts');
AP_style(alerts, {width:'700px', height:'41px', horizontalAlign:'center'});
AP_style(AP_id('AlertBg'), {width:'100%', height:'100%'});
AP_style(AP_id('AlertText'), {width:'100%', textAlign:'center', verticalAlign:'center', marginTop:'1px', fontFamily:'Stratum2 Bold', fontSize:'32px', fontWeight:'bold', letterSpacing:'0px', textTransform:'uppercase'});
]=]

local abandonedpools_css_js=[=[
var APcssRoot = $.GetContextPanel();
function APcssEach(c, f) { var a=APcssRoot.FindChildrenWithClassTraverse(c); for (var i=0;i<a.length;i++) f(a[i]); }
function APcssId(i) { return APcssRoot.FindChildTraverse(i); }
APcssEach("AlertHidden", function(p) { var s={"opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AlertVisible", function(p) { var s={"opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Ammo", function(p) { var s={"width":"125px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Ammo--Hidden", function(p) { var s={"opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim", function(p) { var s={"width":"95px","height":"100%","opacity":"0","marginRight":"-60px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim_GrenadeIcon", function(p) { var s={"width":"20px","marginLeft":"5px","transform":"rotateZ( 20deg )","washColor":"#ffffff"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim_GrenadeIcon--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__BulletIcon", function(p) { var s={"width":"20px","y":"19px","imgShadow":"0px 0px 1px #00000022"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__BulletIcon--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__BulletIcon--Pos1", function(p) { var s={"x":"35px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__BulletIcon--Pos2", function(p) { var s={"x":"27px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__BulletIcon--Pos3", function(p) { var s={"x":"19px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__BulletIcon--Pos4", function(p) { var s={"x":"11px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__BulletIcon--Pos5", function(p) { var s={"x":"3px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__BulletIcon--Red", function(p) { var s={"washColor":"red"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__Bullets", function(p) { var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__Bullets--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__Grenades", function(p) { var s={"flowChildren":"left","horizontalAlign":"center","verticalAlign":"center","padding":"5px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__Grenades--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__ShellIcon", function(p) { var s={"width":"16px","x":"45px","y":"20px","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__ShellIcon--Anim", function(p) { var s={"visibility":"visible","opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__ShellIcon--Red", function(p) { var s={"washColor":"red"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AmmoAnim__Shells", function(p) { var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Ammo__Burst", function(p) { var s={"flowChildren":"right","x":"74px","y":"8px","visibility":"collapse","marginLeft":"4px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Ammo__Burst--Burst", function(p) { var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Ammo__Burst--Single", function(p) { var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Ammo__Clip", function(p) { var s={"fontWeight":"bold","color":"#ffffff","letterSpacing":"0px","textAlign":"right","x":"-12px","y":"1px","width":"72px","fontSize":"44px","S2MixBlendMode":"SRGBadditive"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Ammo__Total", function(p) { var s={"fontWeight":"bold","color":"#ffffff","letterSpacing":"0px","textAlign":"right","x":"55px","y":"5px","width":"60px","fontSize":"24px","S2MixBlendMode":"SRGBadditive"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar", function(p) { var s={"flowChildren":"down"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarImage", function(p) { var s={"verticalAlign":"center","width":"100%","height":"100%","padding":"2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarImageCT__Color", function(p) { var s={"backgroundColor":"#72859dDD","border":"2px solid #FFFFFF"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarImageCT__InternalColor", function(p) { var s={"backgroundColor":"#FFFFFF"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarImageT__Color", function(p) { var s={"backgroundColor":"#987344E0","border":"2px solid #8a6a41"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarImageT__InternalColor", function(p) { var s={"backgroundColor":"#FFFFFF"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL", function(p) { var s={"width":"62px","height":"62px","marginLeft":"-2.25px","marginRight":"-2.25px","overflow":"noclip"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL_HealthBarBG", function(p) { var s={"verticalAlign":"bottom","marginBottom":"1.5px","marginRight":"1.5px","marginLeft":"1.5px","height":"4.55px","width":"100%","backgroundColor":"#00000040","opacity":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__Bot", function(p) { var s={"width":"40px","height":"40px","x":"-5px","y":"6px","horizontalAlign":"center","S2MixBlendMode":"additive","opacity":"0.8"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__Default--CT", function(p) { var s={"backgroundImage":"none"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__Default--T", function(p) { var s={"backgroundImage":"none"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__Dominated", function(p) { var s={"width":"54px","height":"54px","y":"5px","x":"3px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__GGIcon", function(p) { var s={"height":"20px","horizontalAlign":"center","imgShadow":"0px 0px 1px 1.0 #00000099","overflow":"clip"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__GGIconBG", function(p) { var s={"width":"60px","marginTop":"4px","padding":"2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__GGText", function(p) { var s={"fontWeight":"bold","fontSize":"22px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__GGText--Bot", function(p) { var s={"color":"#ffffff33"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__GGText--Player", function(p) { var s={"color":"#FFFFFF"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__GGTextBG", function(p) { var s={"width":"60px","height":"24px","horizontalAlign":"center","backgroundColor":"#0000006f","borderRadius":"0px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__HealthBar", function(p) { var s={"verticalAlign":"bottom","height":"4px","margin":"0px 1px 1px 1px","opacity":"0.9"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__HealthBarBG", function(p) { var s={"margin":"0px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__ImageBG", function(p) { var s={"height":"58px","width":"85%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__Internal", function(p) { var s={"verticalAlign":"top","backgroundColor":"#00000000","width":"100%","height":"112%","horizontalAlign":"middle"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__Nemesis", function(p) { var s={"width":"42px","height":"42px","x":"10px","y":"8px","opacity":"0.7"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__PlayerColor", function(p) { var s={"y":"-2px","width":"24px","height":"15px","paddingBottom":"4px","marginRight":"9.5px","opacity":"0.9","horizontalAlign":"center","imgShadow":"0px 2px 1px 1.2 #000000BB","zIndex":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__PlayerLetter", function(p) { var s={"y":"-26px","horizontalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__Skull", function(p) { var s={"backgroundSize":"92% 92%","width":"42px","height":"42px","x":"4.5px","y":"9px","textShadow":"0px 1px #00000026","margin":"0px 0px 0px 0px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__Sound", function(p) { var s={"x":"20px","y":"36px","flowChildren":"right","opacity":".8"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__Sound--1", function(p) { var s={"marginTop":"6px","marginRight":"2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__Sound--2", function(p) { var s={"marginTop":"3px","marginRight":"2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__SoundShadow--1", function(p) { var s={"marginTop":"6px","marginRight":"2px","transform":"translate3d( 2px, 2px, 0px )","washColor":"black"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__SoundShadow--2", function(p) { var s={"marginTop":"3px","marginRight":"2px","transform":"translate3d( 2px, 2px, 0px )","washColor":"black"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarL__SoundShadow--Off", function(p) { var s={"transform":"translate3d( 2px, 2px, 0px )","washColor":"black"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarLargeSnippet--ScaleSmaller", function(p) { var s={"uiScale":"88% 88% 100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS", function(p) { var s={"width":"42px","height":"24px","marginLeft":"1px","marginRight":"5px","marginBottom":"1px","marginTop":"0px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Bot", function(p) { var s={"width":"21px","height":"21px","x":"0px","y":"0px","horizontalAlign":"center","S2MixBlendMode":"additive","opacity":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Default--CT", function(p) { var s={"backgroundImage":"none"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Default--T", function(p) { var s={"backgroundImage":"none"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Dominated", function(p) { var s={"width":"30px","height":"30px","x":"1px","y":"-2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__HealthBar", function(p) { var s={"verticalAlign":"bottom","height":"3px","backgroundColor":"#c7b98d"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Internal", function(p) { var s={"width":"100%","height":"100%","horizontalAlign":"center","verticalAlign":"middle","backgroundColor":"#7f7f7f"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Nemesis", function(p) { var s={"width":"16px","height":"28px","x":"13px","y":"-1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Overlay--Empty", function(p) { var s={"opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__PlayerImage", function(p) { var s={"verticalAlign":"middle","width":"100%","height":"100%","backgroundColor":"black"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Skull", function(p) { var s={"width":"23px","height":"95%","horizontalAlign":"center","verticalAlign":"top"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Sound", function(p) { var s={"x":"2px","y":"6px","flowChildren":"right","verticalAlign":"middle","imgShadow":"1px 1px 1px 1.0 #0000003b","opacity":".5"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Sound--1", function(p) { var s={"x":"15px","y":"0px","verticalAlign":"middle","imgShadow":"1px 1px 1px 1.0 #0000003b"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__Sound--2", function(p) { var s={"x":"20px","y":"0px","verticalAlign":"middle","imgShadow":"1px 1px 1px 1.0 #0000003b"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__SoundShadow--1", function(p) { var s={"marginTop":"6px","marginRight":"2px","transform":"translate3d( 2px, 2px, 0px )","washColor":"black"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__SoundShadow--2", function(p) { var s={"marginTop":"3px","marginRight":"2px","transform":"translate3d( 2px, 2px, 0px )","washColor":"black"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("AvatarS__SoundShadow--Off", function(p) { var s={"transform":"translate3d( 2px, 2px, 0px )","washColor":"black"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__Bot--CT", function(p) { var s={"washColor":"#d0f0ffDD"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__Bot--T", function(p) { var s={"washColor":"#fff1cfDD"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__CommonMargin", function(p) { var s={"margin":"0px -2px 0px -2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__HealthBar--Normal", function(p) { var s={"backgroundColor":"#8fa387","S2MixBlendMode":"normal"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__HealthBar--Red", function(p) { var s={"backgroundColor":"#EA5151","S2MixBlendMode":"normal"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__HealthMargin", function(p) { var s={"marginBottom":"0px","margin":"0px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__PlayerBorder--CT", function(p) { var s={"border":"1px solid #454b51"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__PlayerBorder--T", function(p) { var s={"border":"1px solid #483a2a"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__PlayerOutline--CT", function(p) { var s={"backgroundColor":"#7C858F","border":"2px solid #4F5D6D","opacity":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__PlayerOutline--None", function(p) { var s={"border":"0px solid #00000000"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__PlayerOutline--Spectate", function(p) { var s={"border":"3px solid #D8D8D8D8"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__PlayerOutline--T", function(p) { var s={"backgroundColor":"#756337","border":"2px solid #87663e","opacity":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__PlayerOutline--White", function(p) { var s={"border":"3px solid white"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__Skull--CT", function(p) { var s={"washColor":"#2F2F2F","opacity":"0.6"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__Skull--Red", function(p) { var s={"washColor":"#252525","opacity":"0.32"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__Skull--T", function(p) { var s={"washColor":"#2F2F2F","opacity":"0.6"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__Skull--White", function(p) { var s={"washColor":"#252525","opacity":"0.25"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__Sound--1Animate", function(p) { var s={"opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__Sound--2Animate", function(p) { var s={"opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Avatar__SoundWithShadow", function(p) { var s={"width":"fit-children","height":"fit-children","flowChildren":"none"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("BombPlantedPulse__Fast", function(p) { var s={"opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("BombPlantedPulse__Medium", function(p) { var s={"opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("BombPlantedPulse__Slow", function(p) { var s={"opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("BombZone", function(p) { var s={"height":"7%","transformOrigin":"50% 50%","x":"-7px","y":"-10px","opacity":".7","washColor":"#ffcc00","imgShadow":"0px 0px 1px 2 #111111FF"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("BombZone_OnMap", function(p) { var s={"height":"7%","opacity":".4"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNotice", function(p) { var s={"horizontalAlign":"right","marginBottom":"1px","height":"36px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeBG", function(p) { var s={"width":"100%","height":"100%","backgroundColor":"black","opacity":"0.8","visibility":"visible","boxShadow":"inset #e10000e6 0px 0px 1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeBGBorder", function(p) { var s={"opacity":"0","borderRadius":"5px","width":"100%","height":"100%","border":"1.5px solid #b3070d"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeBGGradient", function(p) { var s={"width":"100%","height":"95%","opacity":"0.76","verticalAlign":"center","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeCTColor", function(p) { var s={"color":"#93abd2"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeContent", function(p) { var s={"opacity":"0","flowChildren":"right","padding":"6px 10px 3px 10px","S2MixBlendMode":"additive"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeFadedColor", function(p) { var s={"color":"#888888"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeIcon", function(p) { var s={"height":"26px","verticalAlign":"top","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeIcon2", function(p) { var s={"height":"26px","verticalAlign":"top","visibility":"collapse","margin":"-2px 5px 0px 5px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeTColor", function(p) { var s={"color":"#d7c788"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeWipeContainer", function(p) { var s={"opacity":"0","visibility":"visible","width":"100%","flowChildren":"left","marginTop":"30px","padding":"0px 10px 0px 10px","S2MixBlendMode":"additive","backgroundColor":"gradient( linear, 100% 100%, 0% 0%, from( #e10000e6 ), color-stop( 0.2, #e10000e6 ), color-stop( 0.4, #e1000066 ), color-stop( 0.8, #e1000011 ), to( #e1000000 ) )","borderRadius":"3px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("DeathNoticeWipeIcon", function(p) { var s={"height":"16px","verticalAlign":"middle","margin":"-2px 1px 0px 1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("FlashAnim", function(p) { var s={"opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GameScore__BGL", function(p) { var s={"width":"39px","marginRight":"1px","backgroundColor":"#000000D4","height":"24px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GameScore__BGR", function(p) { var s={"width":"39px","backgroundColor":"#000000D4","height":"24px","marginLeft":"1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameBG", function(p) { var s={"width":"100%","height":"100%","opacity":"0.98"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameBG__Border", function(p) { var s={"width":"100%","height":"100%","padding":"3px","backgroundColor":"gradient( linear, 0% 0%, 0% 100%, from( #5A7182 ), to( #1F2A31 ) )"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameBG__MainBG", function(p) { var s={"width":"100%","height":"100%","backgroundColor":"gradient( linear, 100% 0%, 0% 0%, from( #00000000 ), color-stop( 0.20, #000000cc ) , color-stop(0.50, #000000ff), color-stop( 0.80, #000000cc ), to( #00000000 ) )"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameBG__TitleBG", function(p) { var s={"width":"100%","height":"39px","y":"4px","backgroundColor":"gradient( linear, 100% 0%, 0% 0%, from( #00000000 ), color-stop( 0.20, #000000cc ) , color-stop(0.50, #000000ff), color-stop( 0.80, #000000cc ), to( #00000000 ) )"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameExtra", function(p) { var s={"backgroundColor":"gradient( linear, 100% 0%, 0% 0%, from( #00000000 ), color-stop( 0.30, #00000080 ) , color-stop(0.50, #000000a6), color-stop( 0.70, #00000080 ), to( #00000000 ) )","padding":"5px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameExtra__Center", function(p) { var s={"flowChildren":"right","horizontalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameExtra__Icon", function(p) { var s={"washColor":"#ffffff","padding":"5px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameExtra__Text", function(p) { var s={"fontSize":"18px","fontWeight":"normal"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameExtra__Text--Bold", function(p) { var s={"fontWeight":"bold"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameFG", function(p) { var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("GunGameFG__Title", function(p) { var s={"width":"100%","verticalAlign":"top","fontWeight":"bold","fontSize":"30px","color":"#a7a7a7","letterSpacing":"0.5px","textAlign":"center","y":"6px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("HZone", function(p) { var s={"height":"7%","transformOrigin":"50% 50%","x":"-8px","y":"-12px","S2MixBlendMode":"screen"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("HeadShot", function(p) { var s={"margin":"-2px 4px 0px 7px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("HideFlash", function(p) { var s={"opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("HudBlur", function(p) { var s={"width":"100%","height":"100%","S2MixBlendMode":"opaque"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Invisible", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("JoinPanel--Animate-FadeIn", function(p) { var s={"opacity":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("JoinPanel--Animate-FadeOut", function(p) { var s={"opacity":"PermenentTeamPopup"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("JoinPanelInner", function(p) { var s={"x":"2px","y":"2px","width":"622px","height":"66px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("JoinPanelRoot", function(p) { var s={"flowChildren":"none","horizontalAlign":"center","verticalAlign":"top","overflow":"noclip","marginTop":"1px","transform":"translatey(-6px)"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("JoinTextCT", function(p) { var s={"S2MixBlendMode":"additive","opacity":"0.85","color":"#d7e9f7"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("JoinTextT", function(p) { var s={"S2MixBlendMode":"additive","opacity":"0.85","color":"#f2e7c7"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Kills", function(p) { var s={"height":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Kills__Count", function(p) { var s={"flowChildren":"right","horizontalAlign":"right","paddingTop":"4px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Kills__Count--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Kills__Count--RightLeftFlow", function(p) { var s={"flowChildren":"left"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Kills__Icon--Hidden", function(p) { var s={"opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Kills__KillEater", function(p) { var s={"flowChildren":"right","verticalAlign":"bottom","horizontalAlign":"right"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Kills__KillEater--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Kills__KillEaterText", function(p) { var s={"fontWeight":"medium","fontSize":"13px","color":"#ffffff","marginBottom":"4px","S2MixBlendMode":"SRGBadditive","opacity":"0.8"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Kills__Text", function(p) { var s={"fontWeight":"bold","fontSize":"24px","color":"white","letterSpacing":"0px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP", function(p) { var s={"flowChildren":"right","width":"fit-children","horizontalAlign":"center","verticalAlign":"middle"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__Avatar", function(p) { var s={"width":"60px","height":"60px","verticalAlign":"bottom","marginBottom":"3px","marginRight":"8px","backgroundColor":"gradient( linear, 0% 0%, 0% 100%, from( #7d7d7d ), to( #464646) )","boxShadow":"#000000A5 0px 0px 3px 2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__Avatar--ExtraMargin", function(p) { var s={"marginLeft":"10px","marginRight":"10px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__AvatarText", function(p) { var s={"verticalAlign":"center","fontSize":"20px","fontWeight":"bold","color":"#999999"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__GunGameAvatars", function(p) { var s={"flowChildren":"right","verticalAlign":"center","marginLeft":"10px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__GunGameAvatars--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__GunGameAvatars--ScrollAnim", function(p) { var s={"opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__Layout--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__Layout--Right", function(p) { var s={"width":"fit-children"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__MusicKit", function(p) { var s={"flowChildren":"right","width":"fit-children","verticalAlign":"bottom","marginLeft":"-1px","paddingTop":"4px","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__MusicKit--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__MusicKitAnim", function(p) { var s={"visibility":"collapse","flowChildren":"right","width":"fit-children","verticalAlign":"middle","marginLeft":"20px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__MusicKitIcon", function(p) { var s={"width":"fit-children","height":"34px","verticalAlign":"bottom","marginBottom":"0px","marginTop":"1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__MusicKitInfoText", function(p) { var s={"visibility":"collapse","width":"fit-children","fontSize":"15px","color":"#ffffff","verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__MusicKitName", function(p) { var s={"maxWidth":"400px","fontWeight":"normal"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__MusicKitText", function(p) { var s={"fontSize":"15px","fontWeight":"light","color":"#bcbcbc9A","verticalAlign":"bottom","paddingLeft":"4px","marginBottom":"2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__MusicKitText--AnimFadeIn", function(p) { var s={"opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__MusicKitText--AnimFadeOut", function(p) { var s={"opacity":"0.0","width":"fit-children"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__MusicKitText--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__Winner", function(p) { var s={"width":"fit-children","flowChildren":"right","marginLeft":"2px","marginTop":"2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__WinnerName", function(p) { var s={"verticalAlign":"middle","marginTop":"0px","paddingLeft":"2px","fontSize":"34px","fontWeight":"medium","color":"#ffffff","letterSpacing":"0px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__WinnerStar", function(p) { var s={"height":"16px","verticalAlign":"middle","margin":"0px 2px 3px 0px","washColor":"ffd856ff","backgroundColor":"ffd856ff","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP__WinnerStarOLD", function(p) { var s={"height":"0px","width":"0px","opacity":"0","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MVP_content", function(p) { var s={"verticalAlign":"bottom","horizontalAlign":"left","marginLeft":"21px","visibility":"visible","marginBottom":"6px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Map", function(p) { var s={"width":"100%","height":"100%","transformOrigin":"50% 50%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Map__Level--Animate-FadeIn", function(p) { var s={"opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Map__Level--Animate-FadeOut", function(p) { var s={"opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MatchStartAlert", function(p) { var s={"color":"#e10000"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MedalStats", function(p) { var s={"width":"100%","backgroundColor":"gradient( linear, 100% 0%, 0% 0%, from( #00000000 ), color-stop( 0.20, #00000099 ) , color-stop(0.50, #000000e6), color-stop( 0.80, #00000099 ), to( #00000000 ) )","padding":"5px","flowChildren":"right"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MedalStats__Icon", function(p) { var s={"height":"30px","marginRight":"20px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("MedalStats__Text", function(p) { var s={"fontSize":"20px","fontWeight":"normal","color":"white"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Medals", function(p) { var s={"horizontalAlign":"center","flowChildren":"right"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Medals__Icon", function(p) { var s={"height":"56px","marginRight":"10px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Medals__Icon--Anim", function(p) { var s={"opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Medals__Icon--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("NameMusicKit", function(p) { var s={"flowChildren":"down","height":"fit-children","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_Above", function(p) { var s={"width":"13px","height":"7px","y":"8px","x":"-1px","horizontalAlign":"center","verticalAlign":"center","washColor":"#BBBBBB","opacity":"0.7"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_Below", function(p) { var s={"width":"13px","height":"7px","y":"-8px","x":"-1px","horizontalAlign":"center","verticalAlign":"center","washColor":"#BBBBBB","opacity":"0.7"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_Color_CT", function(p) { var s={"washColor":"#1ed2ffFF"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_Color_Enemy", function(p) { var s={"washColor":"#ff1919FF"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_Color_T", function(p) { var s={"washColor":"#ffdd23FF"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_Death", function(p) { var s={"width":"17px","height":"17px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_EnemyOnMap", function(p) { var s={"width":"13px","height":"13px","horizontalAlign":"center","verticalAlign":"center","opacity":"0.95"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_Ghost", function(p) { var s={"width":"9px","height":"15px","horizontalAlign":"center","verticalAlign":"center","opacity":"0.8"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_HostageOnMap", function(p) { var s={"width":"13px","height":"13px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_Indicator", function(p) { var s={"width":"12px","height":"12px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_OffMap", function(p) { var s={"width":"16px","height":"16px","horizontalAlign":"center","verticalAlign":"center","y":"1px","opacity":"0.8"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_OnMap", function(p) { var s={"width":"10px","height":"10px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PI_Text", function(p) { var s={"fontFamily":"Stratum2, 'Arial Unicode MS'","fontWeight":"medium","fontSize":"12px","textAlign":"center","letterSpacing":"0px","x":"21px","y":"-4px","color":"#000000FF","S2MixBlendMode":"normal"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Penetrate", function(p) { var s={"margin":"-2px 4px 0px 4px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("PlayerIcons", function(p) { var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("ProgressBarLeft", function(p) { var s={"backgroundColor":"red"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("RadarBombPlantPulse", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Radar__Round--BorderClass", function(p) { var s={"width":"260px","height":"260px","horizontalAlign":"center","verticalAlign":"center","borderRadius":"50% / 50%","borderWidth":"2px","borderStyle":"solid","borderColor":"rgba(255, 255, 255, 0.35)","S2MixBlendMode":"SRGBadditive","opacity":"0.45","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Radar__Square--BorderClass", function(p) { var s={"width":"280px","height":"280px","horizontalAlign":"center","verticalAlign":"center","borderWidth":"2px","borderStyle":"solid","borderColor":"rgba(255, 255, 255, 0.4)","borderRadius":"0px","S2MixBlendMode":"SRGBadditive","opacity":"0.7","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("RankUp", function(p) { var s={"backgroundColor":"gradient( linear, 100% 0%, 0% 0%, from( #00000000 ), color-stop( 0.20, #00000099 ) , color-stop(0.50, #000000e6), color-stop( 0.80, #00000099 ), to( #00000000 ) )","padding":"15px 5px 15px 40px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("RankUp__Text", function(p) { var s={"fontSize":"22px","fontWeight":"normal","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("RankUp__Text--Bold", function(p) { var s={"fontWeight":"bold"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("RankUp__Text--Coin", function(p) { var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("RankUp__Text--MultiRank", function(p) { var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("RankUp__Text--Show", function(p) { var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("RankUp__Text--SingleRank", function(p) { var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("ReplayAlert", function(p) { var s={"color":"#c9c9c9"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("ShowRoundEndReport", function(p) { var s={"y":"120px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG", function(p) { var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__Border", function(p) { var s={"width":"100%","height":"100%","padding":"3px","backgroundColor":"gradient( linear, 0% 0%, 0% 100%, from( #5A7182 ), to( #1F2A31 ) )"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__CTDefaultLogo", function(p) { var s={"horizontalAlign":"left","marginLeft":"0px","marginTop":"2px","height":"75%","opacity":"0.95","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__DefaultLogo", function(p) { var s={"width":"64px","height":"64px","horizontalAlign":"center","verticalAlign":"top","marginTop":"-82px","opacity":"1","backgroundSize":"contain","backgroundRepeat":"no-repeat","visibility":"collapse","zIndex":"10"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__MainBG", function(p) { var s={"width":"100%","height":"100%","zIndex":"4","backgroundColor":"gradient( linear, 100% 0%, 0% 0%, from( #56492200 ), color-stop( 0.20, #56492299 ) , color-stop(0.50, #564922e6), color-stop( 0.80, #56492299 ), to( #56492200 ) )"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__TDefaultLogo", function(p) { var s={"horizontalAlign":"right","marginRight":"0px","marginTop":"2px","height":"75%","opacity":"0.95","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__TeamLogo", function(p) { var s={"width":"64px","height":"64px","horizontalAlign":"center","verticalAlign":"top","marginTop":"-84px","opacity":"1","backgroundSize":"contain","backgroundRepeat":"no-repeat","zIndex":"10","visibility":"visible","imgShadow":"0px 0px 1px 1.5 #000000AA"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__TitleBG", function(p) { var s={"width":"100%","height":"39px","y":"4px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__WHITE", function(p) { var s={"opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__hrBot", function(p) { var s={"width":"100%","height":"1px","verticalAlign":"bottom","zIndex":"5","backgroundColor":"#242b2e","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__hrMid", function(p) { var s={"width":"100%","height":"1px","y":"80px","zIndex":"5"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamBG__hrTop", function(p) { var s={"width":"100%","height":"1px","verticalAlign":"top","zIndex":"5"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamCounter__Align--Bottom", function(p) { var s={"verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamCounter__Align--Top", function(p) { var s={"verticalAlign":"top"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamCounter__AliveCount", function(p) { var s={"horizontalAlign":"center","textAlign":"center","marginTop":"2px","marginBottom":"-11px","fontWeight":"bold","fontSize":"40px","color":"white"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamCounter__AliveSkull", function(p) { var s={"horizontalAlign":"center","verticalAlign":"center","marginTop":"8px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamCounter__AliveText", function(p) { var s={"horizontalAlign":"center","fontWeight":"light","textAlign":"middle","fontSize":"13px","letterSpacing":"0px","color":"#999999","opacity":"0.57","marginTop":"-1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamCounter__Flow--Down", function(p) { var s={"flowChildren":"down"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamCounter__Flow--Up", function(p) { var s={"flowChildren":"up"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamFG", function(p) { var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamFG__Surrender", function(p) { var s={"y":"34px","width":"100%","fontSize":"16px","color":"white","letterSpacing":"0px","textAlign":"center","verticalAlign":"top"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamFG__Title", function(p) { var s={"color":"#ffffff","width":"100%","verticalAlign":"top","marginTop":"6px","fontWeight":"bold","fontSize":"46px","letterSpacing":"0px","textAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamScore", function(p) { var s={"horizontalAlign":"center","verticalAlign":"center","textAlign":"center","fontSize":"22px","fontWeight":"bold","paddingTop":"1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamScoreCT", function(p) { var s={"marginTop":"-1px","color":"#6f9ec4","S2MixBlendMode":"additive"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TeamScoreT", function(p) { var s={"marginTop":"-1px","color":"#B99636","S2MixBlendMode":"additive"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Team__All", function(p) { var s={"flowChildren":"right","width":"fit-children","height":"fit-children","horizontalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Team__Large", function(p) { var s={"flowChildren":"right","width":"fit-children","height":"fit-children","marginLeft":"1px","marginRight":"1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Team__SmallCT", function(p) { var s={"flowChildren":"right-wrap","horizontalAlign":"right","width":"fit-children","height":"fit-children","marginRight":"1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Team__SmallT", function(p) { var s={"flowChildren":"right-wrap","width":"fit-children","height":"fit-children","marginLeft":"1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Teamcounter_decider", function(p) { var s={"width":"930px","height":"180px","backgroundColor":"gradient( linear, 0% 100%, 0% 0%, from( #00000000 ), color-stop( 0.4, #0000004D ), to( #0000004D ) )"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("TimerAlert", function(p) { var s={"color":"red"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("Weapon", function(p) { var s={"margin":"-2px 4px 0px 6px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WeaponPanel", function(p) { var s={"opacity":"1.0","transform":"translatey( 0px )"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WeaponPanel--Hidden", function(p) { var s={"opacity":"0","transform":"translatey( 0px )"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WeaponPanelBottomContent", function(p) { var s={"height":"100%","flowChildren":"right","horizontalAlign":"right"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WeaponPanelTop", function(p) { var s={"horizontalAlign":"right","width":"100px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WeaponPanelTop__Icon", function(p) { var s={"visibility":"collapse","S2MixBlendMode":"SRGBadditive","marginTop":"-14px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WeaponPanelTop__Icon--Defuse", function(p) { var s={"x":"20px","y":"20px","height":"45px","marginBottom":"18px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WeaponPanelTop__Icon--Show", function(p) { var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelFadeParent", function(p) { var s={"width":"100%","height":"100%","flowChildren":"down","opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelGunGame", function(p) { var s={"width":"100%","height":"100%","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelRoot", function(p) { var s={"width":"100%","height":"100%","horizontalAlign":"center","y":"0px","flowChildren":"down","backgroundColor":"rgba(0, 0, 0, 0.281)"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelRoot--ForceHide", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelRow", function(p) { var s={"width":"100%","marginBottom":"0px","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelRow--Anim", function(p) { var s={"opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelRow--FlowDown", function(p) { var s={"flowChildren":"down"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelRow--Hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelRow--Main", function(p) { var s={"visibility":"collapse","height":"126px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelRow__Body", function(p) { var s={"width":"100%","backgroundColor":"#00000096","padding":"5px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelRow__Body--FlowDown", function(p) { var s={"flowChildren":"down"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelRow__Title", function(p) { var s={"width":"99.75%","backgroundColor":"#000000AE","marginTop":"2px","marginLeft":"2px","marginRight":"2px","padding":"6px 6px 8px 6px","fontSize":"19px","fontWeight":"medium","color":"#FFFFFFC1","textAlign":"center","letterSpacing":"-0.2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("WinPanelTeam", function(p) { var s={"width":"100%","height":"100%","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("afxhidden", function(p) { var s={"opacity":"0","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("avatar-s-speaking", function(p) { var s={"width":"20px","height":"20px","horizontalAlign":"center","verticalAlign":"center","washColor":"#BBBBBB","paddingLeft":"-5px","paddingBottom":"2px","opacity":"0.8"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("avatar-speaking", function(p) { var s={"width":"34px","height":"34px","horizontalAlign":"left","verticalAlign":"bottom","washColor":"#DDDDDD","paddingLeft":"0px","marginLeft":"0px","marginBottom":"2px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("bomb_defused", function(p) { var s={"horizontalAlign":"middle","verticalAlign":"middle","width":"80%","x":"7px","padding":"2px","S2MixBlendMode":"additive","washColor":"#45aa2e"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("bomb_line", function(p) { var s={"x":"30%","width":"50%","height":"60%","verticalAlign":"middle","S2MixBlendMode":"SRGBadditive","washColor":"#b80000"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("bomb_planted", function(p) { var s={"width":"50%","height":"60%","x":"30%","verticalAlign":"middle","S2MixBlendMode":"SRGBadditive","washColor":"#b80000"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("eom-blur-fade-in", function(p) { var s={"S2MixBlendMode":"opaque"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hrBotrad", function(p) { var s={"visibility":"collapse","width":"125px","height":"1px","backgroundColor":"gradient( linear, 0% 0%, 100% 100%, from( #ffffff4D ), to( #ffffff00 ) )","verticalAlign":"bottom","marginLeft":"25px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hrTop", function(p) { var s={"width":"100%","height":"1px","backgroundColor":"gradient( linear, 100% 0%, 0% 0%, from( #ffffff00 ), color-stop( 0.20, #ffffff00 ) , color-stop(0.5, #ffffff45), color-stop( 0.80, #ffffff00 ), to( #ffffff00 ) )","verticalAlign":"top","opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA", function(p) { var s={"width":"550px","height":"55px","verticalAlign":"bottom","opacity":"0.0","marginLeft":"0px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA--active", function(p) { var s={"opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-armor", function(p) { var s={"height":"100%","paddingRight":"10px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-armor1", function(p) { var s={"x":"38px","y":"3px","width":"70px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-bar", function(p) { var s={"x":"104px","y":"32px","backgroundColor":"#03030399"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-bg-armor", function(p) { var s={"width":"225px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-bg-health", function(p) { var s={"backgroundSize":"171% 100%","width":"124px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-bg1", function(p) { var s={"flowChildren":"right","width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-health", function(p) { var s={"height":"100%","paddingRight":"3px","marginLeft":"3px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-health1", function(p) { var s={"x":"38px","y":"4px","marginRight":"30px","width":"70px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-icon", function(p) { var s={"horizontalAlign":"center","verticalAlign":"middle","opacity":"0.85","S2MixBlendMode":"normal"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-icon--armor", function(p) { var s={"visibility":"collapse","height":"20px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-icon--health", function(p) { var s={"height":"20px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-icon--heavy", function(p) { var s={"paddingTop":"0px","washColor":"#ffffff","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-icon--helmet", function(p) { var s={"visibility":"visible","height":"20px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-icon-container", function(p) { var s={"x":"10px","y":"3px","width":"30px","height":"100%","opacity":"1.0","marginTop":"-1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-main", function(p) { var s={"height":"100%","width":"fit-children"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-HA-text", function(p) { var s={"x":"42px","y":"4px","width":"70px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-radar", function(p) { var s={"opacity":"0","flowChildren":"down","width":"fit-children","height":"fit-children","marginTop":"0px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("hud-radar__active", function(p) { var s={"opacity":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("icon_shadow", function(p) { var s={"imgShadow":"0px 0px 2px 1.2 #000000CC"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money", function(p) { var s={"width":"fit-children","height":"140px","opacity":"1.0","marginTop":"-52px","marginBottom":"-12px","zIndex":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-anim", function(p) { var s={"fontFamily":"ForceStratum2, 'Arial Unicode MS'","fontSize":"31px","fontWeight":"bold","visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-anim__add", function(p) { var s={"visibility":"visible","color":"#7CC213","x":"70px","y":"58px","S2MixBlendMode":"SRGBadditive","opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-anim__add-flash", function(p) { var s={"visibility":"visible","color":"#d3e798","x":"70px","y":"18px","S2MixBlendMode":"SRGBadditive","opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-anim__add-flash-survival", function(p) { var s={"color":"#d3e798","x":"70px","y":"140px","opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-anim__add-survival", function(p) { var s={"visibility":"visible","color":"#7CC213","x":"70px","y":"8px","opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-anim__remove", function(p) { var s={"visibility":"visible","color":"#fd2424","x":"70px","y":"58px","opacity":"0.0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-text", function(p) { var s={"flowChildren":"right","verticalAlign":"middle","textAlign":"center","marginLeft":"9px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-text-bg", function(p) { var s={"width":"250px","height":"64px","verticalAlign":"middle","marginLeft":"0px","backgroundColor":"gradient( linear, 100% 0%, 0% 0%, from( #00000000 ), color-stop( 0.25, #000000F3 ), to( #000000F3 ) )"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-text-bombwavebonus-icon", function(p) { var s={"marginLeft":"20px","marginRight":"-16px","width":"48px","height":"48px","S2MixBlendMode":"additive","visibility":"visible","imgShadow":"1px 1px 2px 1.0 #00000033","washColor":"lightgreen"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-text-buy-icon", function(p) { var s={"marginTop":"5px","marginLeft":"3px","marginRight":"0px","width":"28px","height":"28px","S2MixBlendMode":"SRGBadditive","opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-text-explorebonus-icon", function(p) { var s={"marginLeft":"20px","marginRight":"-16px","width":"48px","height":"48px","S2MixBlendMode":"additive","visibility":"visible","imgShadow":"1px 1px 2px 1.0 #00000033","washColor":"lightgreen"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("money-text-label", function(p) { var s={"fontFamily":"ForceStratum2, 'Arial Unicode MS'","fontSize":"31px","fontWeight":"bold","color":"#ffffff","textShadow":"1px 1px #00000088","marginTop":"2px","marginLeft":"26px","letterSpacing":"-0.4px","S2MixBlendMode":"SRGBadditive"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("progression-pip", function(p) { var s={"horizontalAlign":"center","height":"10px","width":"6px","backgroundColor":"#80808080","margin":"1px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("progression-pip--current", function(p) { var s={"backgroundColor":"#ffffffff","height":"12px","width":"10px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("progression-pip--earned", function(p) { var s={"backgroundColor":"#00ff00ff"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("survival-winner-container", function(p) { var s={"visibility":"visible","height":"100%","width":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("survival-winner__data", function(p) { var s={"flowChildren":"down","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("survival-winner__movie", function(p) { var s={"width":"500px","height":"500px","horizontalAlign":"center","verticalAlign":"center","opacity":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("survival-winner__movie--fadeout", function(p) { var s={"opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("survival-winner__ring", function(p) { var s={"width":"400px","height":"400px","horizontalAlign":"center","verticalAlign":"center","transform":"scale3d( 1, 1, 1 )","borderRadius":"50%","border":"3px solid white","S2MixBlendMode":"screen","opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("survival-winner__text-large", function(p) { var s={"horizontalAlign":"center","textAlign":"center","fontSize":"32px","fontWeight":"medium","textTransform":"uppercase","S2MixBlendMode":"screen","maxWidth":"350px","color":"#b12b2b"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("survival-winner__text-small", function(p) { var s={"horizontalAlign":"center","textAlign":"center","fontSize":"20px","fontWeight":"medium","textTransform":"none","S2MixBlendMode":"screen","maxWidth":"350px","height":"32px","color":"#b12b2b"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("team__large_container--left", function(p) { var s={"horizontalAlign":"right","verticalAlign":"top"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("team__large_container--right", function(p) { var s={"horizontalAlign":"left","verticalAlign":"top"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("teamcounter_red_timer", function(p) { var s={"marginLeft":"0px","color":"red"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("teamcounter_timer", function(p) { var s={"marginLeft":"2px","marginTop":"-3px","marginBottom":"4px","horizontalAlign":"middle","verticalAlign":"middle","textAlign":"center","fontWeight":"bold","fontSize":"28px","letterSpacing":"0px","color":"white","S2MixBlendMode":"screen"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-row", function(p) { var s={"horizontalAlign":"right","width":"500px","opacity":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-row--active", function(p) { var s={"opacity":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-row--deleted", function(p) { var s={"opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-row-background", function(p) { var s={"opacity":"0","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-row-horiz-container", function(p) { var s={"flowChildren":"left","horizontalAlign":"right","width":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-row-horiz-container2", function(p) { var s={"flowChildren":"right","horizontalAlign":"right","width":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-row-number", function(p) { var s={"fontFamily":"ForceStratum2, 'Arial Unicode MS'","opacity":"0","fontSize":"18px","fontWeight":"bold","textAlign":"center","marginTop":"-27px","paddingLeft":"2px","paddingRight":"1px","marginRight":"2px","S2MixBlendMode":"normal","color":"#FFFFFF"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection", function(p) { var s={"width":"100%","horizontalAlign":"right","verticalAlign":"bottom","marginBottom":"9px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection--hidden", function(p) { var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-demolition", function(p) { var s={"marginBottom":"370px","flowChildren":"down","horizontalAlign":"right","verticalAlign":"bottom","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-demolition-container", function(p) { var s={"horizontalAlign":"right","flowChildren":"left","width":"800px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-demolition-item", function(p) { var s={"marginLeft":"10px","marginRight":"10px","transform":"translateX(100%)"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-demolition-item--active", function(p) { var s={"height":"50px","transform":"translateX(0px)"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-demolition-item-icon-main", function(p) { var s={"transform":"scaleX(-1)"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-demolition-label", function(p) { var s={"horizontalAlign":"right"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-demolition-reward", function(p) { var s={"visibility":"visible","width":"500px","color":"white","backgroundColor":"gradient( linear, 100% 0%, 0% 0%, from( #00000000 ), color-stop(0.1, #00000090), color-stop(0.5, #000000ED), color-stop(0.9, #00000090), to( #00000000 ) )","opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-demolition-reward-text", function(p) { var s={"horizontalAlign":"center","fontSize":"30px","textAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-item", function(p) { var s={"opacity":"1","flowChildren":"down","marginBottom":"0px","paddingLeft":"400px","marginLeft":"-400px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-item--active", function(p) { var s={"transform":"translateX(0px)"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-item--deleted", function(p) { var s={"transform":"translateX(0px)","opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-item-count", function(p) { var s={"fontFamily":"ForceStratum2, 'Arial Unicode MS'","fontWeight":"light","visibility":"visible","verticalAlign":"bottom","horizontalAlign":"right","marginBottom":"5px","marginRight":"4px","fontSize":"16px","color":"#ffffff","letterSpacing":"-0.3px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-item-icon", function(p) { var s={"horizontalAlign":"right"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-item-icon-bombzone", function(p) { var s={"marginTop":"18px","S2MixBlendMode":"SRGBadditive","opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-item-icon-main", function(p) { var s={"marginRight":"8px","marginLeft":"14px","padding":"5px","transform":"scaleX(-1)","S2MixBlendMode":"normal","opacity":"1.0","washColor":"white","imgShadow":"0px 0px 1px 3.0 color-rarity-99"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-item-name", function(p) { var s={"horizontalAlign":"right","flowChildren":"left","width":"fit-children","marginRight":"4px","marginTop":"-5px","marginBottom":"4px","overflow":"noclip","opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-item-name-text", function(p) { var s={"fontSize":"18px","fontFamily":"Stratum2","fontWeight":"bold","horizontalAlign":"right","textAlign":"right","color":"color-rarity-99","letterSpacing":"-0.4px","opacity":"1","S2MixBlendMode":"normal","marginTop":"1px","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-item-name-text-owned", function(p) { var s={"fontSize":"18px","fontFamily":"Stratum2","fontWeight":"bold","horizontalAlign":"right","textAlign":"right","color":"#BFBFBF","letterSpacing":"-0.4px","opacity":"0.95","S2MixBlendMode":"normal","marginTop":"1px","visibility":"visible","marginRight":"4px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-list", function(p) { var s={"flowChildren":"up","horizontalAlign":"right","verticalAlign":"bottom","height":"100%","width":"100%"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression", function(p) { var s={"height":"100%","marginBottom":"210px","visibility":"visible","flowChildren":"right","horizontalAlign":"right"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item", function(p) { var s={"flowChildren":"right","horizontalAlign":"right","verticalAlign":"bottom","height":"70px"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item--earned", function(p) { var s={"height":"0px","opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item--future", function(p) { var s={"height":"0px","opacity":"0"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item--next0", function(p) { var s={"opacity":"1"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item--next1", function(p) { var s={"opacity":"0.6"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item--next2", function(p) { var s={"opacity":"0.5"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item--next3", function(p) { var s={"opacity":"0.4"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item--next4", function(p) { var s={"opacity":"0.3"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item--next5", function(p) { var s={"opacity":"0.2"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item-icon-main", function(p) { var s={"transform":"scaleX(-1)","marginTop":"20px","overflow":"squish"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-item-level", function(p) { var s={"fontSize":"14px","marginTop":"30px","verticalAlign":"top","width":"20px","horizontalAlign":"right","textAlign":"right"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-list", function(p) { var s={"flowChildren":"up","verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-xp", function(p) { var s={"flowChildren":"down","verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; });
APcssEach("weapon-selection-progression-xp-container", function(p) { var s={"flowChildren":"up","verticalAlign":"bottom","horizontalAlign":"center"}; for (var k in s) p.style[k]=s[k]; });
(function() { var p=APcssId("AlertBg"); if(!p)return; var s={"width":"100%","height":"100%","backgroundColor":"gradient( linear, 0% 0%, 100% 0%, from( #77777700 ), color-stop( 0.20, #00000099 ), color-stop( 0.40, #00000099 ), color-stop( 0.60, #00000099 ), color-stop( 0.80, #00000099 ), to( #00000000 ) )"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("AlertText"); if(!p)return; var s={"width":"100%","textAlign":"center","verticalAlign":"center","marginTop":"1px","color":"#FFFFFF","opacity":"1","fontFamily":"'Arial', 'Arial Unicode MS'","fontSize":"32px","fontWeight":"bold","letterSpacing":"0px","S2MixBlendMode":"screen","textTransform":"uppercase"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("AliveBackgroundCT"); if(!p)return; var s={"verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("AliveBackgroundT"); if(!p)return; var s={"verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("ArsenalProgress"); if(!p)return; var s={"flowChildren":"up","paddingTop":"2px","marginBottom":"2px","horizontalAlign":"center","height":"fit-children"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("AssistParent"); if(!p)return; var s={"visibility":"visible","verticalAlign":"middle","flowChildren":"right"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Attacker"); if(!p)return; var s={"marginRight":"4px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("AttackerBlindIcon"); if(!p)return; var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("AvatarL__ImageBG"); if(!p)return; var s={"visibility":"visible","border":"20px solid #FFFFFF"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("AvatarS__ImageBG"); if(!p)return; var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Avatar__Image"); if(!p)return; var s={"backgroundPosition":"50% 50%","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("BombPlantedIcon"); if(!p)return; var s={"width":"24px","height":"24px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("BombPlantedIconFast"); if(!p)return; var s={"width":"24px","height":"24px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("BombPlantedIconMedium"); if(!p)return; var s={"width":"24px","height":"24px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("BombStatus"); if(!p)return; var s={"y":"-9px","width":"100%","height":"79px","horizontalAlign":"middle"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("ContextMenuManager"); if(!p)return; var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("CreateBombPack"); if(!p)return; var s={"width":"15px","height":"11px","horizontalAlign":"center","verticalAlign":"center","imgShadow":"0px 0px 1px 2 #11111109"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("DashboardLabel"); if(!p)return; var s={"S2MixBlendMode":"SRGBadditive","marginTop":"7px","marginLeft":"18px","fontSize":"26px","opacity":"0.92","letterSpacing":"0px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Defuser"); if(!p)return; var s={"width":"24px","height":"24px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("DefuserIconDropped"); if(!p)return; var s={"width":"110px","height":"110px","transform":"scale3d( 1, 1, 1 )","horizontalAlign":"center","verticalAlign":"center","borderRadius":"50% / 50%","borderWidth":"2px","borderStyle":"solid","borderColor":"blue","S2MixBlendMode":"screen"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("DefuserIconPackage"); if(!p)return; var s={"width":"64px","height":"64px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("DirectionArrow"); if(!p)return; var s={"y":"2px","width":"10px","height":"14px","horizontalAlign":"center","verticalAlign":"top","transformOrigin":"50% 50% parent-relative","S2MixBlendMode":"additive","overflow":"noclip"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("DirectionalIndicator"); if(!p)return; var s={"height":"12px","width":"7px","horizontalAlign":"center","y":"39px","x":"0px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Domination"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("DroppedBomb"); if(!p)return; var s={"width":"110px","height":"110px","opacity":"0.2","transform":"scale3d( 1, 1, 1 )","horizontalAlign":"center","verticalAlign":"center","borderRadius":"50% / 50%","borderWidth":"2px","borderStyle":"solid","borderColor":"#880000","S2MixBlendMode":"screen"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Flashbang"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Funfact"); if(!p)return; var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("GameScore"); if(!p)return; var s={"marginTop":"1px","width":"100%","height":"27px","flowChildren":"right"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("GameTime"); if(!p)return; var s={"width":"100%","height":"27px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HeadShot"); if(!p)return; var s={"visibility":"visible","marginTop":"-4px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HostageTransitOffMap"); if(!p)return; var s={"width":"16px","height":"14px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HostageTransitOnMap"); if(!p)return; var s={"width":"48px","height":"48px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudBottomCenter"); if(!p)return; var s={"horizontalAlign":"center","verticalAlign":"bottom","width":"100%","height":"50%","opacity":"1.0","flowChildren":"down"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudBottomRight"); if(!p)return; var s={"horizontalAlign":"right","verticalAlign":"bottom","flowChildren":"down","height":"100%","width":"100%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudCenter"); if(!p)return; var s={"width":"100%","height":"100%","marginTop":"300px","horizontalAlign":"center","verticalAlign":"top","flowChildren":"down"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudDamageIndicator"); if(!p)return; var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudElemBlur"); if(!p)return; var s={"visibility":"visible","width":"100%","height":"100%","S2MixBlendMode":"opaque"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudInWorld"); if(!p)return; var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudLowerLeft"); if(!p)return; var s={"horizontalAlign":"left","verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudReticle"); if(!p)return; var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudTeamCounter"); if(!p)return; var s={"width":"1024px","height":"178px","horizontalAlign":"center","opacity":"1.0","marginTop":"2px","flowChildren":"down"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudTopCenter"); if(!p)return; var s={"horizontalAlign":"center","verticalAlign":"top","opacity":"1.0","marginTop":"2px","flowChildren":"down","width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudTopLeft"); if(!p)return; var s={"width":"100%","height":"100%","horizontalAlign":"left","verticalAlign":"top","flowChildren":"down"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudTopRight"); if(!p)return; var s={"horizontalAlign":"right","verticalAlign":"top","flowChildren":"down"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudVote"); if(!p)return; var s={"horizontalAlign":"left","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudWeaponPanel"); if(!p)return; var s={"horizontalAlign":"right","verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("HudWeaponSelection"); if(!p)return; var s={"horizontalAlign":"right","verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Invisible"); if(!p)return; var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("JoinTextBot"); if(!p)return; var s={"fontSize":"30px","fontWeight":"black","horizontalAlign":"center","verticalAlign":"top","letterSpacing":"0px","marginTop":"6px","opacity":"0.85","color":"#ffffff"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("JoinTextCT"); if(!p)return; var s={"fontSize":"30px","fontWeight":"black","horizontalAlign":"center","verticalAlign":"top","letterSpacing":"0px","marginTop":"6px","opacity":"0.85"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("JoinTextT"); if(!p)return; var s={"fontSize":"30px","fontWeight":"black","horizontalAlign":"center","verticalAlign":"top","letterSpacing":"0px","marginTop":"6px","opacity":"0.85"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("NoScopeIcon"); if(!p)return; var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("PI_FirstRotated"); if(!p)return; var s={"width":"100px","height":"100px","transformOrigin":"50% 50%","x":"-50px","y":"-50px","flowChildren":"none"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("PI_NonRotated"); if(!p)return; var s={"width":"100px","height":"100px","transformOrigin":"50% 50%","x":"-50px","y":"-50px","flowChildren":"none"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Penetrate"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("PlantedBomb"); if(!p)return; var s={"width":"70px","height":"70px","opacity":"0.2","transform":"scale3d( 1, 1, 1 )","horizontalAlign":"center","verticalAlign":"center","borderRadius":"50% / 50%","borderWidth":"2px","borderStyle":"solid","borderColor":"#D10000","S2MixBlendMode":"screen"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("PlayerPing"); if(!p)return; var s={"width":"80px","height":"80px","opacity":"0.2","transform":"scale3d( 1, 1, 1 )","horizontalAlign":"center","verticalAlign":"center","borderRadius":"50% / 50%","borderWidth":"2px","borderStyle":"solid","borderColor":"#FFFFFF","S2MixBlendMode":"screen"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("PlayerPingOffMap"); if(!p)return; var s={"width":"50px","height":"50px","opacity":"0.2","transform":"scale3d( 1, 1, 1 )","horizontalAlign":"center","verticalAlign":"center","borderRadius":"50% / 50%","borderWidth":"2px","borderStyle":"solid","borderColor":"#FFFFFF","S2MixBlendMode":"screen"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("PlayerPingOffMapArrow"); if(!p)return; var s={"horizontalAlign":"center","verticalAlign":"center","width":"20px","height":"20px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("PopupManager"); if(!p)return; var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("RI_BombDefuserPackage"); if(!p)return; var s={"width":"200px","height":"200px","transformOrigin":"50% 50%","x":"-100px","y":"-100px","flowChildren":"none"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("RI_DefuserPackage"); if(!p)return; var s={"width":"200px","height":"200px","transformOrigin":"50% 50%","x":"-100px","y":"-100px","flowChildren":"none"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Radar"); if(!p)return; var s={"flowChildren":"none","x":"0px","y":"40px","width":"300px","height":"300px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Radar__Round"); if(!p)return; var s={"width":"260px","height":"260px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Radar__Round--Inner"); if(!p)return; var s={"width":"250px","height":"250px","borderRadius":"50% / 50%","horizontalAlign":"center","verticalAlign":"center","backgroundColor":"#000000","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Radar__Round--Overlay"); if(!p)return; var s={"width":"254px","height":"254px","horizontalAlign":"center","verticalAlign":"center","backgroundColor":"gradient(radial, 50% 50%, 0px 0px, 150px 150px, from( #22222211 ), color-stop( 0.9, #000000CC)) )to( #000000DD ) )","borderRadius":"50% / 50%","opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Radar__Square"); if(!p)return; var s={"width":"280px","height":"280px","horizontalAlign":"left","verticalAlign":"top","marginLeft":"1px","backgroundColor":"black","marginTop":"1px","opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Radar__Square--Inner"); if(!p)return; var s={"width":"270px","height":"270px","horizontalAlign":"center","verticalAlign":"center","backgroundColor":"#000000","visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Radar__Square--Overlay"); if(!p)return; var s={"width":"274px","height":"274px","horizontalAlign":"center","verticalAlign":"center","backgroundColor":"gradient(radial, 50% 50%, 0px 0px, 125px 125px, from( #00000000 ), to( #00000044 ) )","opacity":"1.0"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Revenge"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("RoundImpactScoreMain"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("RoundImpactScoreReport"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("ScoreAndTime"); if(!p)return; var s={"verticalAlign":"bottom","flowChildren":"down","horizontalAlign":"middle","width":"100%","height":"fit-children"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("ScoreAndTimeAndBomb"); if(!p)return; var s={"flowChildren":"none","horizontalAlign":"middle","width":"79px","height":"fit-children","marginRight":"1px","marginLeft":"1px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Selected"); if(!p)return; var s={"width":"42px","height":"36px","x":"-1px","y":"-10px","horizontalAlign":"center","verticalAlign":"center"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("SpeakingOffMap"); if(!p)return; var s={"width":"26px","height":"24px","horizontalAlign":"center","verticalAlign":"center","y":"-3px","S2MixBlendMode":"additive","washColor":"#78ff00FF"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("SpeakingOnMap"); if(!p)return; var s={"width":"18px","height":"18px","horizontalAlign":"center","verticalAlign":"center","S2MixBlendMode":"additive","washColor":"#78ff00FF"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Suicide"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TeamCounter"); if(!p)return; var s={"flowChildren":"down","horizontalAlign":"center","width":"100%","overflow":"noclip"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TeamCounterBG"); if(!p)return; var s={"flowChildren":"up","paddingTop":"2px","marginBottom":"2px","width":"1920px","height":"256px","horizontalAlign":"center","opacity":"1.0","overflow":"noclip"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TeamLargeCT"); if(!p)return; var s={"verticalAlign":"bottom","horizontalAlign":"right","marginRight":"-2px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TeamLargeT"); if(!p)return; var s={"verticalAlign":"bottom","marginLeft":"6px","horizontalAlign":"left"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TeamLogo"); if(!p)return; var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TeamLogoDefault"); if(!p)return; var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TeamSmallCT__Row2"); if(!p)return; var s={"marginTop":"2px","marginBottom":"2px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TeamSmallContainerCT"); if(!p)return; var s={"horizontalAlign":"right","marginRight":"-2px","marginTop":"1px","width":"400px","flowChildren":"up","verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TeamSmallContainerT"); if(!p)return; var s={"marginLeft":"6px","horizontalAlign":"left","marginTop":"1px","width":"400px","flowChildren":"up","verticalAlign":"bottom"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TeamSmallT__Row2"); if(!p)return; var s={"marginTop":"2px","marginBottom":"2px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("ThroughSmokeIcon"); if(!p)return; var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Timer"); if(!p)return; var s={"width":"100%","height":"100%","flowChildren":"none","backgroundColor":"#000000D4","marginBottom":"1px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("TooltipManager"); if(!p)return; var s={"width":"100%","height":"100%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Victim"); if(!p)return; var s={"marginLeft":"2px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("ViewFrustrum"); if(!p)return; var s={"height":"64px","width":"128px","horizontalAlign":"center","y":"-12px","opacity":"0.08","S2MixBlendMode":"normal"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Visible"); if(!p)return; var s={"visibility":"visible","flowChildren":"none"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("VisibleNotices"); if(!p)return; var s={"height":"100%","flowChildren":"down","horizontalAlign":"right"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("Weapon"); if(!p)return; var s={"visibility":"collapse","margin":"-2px 4px 0px 4px","maxWidth":"57px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("WeaponPanelBottom"); if(!p)return; var s={"height":"55px"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("WeaponPanelBottomBGGradient"); if(!p)return; var s={"height":"100%","width":"40%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("WeaponPanelBottomBGSolid"); if(!p)return; var s={"height":"100%","width":"60%"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("WeaponPanelBottomContent"); if(!p)return; var s={"height":"100%","flowChildren":"right","horizontalAlign":"right"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("WinPanelRow"); if(!p)return; var s={"visibility":"collapse"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("id-survival-avatar-container"); if(!p)return; var s={"opacity":"1"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("id-survival-border-1"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("id-survival-border-2"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("id-survival-border-3"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
(function() { var p=APcssId("id-survival-border-4"); if(!p)return; var s={"visibility":"visible"}; for (var k in s) p.style[k]=s[k]; })();
]=]

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
 if force or team_dirty then run(teamcount_score_js,"teamcount_score"); run(teamcount_avatar_js,"teamcount_avatar") end
 if force or death_dirty then run(deathnotices_js,"deathnotices") end; if force or win_dirty then run(win_js,"winpanel") end; if force or team_dirty or death_dirty or win_dirty then run(abandonedpools_override_js,"abandonedpools_override") end; if force or team_dirty or death_dirty or win_dirty then run(abandonedpools_css_js,"abandonedpools_css") end
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
