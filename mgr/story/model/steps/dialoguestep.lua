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
	arg0_2.sayColor = arg1_2.sayColor or COLOR_WHITE
	arg0_2.dynamicBgType = arg1_2.dynamicBgType
	arg0_2.fontSize = arg1_2.fontsize
	arg0_2.side = arg1_2.side
	arg0_2.dir = arg1_2.dir

	if arg0_2.dir == 0 then
		arg0_2.dir = 1
	end

	arg0_2.nextIcon = arg1_2.NextIcon or 0
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
	arg0_2.spinePos = arg1_2.spinePos or {
		0,
		0,
		0
	}
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

function var0_0.GetNextIcon(arg0_3)
	return arg0_3.nextIcon
end

function var0_0.GetSpinePosition(arg0_4)
	return BuildVector3(arg0_4.spinePos)
end

function var0_0.GetL2dParams(arg0_5)
	if not arg0_5.live2dParams then
		return nil
	end

	return {
		name = arg0_5.live2dParams[1],
		value = arg0_5.live2dParams[2]
	}
end

function var0_0.SetDefaultSide(arg0_6)
	arg0_6.side = defaultValue(arg0_6.side, var0_0.SIDE_LEFT)
end

function var0_0.GetBgName(arg0_7)
	if arg0_7.dynamicBgType and arg0_7.dynamicBgType == var0_0.ACTOR_TYPE_TB and getProxy(EducateProxy) and getProxy(NewEducateProxy) and not pg.NewStoryMgr.GetInstance():IsReView() then
		local var0_7 = ""

		if not getProxy(NewEducateProxy):GetCurChar() then
			local var1_7, var2_7, var3_7 = getProxy(EducateProxy):GetStoryInfo()

			var0_7 = var3_7
		else
			local var4_7, var5_7, var6_7 = getProxy(NewEducateProxy):GetStoryInfo()

			var0_7 = var6_7
		end

		return (arg0_7:Convert2StoryBg(var0_7))
	else
		return var0_0.super.GetBgName(arg0_7)
	end
end

function var0_0.Convert2StoryBg(arg0_8, arg1_8)
	return ({
		educate_tb_1 = "bg_project_tb_room1",
		educate_tb_2 = "bg_project_tb_room2",
		educate_tb_3 = "bg_project_tb_room3"
	})[arg1_8] or arg1_8
end

function var0_0.GetPaintingRwIndex(arg0_9)
	if not arg0_9.glitchArt then
		return 0
	end

	if not arg0_9.expression then
		return 0
	end

	return arg0_9.paintRwIndex
end

function var0_0.IsMiniPortrait(arg0_10)
	return arg0_10.miniPortrait
end

function var0_0.ExistPortrait(arg0_11)
	return arg0_11.portrait ~= nil
end

function var0_0.GetPortrait(arg0_12)
	if type(arg0_12.portrait) == "number" then
		return pg.ship_skin_template[arg0_12.portrait].painting
	elseif type(arg0_12.portrait) == "string" then
		return arg0_12.portrait
	else
		return nil
	end
end

function var0_0.ShouldHideDialogue(arg0_13)
	return arg0_13.hideDialogFragment
end

function var0_0.ShouldGlitchArtForPortrait(arg0_14)
	return arg0_14.glitchArtForPortrait
end

function var0_0.GetMode(arg0_15)
	return Story.MODE_DIALOGUE
end

function var0_0.GetContentBGAlpha(arg0_16)
	return arg0_16.contentBGAlpha
end

function var0_0.GetSpineExPression(arg0_17)
	if arg0_17.expression then
		return arg0_17.expression
	end
end

function var0_0.GetExPression(arg0_18)
	if arg0_18.expression then
		return arg0_18.expression
	else
		local var0_18 = arg0_18:GetPainting()

		if var0_18 and ShipExpressionHelper.DefaultFaceless(var0_18) then
			return ShipExpressionHelper.GetDefaultFace(var0_18)
		end
	end
end

function var0_0.ShouldAddHeadMaskWhenFade(arg0_19)
	if arg0_19:ShouldAddGlitchArtEffect() then
		return false
	end

	if arg0_19:IsNoHeadPainting() then
		return false
	end

	if not arg0_19:GetExPression() then
		return false
	end

	return true
end

function var0_0.ShouldGrayingPainting(arg0_20, arg1_20)
	return arg1_20:GetPainting() ~= nil and not arg0_20:IsSameSide(arg1_20)
end

function var0_0.ShouldGrayingOutPainting(arg0_21, arg1_21)
	return arg0_21:GetPainting() ~= nil and not arg0_21:IsSameSide(arg1_21)
end

function var0_0.ShouldFadeInPainting(arg0_22)
	if not arg0_22:GetPainting() then
		return false
	end

	if arg0_22:IsLive2dPainting() or arg0_22:IsSpinePainting() then
		return false
	end

	local var0_22 = arg0_22:GetFadeInPaintingTime()

	if not var0_22 or var0_22 <= 0 then
		return false
	end

	return true
end

function var0_0.GetTypewriter(arg0_23)
	return arg0_23.typewriter
end

function var0_0.ShouldFaceBlack(arg0_24)
	return arg0_24.actorShadow
end

function var0_0.GetPaintingData(arg0_25)
	local var0_25 = arg0_25.painting or {}

	return {
		alpha = var0_25.alpha or 0.3,
		time = var0_25.time or 1
	}
end

function var0_0.GetFadeInPaintingTime(arg0_26)
	return arg0_26.fadeInPaintingTime
end

function var0_0.GetFadeOutPaintingTime(arg0_27)
	return arg0_27.fadeOutPaintingTime
end

function var0_0.GetPaintingDir(arg0_28)
	local var0_28 = arg0_28.paingtingScale or 1

	return (arg0_28.dir or 1) * var0_28
end

function var0_0.ShouldFlipPaintingY(arg0_29)
	return arg0_29.paingtingYFlip ~= nil
end

function var0_0.GetTag(arg0_30)
	if arg0_30.glitchArt == true then
		return 2
	else
		return 1
	end
end

function var0_0.GetPaintingAlpha(arg0_31)
	return arg0_31.actorAlpha
end

function var0_0.GetPaitingOffst(arg0_32)
	return arg0_32.actorPosition
end

function var0_0.GetSound(arg0_33)
	return arg0_33.sound
end

function var0_0.GetPaintingActions(arg0_34)
	return arg0_34.action
end

function var0_0.GetPaintingMoveToSide(arg0_35)
	return arg0_35.moveSideData
end

function var0_0.ShouldMoveToSide(arg0_36)
	return arg0_36.moveSideData ~= nil
end

function var0_0.GetPaintingAction(arg0_37, arg1_37)
	local var0_37 = {}
	local var1_37 = arg0_37:GetPaintingActions()

	for iter0_37, iter1_37 in ipairs(var1_37) do
		if iter1_37.type == arg1_37 then
			table.insert(var0_37, iter1_37)
		end
	end

	return var0_37
end

function var0_0.GetSide(arg0_38)
	return arg0_38.side
end

function var0_0.GetContent(arg0_39)
	if not arg0_39.say then
		return "..."
	end

	local var0_39 = arg0_39.say

	if arg0_39:ShouldReplacePlayer() then
		var0_39 = arg0_39:ReplacePlayerName(var0_39)
	end

	if arg0_39:ShouldReplaceTb() then
		var0_39 = arg0_39:ReplaceTbName(var0_39)
	end

	if arg0_39:ShouldReplaceDorm() then
		var0_39 = arg0_39:ReplaceDormName(var0_39)
	end

	if arg0_39:ShouldReplaceCar2026() then
		var0_39 = arg0_39:ReplaceCar2026Name(var0_39)
	end

	if PLATFORM_CODE ~= PLATFORM_US then
		var0_39 = SwitchSpecialChar(HXSet.hxLan(var0_39), true)
	else
		var0_39 = HXSet.hxLan(var0_39)
	end

	return var0_39
end

function var0_0.GetContentColor(arg0_40)
	return arg0_40.sayColor or COLOR_WHITE
end

function var0_0.GetNameWithColor(arg0_41)
	local var0_41 = arg0_41:GetName()

	if not var0_41 then
		return nil
	end

	local var1_41 = arg0_41:GetNameColor()

	return setColorStr(var0_41, var1_41)
end

function var0_0.GetNameColor(arg0_42)
	return arg0_42.nameColor or COLOR_WHITE
end

function var0_0.GetNameColorCode(arg0_43)
	local var0_43 = arg0_43:GetNameColor()

	return string.gsub(var0_43, "#", "")
end

function var0_0.GetCustomActorName(arg0_44)
	if type(arg0_44.actorName) == "number" and arg0_44.actorName == 0 and getProxy(PlayerProxy) then
		return getProxy(PlayerProxy):getRawData().name
	elseif type(arg0_44.actorName) == "number" then
		return ShipGroup.getDefaultShipNameByGroupID(arg0_44.actorName)
	elseif type(arg0_44.actorName) == "string" then
		return arg0_44.actorName
	else
		return ""
	end
end

function var0_0.GetPortraitName(arg0_45)
	if not arg0_45:ExistPortrait() then
		return ""
	end

	if type(arg0_45.portrait) ~= "number" then
		return ""
	end

	local var0_45 = var1_0[arg0_45.portrait]

	if not var0_45 then
		return ""
	end

	local var1_45 = ""
	local var2_45 = var0_45.ship_group
	local var3_45 = ShipGroup.getDefaultShipConfig(var2_45)

	if not var3_45 then
		var1_45 = var0_45.name
	else
		var1_45 = Ship.getShipName(var3_45.id)
	end

	return var1_45
end

function var0_0.GetName(arg0_46)
	local var0_46 = arg0_46.actorName and arg0_46:GetCustomActorName() or arg0_46:GetPaintingAndName() or ""

	if not var0_46 or var0_46 == "" then
		var0_46 = arg0_46:GetPortraitName()
	end

	if not var0_46 or var0_46 == "" or arg0_46.withoutActorName then
		return nil
	end

	if arg0_46:ShouldReplacePlayer() then
		var0_46 = arg0_46:ReplacePlayerName(var0_46)
	end

	if arg0_46:ShouldReplaceTb() then
		var0_46 = arg0_46:ReplaceTbName(var0_46)
	end

	if arg0_46:ShouldReplaceCar2026() then
		var0_46 = arg0_46:ReplaceCar2026Name(var0_46)
	end

	return (HXSet.hxLan(var0_46))
end

function var0_0.GetPainting(arg0_47)
	local var0_47, var1_47 = arg0_47:GetPaintingAndName()

	return var1_47
end

function var0_0.ExistPainting(arg0_48)
	return arg0_48:GetPainting() ~= nil
end

function var0_0.ShouldShakeDailogue(arg0_49)
	return arg0_49.dialogShake ~= nil
end

function var0_0.GetShakeDailogueData(arg0_50)
	return arg0_50.dialogShake
end

function var0_0.IsSameSide(arg0_51, arg1_51)
	local var0_51 = arg0_51:GetPrevSide(arg1_51)
	local var1_51 = arg0_51:GetSide()

	return var0_51 ~= nil and var1_51 ~= nil and var0_51 == var1_51
end

function var0_0.GetPrevSide(arg0_52, arg1_52)
	local var0_52 = arg1_52:GetSide()

	if arg0_52.moveSideData then
		var0_52 = arg0_52.moveSideData.side
	end

	return var0_52
end

function var0_0.GetPaintingIcon(arg0_53)
	local var0_53

	if arg0_53.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var1_53 = getProxy(PlayerProxy):getRawData().character

		var0_53 = getProxy(BayProxy):getShipById(var1_53):getPrefab()
	else
		var0_53 = (arg0_53.actor ~= var0_0.ACTOR_TYPE_PLAYER or nil) and (arg0_53.actor ~= var0_0.ACTOR_TYPE_TB or nil) and (arg0_53.actor or nil) and (not arg0_53.hideRecordIco or nil) and var1_0[arg0_53.actor].prefab
	end

	if var0_53 == nil and arg0_53:ExistPortrait() and not arg0_53.hideRecordIco then
		var0_53 = arg0_53:GetPortrait()
	end

	return var0_53
end

function var0_0.GetPaintingAndName(arg0_54)
	local var0_54
	local var1_54

	if not UnGamePlayState and arg0_54.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var2_54 = getProxy(PlayerProxy):getRawData().character
		local var3_54 = getProxy(BayProxy):getShipById(var2_54)

		var0_54 = var3_54:getName()
		var1_54 = var3_54:getPainting()
	elseif not UnGamePlayState and arg0_54.actor == var0_0.ACTOR_TYPE_PLAYER then
		if getProxy(PlayerProxy) then
			var0_54 = getProxy(PlayerProxy):getRawData().name
		else
			var0_54 = ""
		end
	elseif not UnGamePlayState and arg0_54.actor == var0_0.ACTOR_TYPE_TB then
		if pg.NewStoryMgr.GetInstance():IsReView() then
			assert(arg0_54.defaultTb and arg0_54.defaultTb > 0, "<<< defaultTb is nil >>>")

			local var4_54 = pg.secretary_special_ship[arg0_54.defaultTb]

			var0_54 = var4_54.name or ""
			var1_54 = var4_54.prefab
		elseif arg0_54.specialTbId then
			local var5_54 = pg.secretary_special_ship[arg0_54.specialTbId]

			assert(var5_54)

			var0_54 = var5_54.name or ""
			var1_54 = var5_54.prefab
		elseif getProxy(NewEducateProxy) and getProxy(NewEducateProxy):GetCurChar() then
			var1_54, var0_54 = getProxy(NewEducateProxy):GetStoryInfo()
		elseif EducateProxy and getProxy(EducateProxy) then
			var1_54, var0_54 = getProxy(EducateProxy):GetStoryInfo()
		else
			var0_54 = ""
		end
	elseif not arg0_54.actor or var1_0[arg0_54.actor] == nil then
		var0_54, var1_54 = nil
	else
		local var6_54 = var1_0[arg0_54.actor]
		local var7_54 = var6_54.ship_group
		local var8_54 = ShipGroup.getDefaultShipConfig(var7_54)

		if not var8_54 then
			var0_54 = var6_54.name
		else
			var0_54 = Ship.getShipName(var8_54.id)
		end

		var1_54 = var6_54.painting
	end

	return HXSet.hxLan(var0_54), var1_54
end

function var0_0.GetShipSkinId(arg0_55)
	if arg0_55.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var0_55 = getProxy(PlayerProxy):getRawData()

		return getProxy(BayProxy):GetShipPhantom(var0_55:GetFlagShipPhantomMark()):getSkinId()
	elseif arg0_55.actor == var0_0.ACTOR_TYPE_PLAYER then
		return nil
	elseif not arg0_55.actor then
		return nil
	else
		return arg0_55.actor
	end
end

function var0_0.IsShowNPainting(arg0_56)
	return arg0_56.showNPainting
end

function var0_0.IsShowWJZPainting(arg0_57)
	return arg0_57.showWJZPainting
end

function var0_0.ShouldGrayPainting(arg0_58)
	return arg0_58.paingtingGray
end

function var0_0.ShouldAddGlitchArtEffect(arg0_59)
	return arg0_59.glitchArt
end

function var0_0.HideOtherPainting(arg0_60)
	return arg0_60.hideOtherPainting
end

function var0_0.GetSubPaintings(arg0_61)
	return _.map(arg0_61.subPaintings or {}, function(arg0_62)
		local var0_62 = pg.ship_skin_template[arg0_62.actor]

		assert(var0_62)

		return {
			actor = arg0_62.actor,
			name = var0_62.painting,
			expression = arg0_62.expression,
			pos = arg0_62.pos,
			dir = arg0_62.dir or 1,
			paintingNoise = arg0_62.paintingNoise or false,
			showNPainting = arg0_62.hidePaintObj or false
		}
	end)
end

function var0_0.NeedDispppearSubPainting(arg0_63)
	return #arg0_63.disappearSeq > 0
end

function var0_0.GetDisappearSeq(arg0_64)
	return arg0_64.disappearSeq
end

function var0_0.GetDisappearTime(arg0_65)
	return arg0_65.disappearTime[1], arg0_65.disappearTime[2]
end

function var0_0.IsNoHeadPainting(arg0_66)
	return arg0_66.nohead
end

function var0_0.GetFontSize(arg0_67)
	return arg0_67.fontSize
end

function var0_0.IsSpinePainting(arg0_68)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_68 = arg0_68:GetPainting()

	return tobool(var0_68 ~= nil and arg0_68.spine)
end

function var0_0.IsHideSpineBg(arg0_69)
	return arg0_69.spine == 1
end

function var0_0.GetSpineOrderIndex(arg0_70)
	if arg0_70:IsSpinePainting() then
		return arg0_70.spineOrderIndex
	else
		return nil
	end
end

function var0_0.IsLive2dPainting(arg0_71)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_71 = arg0_71:GetPainting()

	return tobool(var0_71 ~= nil and arg0_71.live2d)
end

function var0_0.GetLive2dPos(arg0_72)
	if arg0_72.live2dOffset then
		return Vector3(arg0_72.live2dOffset[1], arg0_72.live2dOffset[2], arg0_72.live2dOffset[3])
	end
end

function var0_0.GetVirtualShip(arg0_73)
	local var0_73 = arg0_73:GetShipSkinId()
	local var1_73 = pg.ship_skin_template[var0_73].ship_group

	return StoryShip.New({
		skin_id = var0_73
	})
end

function var0_0.GetLive2dAction(arg0_74)
	if type(arg0_74.live2d) == "string" then
		local var0_74 = pg.character_voice[arg0_74.live2d]

		if var0_74 then
			return var0_74.l2d_action
		end

		return arg0_74.live2d
	else
		return nil
	end
end

function var0_0.GetL2dIdleIndex(arg0_75)
	return arg0_75.live2dIdleIndex
end

function var0_0.GetSubActorName(arg0_76)
	if arg0_76.subActorName and arg0_76.subActorName ~= "" then
		local var0_76 = HXSet.hxLan(arg0_76.subActorName)

		return " " .. setColorStr(var0_76, arg0_76.subActorNameColor)
	else
		return ""
	end
end

function var0_0.IsSamePainting(arg0_77, arg1_77)
	local function var0_77()
		return arg1_77:ShouldAddGlitchArtEffect() or arg0_77:ShouldAddGlitchArtEffect()
	end

	return (function()
		return arg0_77:GetPainting() == arg1_77:GetPainting() and arg0_77:IsShowNPainting() == arg1_77:IsShowNPainting() and arg0_77:IsShowWJZPainting() == arg1_77:IsShowWJZPainting()
	end)() and arg0_77:IsLive2dPainting() == arg1_77:IsLive2dPainting() and arg0_77:IsSpinePainting() == arg1_77:IsSpinePainting() and not var0_77()
end

function var0_0.ExistCanMarkNode(arg0_80)
	return arg0_80.canMarkNode ~= nil and type(arg0_80.canMarkNode) == "table" and arg0_80.canMarkNode[1] and arg0_80.canMarkNode[1] ~= "" and arg0_80.canMarkNode[2] and type(arg0_80.canMarkNode[2]) == "table"
end

function var0_0.GetCanMarkNodeData(arg0_81)
	local var0_81 = {}

	for iter0_81, iter1_81 in ipairs(arg0_81.canMarkNode[2] or {}) do
		table.insert(var0_81, iter1_81 .. "")
	end

	return {
		name = arg0_81.canMarkNode[1],
		marks = var0_81
	}
end

function var0_0.OnClear(arg0_82)
	return
end

function var0_0.GetUsingPaintingNames(arg0_83)
	local var0_83 = {}
	local var1_83 = arg0_83:GetPainting()

	if var1_83 ~= nil then
		table.insert(var0_83, var1_83)
	end

	local var2_83 = arg0_83:GetSubPaintings()

	for iter0_83, iter1_83 in ipairs(var2_83) do
		local var3_83 = iter1_83.name

		table.insert(var0_83, var3_83)
	end

	return var0_83
end

return var0_0
