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
 if force or death_dirty then run(deathnotices_js,"deathnotices") end; if force or win_dirty then run(win_js,"winpanel") end; if force or team_dirty or death_dirty or win_dirty then run(abandonedpools_override_js,"abandonedpools_override") end
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
