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
	arg0_2.paingtingYFlip = arg1_2.actorYFlip
	arg0_2.hidePainting = arg1_2.withoutPainting
	arg0_2.hidePaintingWithName = arg1_2.hidePainting
	arg0_2.actorShadow = arg1_2.actorShadow
	arg0_2.actorAlpha = arg1_2.actorAlpha
	arg0_2.showNPainting = arg1_2.hidePaintObj
	arg0_2.hasPaintbg = arg1_2.hasPaintbg
	arg0_2.showWJZPainting = arg1_2.hidePaintEquip
	arg0_2.hideDialogFragment = arg1_2.hideDialogFragment
	arg0_2.nohead = arg1_2.nohead
	arg0_2.live2d = arg1_2.live2d
	arg0_2.live2dIdleIndex = arg1_2.live2dIdleIndex
	arg0_2.live2dParams = arg1_2.live2dParams
	arg0_2.spine = arg1_2.spine
	arg0_2.spineOrderIndex = arg1_2.spineOrderIndex
	arg0_2.live2dOffset = arg1_2.live2dOffset
	arg0_2.contentBGAlpha = arg1_2.dialogueBgAlpha or 1
	arg0_2.canMarkNode = arg1_2.canMarkNode
	arg0_2.portrait = arg1_2.portrait
	arg0_2.miniPortrait = false

	if arg0_2.portrait and (arg0_2.portrait == "zhihuiguan" or arg0_2.portrait == "tongxunqi") then
		arg0_2.miniPortrait = true
	end

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

function var0_0.GetL2dParams(arg0_3)
	if not arg0_3.live2dParams then
		return nil
	end

	return {
		name = arg0_3.live2dParams[1],
		value = arg0_3.live2dParams[2]
	}
end

function var0_0.SetDefaultSide(arg0_4)
	arg0_4.side = defaultValue(arg0_4.side, var0_0.SIDE_LEFT)
end

function var0_0.GetBgName(arg0_5)
	if arg0_5.dynamicBgType and arg0_5.dynamicBgType == var0_0.ACTOR_TYPE_TB and getProxy(EducateProxy) and getProxy(NewEducateProxy) and not pg.NewStoryMgr.GetInstance():IsReView() then
		local var0_5 = ""

		if not getProxy(NewEducateProxy):GetCurChar() then
			local var1_5, var2_5, var3_5 = getProxy(EducateProxy):GetStoryInfo()

			var0_5 = var3_5
		else
			local var4_5, var5_5, var6_5 = getProxy(NewEducateProxy):GetStoryInfo()

			var0_5 = var6_5
		end

		return (arg0_5:Convert2StoryBg(var0_5))
	else
		return var0_0.super.GetBgName(arg0_5)
	end
end

function var0_0.Convert2StoryBg(arg0_6, arg1_6)
	return ({
		educate_tb_1 = "bg_project_tb_room1",
		educate_tb_2 = "bg_project_tb_room2",
		educate_tb_3 = "bg_project_tb_room3"
	})[arg1_6] or arg1_6
end

function var0_0.GetPaintingRwIndex(arg0_7)
	if not arg0_7.glitchArt then
		return 0
	end

	if not arg0_7.expression then
		return 0
	end

	return arg0_7.paintRwIndex
end

function var0_0.IsMiniPortrait(arg0_8)
	return arg0_8.miniPortrait
end

function var0_0.ExistPortrait(arg0_9)
	return arg0_9.portrait ~= nil
end

function var0_0.GetPortrait(arg0_10)
	if type(arg0_10.portrait) == "number" then
		return pg.ship_skin_template[arg0_10.portrait].painting
	elseif type(arg0_10.portrait) == "string" then
		return arg0_10.portrait
	else
		return nil
	end
end

function var0_0.ShouldHideDialogue(arg0_11)
	return arg0_11.hideDialogFragment
end

function var0_0.ShouldGlitchArtForPortrait(arg0_12)
	return arg0_12.glitchArtForPortrait
end

function var0_0.GetMode(arg0_13)
	return Story.MODE_DIALOGUE
end

function var0_0.GetContentBGAlpha(arg0_14)
	return arg0_14.contentBGAlpha
end

function var0_0.GetSpineExPression(arg0_15)
	if arg0_15.expression then
		return arg0_15.expression
	end
end

function var0_0.GetExPression(arg0_16)
	if arg0_16.expression then
		return arg0_16.expression
	else
		local var0_16 = arg0_16:GetPainting()

		if var0_16 and ShipExpressionHelper.DefaultFaceless(var0_16) then
			return ShipExpressionHelper.GetDefaultFace(var0_16)
		end
	end
end

function var0_0.ShouldAddHeadMaskWhenFade(arg0_17)
	if arg0_17:ShouldAddGlitchArtEffect() then
		return false
	end

	if arg0_17:IsNoHeadPainting() then
		return false
	end

	if not arg0_17:GetExPression() then
		return false
	end

	return true
end

function var0_0.ShouldGrayingPainting(arg0_18, arg1_18)
	return arg1_18:GetPainting() ~= nil and not arg0_18:IsSameSide(arg1_18)
end

function var0_0.ShouldGrayingOutPainting(arg0_19, arg1_19)
	return arg0_19:GetPainting() ~= nil and not arg0_19:IsSameSide(arg1_19)
end

function var0_0.ShouldFadeInPainting(arg0_20)
	if not arg0_20:GetPainting() then
		return false
	end

	if arg0_20:IsLive2dPainting() or arg0_20:IsSpinePainting() then
		return false
	end

	local var0_20 = arg0_20:GetFadeInPaintingTime()

	if not var0_20 or var0_20 <= 0 then
		return false
	end

	return true
end

function var0_0.GetTypewriter(arg0_21)
	return arg0_21.typewriter
end

function var0_0.ShouldFaceBlack(arg0_22)
	return arg0_22.actorShadow
end

function var0_0.GetPaintingData(arg0_23)
	local var0_23 = arg0_23.painting or {}

	return {
		alpha = var0_23.alpha or 0.3,
		time = var0_23.time or 1
	}
end

function var0_0.GetFadeInPaintingTime(arg0_24)
	return arg0_24.fadeInPaintingTime
end

function var0_0.GetFadeOutPaintingTime(arg0_25)
	return arg0_25.fadeOutPaintingTime
end

function var0_0.GetPaintingDir(arg0_26)
	local var0_26 = arg0_26.paingtingScale or 1

	return (arg0_26.dir or 1) * var0_26
end

function var0_0.ShouldFlipPaintingY(arg0_27)
	return arg0_27.paingtingYFlip ~= nil
end

function var0_0.GetTag(arg0_28)
	if arg0_28.glitchArt == true then
		return 2
	else
		return 1
	end
end

function var0_0.GetPaintingAlpha(arg0_29)
	return arg0_29.actorAlpha
end

function var0_0.GetPaitingOffst(arg0_30)
	return arg0_30.actorPosition
end

function var0_0.GetSound(arg0_31)
	return arg0_31.sound
end

function var0_0.GetPaintingActions(arg0_32)
	return arg0_32.action
end

function var0_0.GetPaintingMoveToSide(arg0_33)
	return arg0_33.moveSideData
end

function var0_0.ShouldMoveToSide(arg0_34)
	return arg0_34.moveSideData ~= nil
end

function var0_0.GetPaintingAction(arg0_35, arg1_35)
	local var0_35 = {}
	local var1_35 = arg0_35:GetPaintingActions()

	for iter0_35, iter1_35 in ipairs(var1_35) do
		if iter1_35.type == arg1_35 then
			table.insert(var0_35, iter1_35)
		end
	end

	return var0_35
end

function var0_0.GetSide(arg0_36)
	return arg0_36.side
end

function var0_0.GetContent(arg0_37)
	if not arg0_37.say then
		return "..."
	end

	local var0_37 = arg0_37.say

	if arg0_37:ShouldReplacePlayer() then
		var0_37 = arg0_37:ReplacePlayerName(var0_37)
	end

	if arg0_37:ShouldReplaceTb() then
		var0_37 = arg0_37:ReplaceTbName(var0_37)
	end

	if arg0_37:ShouldReplaceDorm() then
		var0_37 = arg0_37:ReplaceDormName(var0_37)
	end

	if PLATFORM_CODE ~= PLATFORM_US then
		var0_37 = SwitchSpecialChar(HXSet.hxLan(var0_37), true)
	else
		var0_37 = HXSet.hxLan(var0_37)
	end

	return var0_37
end

function var0_0.GetNameWithColor(arg0_38)
	local var0_38 = arg0_38:GetName()

	if not var0_38 then
		return nil
	end

	local var1_38 = arg0_38:GetNameColor()

	return setColorStr(var0_38, var1_38)
end

function var0_0.GetNameColor(arg0_39)
	return arg0_39.nameColor or COLOR_WHITE
end

function var0_0.GetNameColorCode(arg0_40)
	local var0_40 = arg0_40:GetNameColor()

	return string.gsub(var0_40, "#", "")
end

function var0_0.GetCustomActorName(arg0_41)
	if type(arg0_41.actorName) == "number" and arg0_41.actorName == 0 and getProxy(PlayerProxy) then
		return getProxy(PlayerProxy):getRawData().name
	elseif type(arg0_41.actorName) == "number" then
		return ShipGroup.getDefaultShipNameByGroupID(arg0_41.actorName)
	elseif type(arg0_41.actorName) == "string" then
		return arg0_41.actorName
	else
		return ""
	end
end

function var0_0.GetPortraitName(arg0_42)
	if not arg0_42:ExistPortrait() then
		return ""
	end

	if type(arg0_42.portrait) ~= "number" then
		return ""
	end

	local var0_42 = var1_0[arg0_42.portrait]

	if not var0_42 then
		return ""
	end

	local var1_42 = ""
	local var2_42 = var0_42.ship_group
	local var3_42 = ShipGroup.getDefaultShipConfig(var2_42)

	if not var3_42 then
		var1_42 = var0_42.name
	else
		var1_42 = Ship.getShipName(var3_42.id)
	end

	return var1_42
end

function var0_0.GetName(arg0_43)
	local var0_43 = arg0_43.actorName and arg0_43:GetCustomActorName() or arg0_43:GetPaintingAndName() or ""

	if not var0_43 or var0_43 == "" then
		var0_43 = arg0_43:GetPortraitName()
	end

	if not var0_43 or var0_43 == "" or arg0_43.withoutActorName then
		return nil
	end

	if arg0_43:ShouldReplacePlayer() then
		var0_43 = arg0_43:ReplacePlayerName(var0_43)
	end

	if arg0_43:ShouldReplaceTb() then
		var0_43 = arg0_43:ReplaceTbName(var0_43)
	end

	return (HXSet.hxLan(var0_43))
end

function var0_0.GetPainting(arg0_44)
	local var0_44, var1_44 = arg0_44:GetPaintingAndName()

	return var1_44
end

function var0_0.ExistPainting(arg0_45)
	return arg0_45:GetPainting() ~= nil
end

function var0_0.ShouldShakeDailogue(arg0_46)
	return arg0_46.dialogShake ~= nil
end

function var0_0.GetShakeDailogueData(arg0_47)
	return arg0_47.dialogShake
end

function var0_0.IsSameSide(arg0_48, arg1_48)
	local var0_48 = arg0_48:GetPrevSide(arg1_48)
	local var1_48 = arg0_48:GetSide()

	return var0_48 ~= nil and var1_48 ~= nil and var0_48 == var1_48
end

function var0_0.GetPrevSide(arg0_49, arg1_49)
	local var0_49 = arg1_49:GetSide()

	if arg0_49.moveSideData then
		var0_49 = arg0_49.moveSideData.side
	end

	return var0_49
end

function var0_0.GetPaintingIcon(arg0_50)
	local var0_50

	if arg0_50.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var1_50 = getProxy(PlayerProxy):getRawData().character

		var0_50 = getProxy(BayProxy):getShipById(var1_50):getPrefab()
	else
		var0_50 = (arg0_50.actor ~= var0_0.ACTOR_TYPE_PLAYER or nil) and (arg0_50.actor ~= var0_0.ACTOR_TYPE_TB or nil) and (arg0_50.actor or nil) and (not arg0_50.hideRecordIco or nil) and var1_0[arg0_50.actor].prefab
	end

	if var0_50 == nil and arg0_50:ExistPortrait() and not arg0_50.hideRecordIco then
		var0_50 = arg0_50:GetPortrait()
	end

	return var0_50
end

function var0_0.GetPaintingAndName(arg0_51)
	local var0_51
	local var1_51

	if not UnGamePlayState and arg0_51.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var2_51 = getProxy(PlayerProxy):getRawData().character
		local var3_51 = getProxy(BayProxy):getShipById(var2_51)

		var0_51 = var3_51:getName()
		var1_51 = var3_51:getPainting()
	elseif not UnGamePlayState and arg0_51.actor == var0_0.ACTOR_TYPE_PLAYER then
		if getProxy(PlayerProxy) then
			var0_51 = getProxy(PlayerProxy):getRawData().name
		else
			var0_51 = ""
		end
	elseif not UnGamePlayState and arg0_51.actor == var0_0.ACTOR_TYPE_TB then
		if pg.NewStoryMgr.GetInstance():IsReView() then
			assert(arg0_51.defaultTb and arg0_51.defaultTb > 0, "<<< defaultTb is nil >>>")

			local var4_51 = pg.secretary_special_ship[arg0_51.defaultTb]

			var0_51 = var4_51.name or ""
			var1_51 = var4_51.prefab
		elseif arg0_51.specialTbId then
			local var5_51 = pg.secretary_special_ship[arg0_51.specialTbId]

			assert(var5_51)

			var0_51 = var5_51.name or ""
			var1_51 = var5_51.prefab
		elseif getProxy(NewEducateProxy) and getProxy(NewEducateProxy):GetCurChar() then
			var1_51, var0_51 = getProxy(NewEducateProxy):GetStoryInfo()
		elseif EducateProxy and getProxy(EducateProxy) then
			var1_51, var0_51 = getProxy(EducateProxy):GetStoryInfo()
		else
			var0_51 = ""
		end
	elseif not arg0_51.actor or var1_0[arg0_51.actor] == nil then
		var0_51, var1_51 = nil
	else
		local var6_51 = var1_0[arg0_51.actor]
		local var7_51 = var6_51.ship_group
		local var8_51 = ShipGroup.getDefaultShipConfig(var7_51)

		if not var8_51 then
			var0_51 = var6_51.name
		else
			var0_51 = Ship.getShipName(var8_51.id)
		end

		var1_51 = var6_51.painting
	end

	return HXSet.hxLan(var0_51), var1_51
end

function var0_0.GetShipSkinId(arg0_52)
	if arg0_52.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var0_52 = getProxy(PlayerProxy):getRawData()

		return getProxy(BayProxy):GetShipPhantom(var0_52:GetFlagShipPhantomMark()):getSkinId()
	elseif arg0_52.actor == var0_0.ACTOR_TYPE_PLAYER then
		return nil
	elseif not arg0_52.actor then
		return nil
	else
		return arg0_52.actor
	end
end

function var0_0.IsShowNPainting(arg0_53)
	return arg0_53.showNPainting
end

function var0_0.IsShowWJZPainting(arg0_54)
	return arg0_54.showWJZPainting
end

function var0_0.ShouldGrayPainting(arg0_55)
	return arg0_55.paingtingGray
end

function var0_0.ShouldAddGlitchArtEffect(arg0_56)
	return arg0_56.glitchArt
end

function var0_0.HideOtherPainting(arg0_57)
	return arg0_57.hideOtherPainting
end

function var0_0.GetSubPaintings(arg0_58)
	return _.map(arg0_58.subPaintings or {}, function(arg0_59)
		local var0_59 = pg.ship_skin_template[arg0_59.actor]

		assert(var0_59)

		return {
			actor = arg0_59.actor,
			name = var0_59.painting,
			expression = arg0_59.expression,
			pos = arg0_59.pos,
			dir = arg0_59.dir or 1,
			paintingNoise = arg0_59.paintingNoise or false,
			showNPainting = arg0_59.hidePaintObj or false
		}
	end)
end

function var0_0.NeedDispppearSubPainting(arg0_60)
	return #arg0_60.disappearSeq > 0
end

function var0_0.GetDisappearSeq(arg0_61)
	return arg0_61.disappearSeq
end

function var0_0.GetDisappearTime(arg0_62)
	return arg0_62.disappearTime[1], arg0_62.disappearTime[2]
end

function var0_0.IsNoHeadPainting(arg0_63)
	return arg0_63.nohead
end

function var0_0.GetFontSize(arg0_64)
	return arg0_64.fontSize
end

function var0_0.IsSpinePainting(arg0_65)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_65 = arg0_65:GetPainting()

	return tobool(var0_65 ~= nil and arg0_65.spine)
end

function var0_0.IsHideSpineBg(arg0_66)
	return arg0_66.spine == 1
end

function var0_0.GetSpineOrderIndex(arg0_67)
	if arg0_67:IsSpinePainting() then
		return arg0_67.spineOrderIndex
	else
		return nil
	end
end

function var0_0.IsLive2dPainting(arg0_68)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_68 = arg0_68:GetPainting()

	return tobool(var0_68 ~= nil and arg0_68.live2d)
end

function var0_0.GetLive2dPos(arg0_69)
	if arg0_69.live2dOffset then
		return Vector3(arg0_69.live2dOffset[1], arg0_69.live2dOffset[2], arg0_69.live2dOffset[3])
	end
end

function var0_0.GetVirtualShip(arg0_70)
	local var0_70 = arg0_70:GetShipSkinId()
	local var1_70 = pg.ship_skin_template[var0_70].ship_group

	return StoryShip.New({
		skin_id = var0_70
	})
end

function var0_0.GetLive2dAction(arg0_71)
	if type(arg0_71.live2d) == "string" then
		local var0_71 = pg.character_voice[arg0_71.live2d]

		if var0_71 then
			return var0_71.l2d_action
		end

		return arg0_71.live2d
	else
		return nil
	end
end

function var0_0.GetL2dIdleIndex(arg0_72)
	return arg0_72.live2dIdleIndex
end

function var0_0.GetSubActorName(arg0_73)
	if arg0_73.subActorName and arg0_73.subActorName ~= "" then
		local var0_73 = HXSet.hxLan(arg0_73.subActorName)

		return " " .. setColorStr(var0_73, arg0_73.subActorNameColor)
	else
		return ""
	end
end

function var0_0.IsSamePainting(arg0_74, arg1_74)
	local function var0_74()
		return arg1_74:ShouldAddGlitchArtEffect() or arg0_74:ShouldAddGlitchArtEffect()
	end

	return (function()
		return arg0_74:GetPainting() == arg1_74:GetPainting() and arg0_74:IsShowNPainting() == arg1_74:IsShowNPainting() and arg0_74:IsShowWJZPainting() == arg1_74:IsShowWJZPainting()
	end)() and arg0_74:IsLive2dPainting() == arg1_74:IsLive2dPainting() and arg0_74:IsSpinePainting() == arg1_74:IsSpinePainting() and not var0_74()
end

function var0_0.ExistCanMarkNode(arg0_77)
	return arg0_77.canMarkNode ~= nil and type(arg0_77.canMarkNode) == "table" and arg0_77.canMarkNode[1] and arg0_77.canMarkNode[1] ~= "" and arg0_77.canMarkNode[2] and type(arg0_77.canMarkNode[2]) == "table"
end

function var0_0.GetCanMarkNodeData(arg0_78)
	local var0_78 = {}

	for iter0_78, iter1_78 in ipairs(arg0_78.canMarkNode[2] or {}) do
		table.insert(var0_78, iter1_78 .. "")
	end

	return {
		name = arg0_78.canMarkNode[1],
		marks = var0_78
	}
end

function var0_0.OnClear(arg0_79)
	return
end

function var0_0.GetUsingPaintingNames(arg0_80)
	local var0_80 = {}
	local var1_80 = arg0_80:GetPainting()

	if var1_80 ~= nil then
		table.insert(var0_80, var1_80)
	end

	local var2_80 = arg0_80:GetSubPaintings()

	for iter0_80, iter1_80 in ipairs(var2_80) do
		local var3_80 = iter1_80.name

		table.insert(var0_80, var3_80)
	end

	return var0_80
end

return var0_0
