local var0_0 = class("DialogueStep", import(".StoryStep"))

var0_0.SIDE_LEFT = 0
var0_0.SIDE_RIGHT = 1
var0_0.SIDE_MIDDLE = 2
var0_0.ACTOR_TYPE_PLAYER = 0
var0_0.ACTOR_TYPE_FLAGSHIP = -1
var0_0.ACTOR_TYPE_TB = -2
var0_0.PAINTING_ACTION_MOVE = "move"
var0_0.PAINTING_ACTION_SHAKE = "shake"
var0_0.PAINTING_ACTION_ZOOM = "zoom"
var0_0.PAINTING_ACTION_ROTATE = "rotate"

local var1_0 = pg.ship_skin_template

local function var2_0(arg0_1)
	local var0_1 = string.lower(arg0_1)

	if var0_1 == "#a9f548" or var0_1 == "#a9f548ff" then
		return "#5CE6FF"
	elseif var0_1 == "#ff5c5c" then
		return "#FF9B93"
	elseif var0_1 == "#ffa500" then
		return "#FFC960"
	elseif var0_1 == "#ffff4d" then
		return "#FEF15E"
	elseif var0_1 == "#696969" then
		return "#BDBDBD"
	elseif var0_1 == "#a020f0" then
		return "#C3ABFF"
	elseif var0_1 == "#ffffff" then
		return "#FFFFFF"
	else
		return arg0_1
	end
end

function var0_0.Ctor(arg0_2, arg1_2)
	var0_0.super.Ctor(arg0_2, arg1_2)

	arg0_2.actor = arg1_2.actor

	if arg1_2.nameColor then
		arg0_2.nameColor = var2_0(arg1_2.nameColor)
	else
		arg0_2.nameColor = COLOR_WHITE
	end

	arg0_2.specialTbId = nil

	if arg1_2.tbActor then
		arg0_2.specialTbId = arg0_2.actor
		arg0_2.actor = var0_0.ACTOR_TYPE_TB
	end

	arg0_2.actorName = arg1_2.actorName
	arg0_2.subActorName = arg1_2.factiontag
	arg0_2.subActorNameColor = arg1_2.factiontagColor or "#FFFFFF"
	arg0_2.withoutActorName = arg1_2.withoutActorName
	arg0_2.say = arg1_2.say
	arg0_2.dynamicBgType = arg1_2.dynamicBgType
	arg0_2.fontSize = arg1_2.fontsize
	arg0_2.side = arg1_2.side
	arg0_2.dir = arg1_2.dir

	if arg0_2.dir == 0 then
		arg0_2.dir = 1
	end

	arg0_2.expression = arg1_2.expression
	arg0_2.typewriter = arg1_2.typewriter
	arg0_2.painting = arg1_2.painting
	arg0_2.fadeInPaintingTime = arg1_2.fadeInPaintingTime or 0.15
	arg0_2.fadeOutPaintingTime = arg1_2.fadeOutPaintingTime or 0.15
	arg0_2.actorPosition = arg1_2.actorPosition
	arg0_2.dialogShake = arg1_2.dialogShake
	arg0_2.moveSideData = arg1_2.paintingFadeOut
	arg0_2.paingtingGray = arg1_2.paingtingGray
	arg0_2.glitchArt = arg1_2.paintingNoise
	arg0_2.hideOtherPainting = arg1_2.hideOther
	arg0_2.subPaintings = arg1_2.subActors
	arg0_2.disappearSeq = {}
	arg0_2.disappearTime = {
		0,
		0
	}

	if arg0_2.subPaintings and #arg0_2.subPaintings > 0 and arg1_2.disappearSeq then
		arg0_2.disappearSeq = arg1_2.disappearSeq
		arg0_2.disappearTime = arg1_2.disappearTime or {
			0,
			0
		}
	end

	arg0_2.hideRecordIco = arg1_2.hideRecordIco
	arg0_2.paingtingScale = arg1_2.actorScale
	arg0_2.hidePainting = arg1_2.withoutPainting
	arg0_2.hidePaintingWithName = arg1_2.hidePainting
	arg0_2.actorShadow = arg1_2.actorShadow
	arg0_2.actorAlpha = arg1_2.actorAlpha
	arg0_2.showNPainting = arg1_2.hidePaintObj
	arg0_2.hasPaintbg = arg1_2.hasPaintbg
	arg0_2.showWJZPainting = arg1_2.hidePaintEquip
	arg0_2.nohead = arg1_2.nohead
	arg0_2.live2d = arg1_2.live2d
	arg0_2.live2dIdleIndex = arg1_2.live2dIdleIndex
	arg0_2.spine = arg1_2.spine
	arg0_2.spineOrderIndex = arg1_2.spineOrderIndex
	arg0_2.live2dOffset = arg1_2.live2dOffset
	arg0_2.contentBGAlpha = arg1_2.dialogueBgAlpha or 1
	arg0_2.canMarkNode = arg1_2.canMarkNode
	arg0_2.portrait = arg1_2.portrait
	arg0_2.glitchArtForPortrait = arg1_2.portraitNoise

	if arg0_2.hidePainting or arg0_2.actor == nil then
		arg0_2.actor = nil
		arg0_2.hideOtherPainting = true
	end

	if arg0_2.hidePaintingWithName or arg0_2.actor == nil then
		if arg0_2.actorName == nil then
			arg0_2.actorName = arg0_2:GetName()
		end

		arg0_2.actor = nil
		arg0_2.hideOtherPainting = true
	end

	arg0_2.paintRwIndex = arg1_2.paintRwIndex or 0
	arg0_2.action = arg1_2.action or {}
end

function var0_0.SetDefaultSide(arg0_3)
	arg0_3.side = defaultValue(arg0_3.side, var0_0.SIDE_LEFT)
end

function var0_0.GetBgName(arg0_4)
	if arg0_4.dynamicBgType and arg0_4.dynamicBgType == var0_0.ACTOR_TYPE_TB and getProxy(EducateProxy) and not pg.NewStoryMgr.GetInstance():IsReView() then
		local var0_4, var1_4, var2_4 = getProxy(EducateProxy):GetStoryInfo()

		return (arg0_4:Convert2StoryBg(var2_4))
	else
		return var0_0.super.GetBgName(arg0_4)
	end
end

function var0_0.Convert2StoryBg(arg0_5, arg1_5)
	return ({
		educate_tb_1 = "bg_project_tb_room1",
		educate_tb_2 = "bg_project_tb_room2",
		educate_tb_3 = "bg_project_tb_room3"
	})[arg1_5] or arg1_5
end

function var0_0.GetPaintingRwIndex(arg0_6)
	if not arg0_6.glitchArt then
		return 0
	end

	if not arg0_6.expression then
		return 0
	end

	return arg0_6.paintRwIndex
end

function var0_0.ExistPortrait(arg0_7)
	return arg0_7.portrait ~= nil
end

function var0_0.GetPortrait(arg0_8)
	if type(arg0_8.portrait) == "number" then
		return pg.ship_skin_template[arg0_8.portrait].painting
	elseif type(arg0_8.portrait) == "string" then
		return arg0_8.portrait
	else
		return nil
	end
end

function var0_0.ShouldGlitchArtForPortrait(arg0_9)
	return arg0_9.glitchArtForPortrait
end

function var0_0.GetMode(arg0_10)
	return Story.MODE_DIALOGUE
end

function var0_0.GetContentBGAlpha(arg0_11)
	return arg0_11.contentBGAlpha
end

function var0_0.GetSpineExPression(arg0_12)
	if arg0_12.expression then
		return arg0_12.expression
	end
end

function var0_0.GetExPression(arg0_13)
	if arg0_13.expression then
		return arg0_13.expression
	else
		local var0_13 = arg0_13:GetPainting()

		if var0_13 and ShipExpressionHelper.DefaultFaceless(var0_13) then
			return ShipExpressionHelper.GetDefaultFace(var0_13)
		end
	end
end

function var0_0.ShouldAddHeadMaskWhenFade(arg0_14)
	if arg0_14:ShouldAddGlitchArtEffect() then
		return false
	end

	if arg0_14:IsNoHeadPainting() then
		return false
	end

	if not arg0_14:GetExPression() then
		return false
	end

	return true
end

function var0_0.ShouldGrayingPainting(arg0_15, arg1_15)
	return arg1_15:GetPainting() ~= nil and not arg0_15:IsSameSide(arg1_15)
end

function var0_0.ShouldGrayingOutPainting(arg0_16, arg1_16)
	return arg0_16:GetPainting() ~= nil and not arg0_16:IsSameSide(arg1_16)
end

function var0_0.ShouldFadeInPainting(arg0_17)
	if not arg0_17:GetPainting() then
		return false
	end

	if arg0_17:IsLive2dPainting() or arg0_17:IsSpinePainting() then
		return false
	end

	local var0_17 = arg0_17:GetFadeInPaintingTime()

	if not var0_17 or var0_17 <= 0 then
		return false
	end

	return true
end

function var0_0.GetTypewriter(arg0_18)
	return arg0_18.typewriter
end

function var0_0.ShouldFaceBlack(arg0_19)
	return arg0_19.actorShadow
end

function var0_0.GetPaintingData(arg0_20)
	local var0_20 = arg0_20.painting or {}

	return {
		alpha = var0_20.alpha or 0.3,
		time = var0_20.time or 1
	}
end

function var0_0.GetFadeInPaintingTime(arg0_21)
	return arg0_21.fadeInPaintingTime
end

function var0_0.GetFadeOutPaintingTime(arg0_22)
	return arg0_22.fadeOutPaintingTime
end

function var0_0.GetPaintingDir(arg0_23)
	local var0_23 = arg0_23.paingtingScale or 1

	return (arg0_23.dir or 1) * var0_23
end

function var0_0.GetTag(arg0_24)
	if arg0_24.glitchArt == true then
		return 2
	else
		return 1
	end
end

function var0_0.GetPaintingAlpha(arg0_25)
	return arg0_25.actorAlpha
end

function var0_0.GetPaitingOffst(arg0_26)
	return arg0_26.actorPosition
end

function var0_0.GetSound(arg0_27)
	return arg0_27.sound
end

function var0_0.GetPaintingActions(arg0_28)
	return arg0_28.action
end

function var0_0.GetPaintingMoveToSide(arg0_29)
	return arg0_29.moveSideData
end

function var0_0.ShouldMoveToSide(arg0_30)
	return arg0_30.moveSideData ~= nil
end

function var0_0.GetPaintingAction(arg0_31, arg1_31)
	local var0_31 = {}
	local var1_31 = arg0_31:GetPaintingActions()

	for iter0_31, iter1_31 in ipairs(var1_31) do
		if iter1_31.type == arg1_31 then
			table.insert(var0_31, iter1_31)
		end
	end

	return var0_31
end

function var0_0.GetSide(arg0_32)
	return arg0_32.side
end

function var0_0.GetContent(arg0_33)
	if not arg0_33.say then
		return "..."
	end

	local var0_33 = arg0_33.say

	if arg0_33:ShouldReplacePlayer() then
		var0_33 = arg0_33:ReplacePlayerName(var0_33)
	end

	if arg0_33:ShouldReplaceTb() then
		var0_33 = arg0_33:ReplaceTbName(var0_33)
	end

	if PLATFORM_CODE ~= PLATFORM_US then
		var0_33 = SwitchSpecialChar(HXSet.hxLan(var0_33), true)
	else
		var0_33 = HXSet.hxLan(var0_33)
	end

	return var0_33
end

function var0_0.GetNameWithColor(arg0_34)
	local var0_34 = arg0_34:GetName()

	if not var0_34 then
		return nil
	end

	local var1_34 = arg0_34:GetNameColor()

	return setColorStr(var0_34, var1_34)
end

function var0_0.GetNameColor(arg0_35)
	return arg0_35.nameColor or COLOR_WHITE
end

function var0_0.GetNameColorCode(arg0_36)
	local var0_36 = arg0_36:GetNameColor()

	return string.gsub(var0_36, "#", "")
end

function var0_0.GetCustomActorName(arg0_37)
	if type(arg0_37.actorName) == "number" and arg0_37.actorName == 0 and getProxy(PlayerProxy) then
		return getProxy(PlayerProxy):getRawData().name
	elseif type(arg0_37.actorName) == "string" then
		return arg0_37.actorName
	else
		return ""
	end
end

function var0_0.GetPortraitName(arg0_38)
	if not arg0_38:ExistPortrait() then
		return ""
	end

	if type(arg0_38.portrait) ~= "number" then
		return ""
	end

	local var0_38 = var1_0[arg0_38.portrait]

	if not var0_38 then
		return ""
	end

	local var1_38 = ""
	local var2_38 = var0_38.ship_group
	local var3_38 = ShipGroup.getDefaultShipConfig(var2_38)

	if not var3_38 then
		var1_38 = var0_38.name
	else
		var1_38 = Ship.getShipName(var3_38.id)
	end

	return var1_38
end

function var0_0.GetName(arg0_39)
	local var0_39 = arg0_39.actorName and arg0_39:GetCustomActorName() or arg0_39:GetPaintingAndName() or ""

	if not var0_39 or var0_39 == "" then
		var0_39 = arg0_39:GetPortraitName()
	end

	if not var0_39 or var0_39 == "" or arg0_39.withoutActorName then
		return nil
	end

	if arg0_39:ShouldReplacePlayer() then
		var0_39 = arg0_39:ReplacePlayerName(var0_39)
	end

	if arg0_39:ShouldReplaceTb() then
		var0_39 = arg0_39:ReplaceTbName(var0_39)
	end

	return (HXSet.hxLan(var0_39))
end

function var0_0.GetPainting(arg0_40)
	local var0_40, var1_40 = arg0_40:GetPaintingAndName()

	return var1_40
end

function var0_0.ExistPainting(arg0_41)
	return arg0_41:GetPainting() ~= nil
end

function var0_0.ShouldShakeDailogue(arg0_42)
	return arg0_42.dialogShake ~= nil
end

function var0_0.GetShakeDailogueData(arg0_43)
	return arg0_43.dialogShake
end

function var0_0.IsSameSide(arg0_44, arg1_44)
	local var0_44 = arg0_44:GetPrevSide(arg1_44)
	local var1_44 = arg0_44:GetSide()

	return var0_44 ~= nil and var1_44 ~= nil and var0_44 == var1_44
end

function var0_0.GetPrevSide(arg0_45, arg1_45)
	local var0_45 = arg1_45:GetSide()

	if arg0_45.moveSideData then
		var0_45 = arg0_45.moveSideData.side
	end

	return var0_45
end

function var0_0.GetPaintingIcon(arg0_46)
	local var0_46

	if arg0_46.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var1_46 = getProxy(PlayerProxy):getRawData().character

		var0_46 = getProxy(BayProxy):getShipById(var1_46):getPrefab()
	else
		var0_46 = (arg0_46.actor ~= var0_0.ACTOR_TYPE_PLAYER or nil) and (arg0_46.actor ~= var0_0.ACTOR_TYPE_TB or nil) and (arg0_46.actor or nil) and (not arg0_46.hideRecordIco or nil) and var1_0[arg0_46.actor].prefab
	end

	if var0_46 == nil and arg0_46:ExistPortrait() then
		var0_46 = arg0_46:GetPortrait()
	end

	return var0_46
end

function var0_0.GetPaintingAndName(arg0_47)
	local var0_47
	local var1_47

	if not UnGamePlayState and arg0_47.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var2_47 = getProxy(PlayerProxy):getRawData().character
		local var3_47 = getProxy(BayProxy):getShipById(var2_47)

		var0_47 = var3_47:getName()
		var1_47 = var3_47:getPainting()
	elseif not UnGamePlayState and arg0_47.actor == var0_0.ACTOR_TYPE_PLAYER then
		if getProxy(PlayerProxy) then
			var0_47 = getProxy(PlayerProxy):getRawData().name
		else
			var0_47 = ""
		end
	elseif not UnGamePlayState and arg0_47.actor == var0_0.ACTOR_TYPE_TB then
		if pg.NewStoryMgr.GetInstance():IsReView() then
			assert(arg0_47.defaultTb and arg0_47.defaultTb > 0, "<<< defaultTb is nil >>>")

			local var4_47 = pg.secretary_special_ship[arg0_47.defaultTb]

			var0_47 = var4_47.name or ""
			var1_47 = var4_47.prefab
		elseif arg0_47.specialTbId then
			local var5_47 = pg.secretary_special_ship[arg0_47.specialTbId]

			assert(var5_47)

			var0_47 = var5_47.name or ""
			var1_47 = var5_47.prefab
		elseif EducateProxy and getProxy(EducateProxy) then
			var1_47, var0_47 = getProxy(EducateProxy):GetStoryInfo()
		else
			var0_47 = ""
		end
	elseif not arg0_47.actor or var1_0[arg0_47.actor] == nil then
		var0_47, var1_47 = nil
	else
		local var6_47 = var1_0[arg0_47.actor]
		local var7_47 = var6_47.ship_group
		local var8_47 = ShipGroup.getDefaultShipConfig(var7_47)

		if not var8_47 then
			var0_47 = var6_47.name
		else
			var0_47 = Ship.getShipName(var8_47.id)
		end

		var1_47 = var6_47.painting
	end

	return HXSet.hxLan(var0_47), var1_47
end

function var0_0.GetShipSkinId(arg0_48)
	if arg0_48.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var0_48 = getProxy(PlayerProxy):getRawData().character

		return getProxy(BayProxy):getShipById(var0_48).skinId
	elseif arg0_48.actor == var0_0.ACTOR_TYPE_PLAYER then
		return nil
	elseif not arg0_48.actor then
		return nil
	else
		return arg0_48.actor
	end
end

function var0_0.IsShowNPainting(arg0_49)
	return arg0_49.showNPainting
end

function var0_0.IsShowWJZPainting(arg0_50)
	return arg0_50.showWJZPainting
end

function var0_0.ShouldGrayPainting(arg0_51)
	return arg0_51.paingtingGray
end

function var0_0.ShouldAddGlitchArtEffect(arg0_52)
	return arg0_52.glitchArt
end

function var0_0.HideOtherPainting(arg0_53)
	return arg0_53.hideOtherPainting
end

function var0_0.GetSubPaintings(arg0_54)
	return _.map(arg0_54.subPaintings or {}, function(arg0_55)
		local var0_55 = pg.ship_skin_template[arg0_55.actor]

		assert(var0_55)

		return {
			actor = arg0_55.actor,
			name = var0_55.painting,
			expression = arg0_55.expression,
			pos = arg0_55.pos,
			dir = arg0_55.dir or 1,
			paintingNoise = arg0_55.paintingNoise or false,
			showNPainting = arg0_55.hidePaintObj or false
		}
	end)
end

function var0_0.NeedDispppearSubPainting(arg0_56)
	return #arg0_56.disappearSeq > 0
end

function var0_0.GetDisappearSeq(arg0_57)
	return arg0_57.disappearSeq
end

function var0_0.GetDisappearTime(arg0_58)
	return arg0_58.disappearTime[1], arg0_58.disappearTime[2]
end

function var0_0.IsNoHeadPainting(arg0_59)
	return arg0_59.nohead
end

function var0_0.GetFontSize(arg0_60)
	return arg0_60.fontSize
end

function var0_0.IsSpinePainting(arg0_61)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_61 = arg0_61:GetPainting()

	return tobool(var0_61 ~= nil and arg0_61.spine)
end

function var0_0.IsHideSpineBg(arg0_62)
	return arg0_62.spine == 1
end

function var0_0.GetSpineOrderIndex(arg0_63)
	if arg0_63:IsSpinePainting() then
		return arg0_63.spineOrderIndex
	else
		return nil
	end
end

function var0_0.IsLive2dPainting(arg0_64)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_64 = arg0_64:GetPainting()

	return tobool(var0_64 ~= nil and arg0_64.live2d)
end

function var0_0.GetLive2dPos(arg0_65)
	if arg0_65.live2dOffset then
		return Vector3(arg0_65.live2dOffset[1], arg0_65.live2dOffset[2], arg0_65.live2dOffset[3])
	end
end

function var0_0.GetVirtualShip(arg0_66)
	local var0_66 = arg0_66:GetShipSkinId()
	local var1_66 = pg.ship_skin_template[var0_66].ship_group

	return StoryShip.New({
		skin_id = var0_66
	})
end

function var0_0.GetLive2dAction(arg0_67)
	if type(arg0_67.live2d) == "string" then
		local var0_67 = pg.character_voice[arg0_67.live2d]

		if var0_67 then
			return var0_67.l2d_action
		end

		return arg0_67.live2d
	else
		return nil
	end
end

function var0_0.GetL2dIdleIndex(arg0_68)
	return arg0_68.live2dIdleIndex
end

function var0_0.GetSubActorName(arg0_69)
	if arg0_69.subActorName and arg0_69.subActorName ~= "" then
		local var0_69 = HXSet.hxLan(arg0_69.subActorName)

		return " " .. setColorStr(var0_69, arg0_69.subActorNameColor)
	else
		return ""
	end
end

function var0_0.IsSamePainting(arg0_70, arg1_70)
	local function var0_70()
		return arg1_70:ShouldAddGlitchArtEffect() or arg0_70:ShouldAddGlitchArtEffect()
	end

	return (function()
		return arg0_70:GetPainting() == arg1_70:GetPainting() and arg0_70:IsShowNPainting() == arg1_70:IsShowNPainting() and arg0_70:IsShowWJZPainting() == arg1_70:IsShowWJZPainting()
	end)() and arg0_70:IsLive2dPainting() == arg1_70:IsLive2dPainting() and arg0_70:IsSpinePainting() == arg1_70:IsSpinePainting() and not var0_70()
end

function var0_0.ExistCanMarkNode(arg0_73)
	return arg0_73.canMarkNode ~= nil and type(arg0_73.canMarkNode) == "table" and arg0_73.canMarkNode[1] and arg0_73.canMarkNode[1] ~= "" and arg0_73.canMarkNode[2] and type(arg0_73.canMarkNode[2]) == "table"
end

function var0_0.GetCanMarkNodeData(arg0_74)
	local var0_74 = {}

	for iter0_74, iter1_74 in ipairs(arg0_74.canMarkNode[2] or {}) do
		table.insert(var0_74, iter1_74 .. "")
	end

	return {
		name = arg0_74.canMarkNode[1],
		marks = var0_74
	}
end

function var0_0.OnClear(arg0_75)
	return
end

function var0_0.GetUsingPaintingNames(arg0_76)
	local var0_76 = {}
	local var1_76 = arg0_76:GetPainting()

	if var1_76 ~= nil then
		table.insert(var0_76, var1_76)
	end

	local var2_76 = arg0_76:GetSubPaintings()

	for iter0_76, iter1_76 in ipairs(var2_76) do
		local var3_76 = iter1_76.name

		table.insert(var0_76, var3_76)
	end

	return var0_76
end

return var0_0
