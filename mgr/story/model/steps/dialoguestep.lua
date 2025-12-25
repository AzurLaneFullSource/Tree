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

function var0_0.GetSpinePosition(arg0_3)
	return BuildVector3(arg0_3.spinePos)
end

function var0_0.GetL2dParams(arg0_4)
	if not arg0_4.live2dParams then
		return nil
	end

	return {
		name = arg0_4.live2dParams[1],
		value = arg0_4.live2dParams[2]
	}
end

function var0_0.SetDefaultSide(arg0_5)
	arg0_5.side = defaultValue(arg0_5.side, var0_0.SIDE_LEFT)
end

function var0_0.GetBgName(arg0_6)
	if arg0_6.dynamicBgType and arg0_6.dynamicBgType == var0_0.ACTOR_TYPE_TB and getProxy(EducateProxy) and getProxy(NewEducateProxy) and not pg.NewStoryMgr.GetInstance():IsReView() then
		local var0_6 = ""

		if not getProxy(NewEducateProxy):GetCurChar() then
			local var1_6, var2_6, var3_6 = getProxy(EducateProxy):GetStoryInfo()

			var0_6 = var3_6
		else
			local var4_6, var5_6, var6_6 = getProxy(NewEducateProxy):GetStoryInfo()

			var0_6 = var6_6
		end

		return (arg0_6:Convert2StoryBg(var0_6))
	else
		return var0_0.super.GetBgName(arg0_6)
	end
end

function var0_0.Convert2StoryBg(arg0_7, arg1_7)
	return ({
		educate_tb_1 = "bg_project_tb_room1",
		educate_tb_2 = "bg_project_tb_room2",
		educate_tb_3 = "bg_project_tb_room3"
	})[arg1_7] or arg1_7
end

function var0_0.GetPaintingRwIndex(arg0_8)
	if not arg0_8.glitchArt then
		return 0
	end

	if not arg0_8.expression then
		return 0
	end

	return arg0_8.paintRwIndex
end

function var0_0.IsMiniPortrait(arg0_9)
	return arg0_9.miniPortrait
end

function var0_0.ExistPortrait(arg0_10)
	return arg0_10.portrait ~= nil
end

function var0_0.GetPortrait(arg0_11)
	if type(arg0_11.portrait) == "number" then
		return pg.ship_skin_template[arg0_11.portrait].painting
	elseif type(arg0_11.portrait) == "string" then
		return arg0_11.portrait
	else
		return nil
	end
end

function var0_0.ShouldHideDialogue(arg0_12)
	return arg0_12.hideDialogFragment
end

function var0_0.ShouldGlitchArtForPortrait(arg0_13)
	return arg0_13.glitchArtForPortrait
end

function var0_0.GetMode(arg0_14)
	return Story.MODE_DIALOGUE
end

function var0_0.GetContentBGAlpha(arg0_15)
	return arg0_15.contentBGAlpha
end

function var0_0.GetSpineExPression(arg0_16)
	if arg0_16.expression then
		return arg0_16.expression
	end
end

function var0_0.GetExPression(arg0_17)
	if arg0_17.expression then
		return arg0_17.expression
	else
		local var0_17 = arg0_17:GetPainting()

		if var0_17 and ShipExpressionHelper.DefaultFaceless(var0_17) then
			return ShipExpressionHelper.GetDefaultFace(var0_17)
		end
	end
end

function var0_0.ShouldAddHeadMaskWhenFade(arg0_18)
	if arg0_18:ShouldAddGlitchArtEffect() then
		return false
	end

	if arg0_18:IsNoHeadPainting() then
		return false
	end

	if not arg0_18:GetExPression() then
		return false
	end

	return true
end

function var0_0.ShouldGrayingPainting(arg0_19, arg1_19)
	return arg1_19:GetPainting() ~= nil and not arg0_19:IsSameSide(arg1_19)
end

function var0_0.ShouldGrayingOutPainting(arg0_20, arg1_20)
	return arg0_20:GetPainting() ~= nil and not arg0_20:IsSameSide(arg1_20)
end

function var0_0.ShouldFadeInPainting(arg0_21)
	if not arg0_21:GetPainting() then
		return false
	end

	if arg0_21:IsLive2dPainting() or arg0_21:IsSpinePainting() then
		return false
	end

	local var0_21 = arg0_21:GetFadeInPaintingTime()

	if not var0_21 or var0_21 <= 0 then
		return false
	end

	return true
end

function var0_0.GetTypewriter(arg0_22)
	return arg0_22.typewriter
end

function var0_0.ShouldFaceBlack(arg0_23)
	return arg0_23.actorShadow
end

function var0_0.GetPaintingData(arg0_24)
	local var0_24 = arg0_24.painting or {}

	return {
		alpha = var0_24.alpha or 0.3,
		time = var0_24.time or 1
	}
end

function var0_0.GetFadeInPaintingTime(arg0_25)
	return arg0_25.fadeInPaintingTime
end

function var0_0.GetFadeOutPaintingTime(arg0_26)
	return arg0_26.fadeOutPaintingTime
end

function var0_0.GetPaintingDir(arg0_27)
	local var0_27 = arg0_27.paingtingScale or 1

	return (arg0_27.dir or 1) * var0_27
end

function var0_0.ShouldFlipPaintingY(arg0_28)
	return arg0_28.paingtingYFlip ~= nil
end

function var0_0.GetTag(arg0_29)
	if arg0_29.glitchArt == true then
		return 2
	else
		return 1
	end
end

function var0_0.GetPaintingAlpha(arg0_30)
	return arg0_30.actorAlpha
end

function var0_0.GetPaitingOffst(arg0_31)
	return arg0_31.actorPosition
end

function var0_0.GetSound(arg0_32)
	return arg0_32.sound
end

function var0_0.GetPaintingActions(arg0_33)
	return arg0_33.action
end

function var0_0.GetPaintingMoveToSide(arg0_34)
	return arg0_34.moveSideData
end

function var0_0.ShouldMoveToSide(arg0_35)
	return arg0_35.moveSideData ~= nil
end

function var0_0.GetPaintingAction(arg0_36, arg1_36)
	local var0_36 = {}
	local var1_36 = arg0_36:GetPaintingActions()

	for iter0_36, iter1_36 in ipairs(var1_36) do
		if iter1_36.type == arg1_36 then
			table.insert(var0_36, iter1_36)
		end
	end

	return var0_36
end

function var0_0.GetSide(arg0_37)
	return arg0_37.side
end

function var0_0.GetContent(arg0_38)
	if not arg0_38.say then
		return "..."
	end

	local var0_38 = arg0_38.say

	if arg0_38:ShouldReplacePlayer() then
		var0_38 = arg0_38:ReplacePlayerName(var0_38)
	end

	if arg0_38:ShouldReplaceTb() then
		var0_38 = arg0_38:ReplaceTbName(var0_38)
	end

	if arg0_38:ShouldReplaceDorm() then
		var0_38 = arg0_38:ReplaceDormName(var0_38)
	end

	if PLATFORM_CODE ~= PLATFORM_US then
		var0_38 = SwitchSpecialChar(HXSet.hxLan(var0_38), true)
	else
		var0_38 = HXSet.hxLan(var0_38)
	end

	return var0_38
end

function var0_0.GetNameWithColor(arg0_39)
	local var0_39 = arg0_39:GetName()

	if not var0_39 then
		return nil
	end

	local var1_39 = arg0_39:GetNameColor()

	return setColorStr(var0_39, var1_39)
end

function var0_0.GetNameColor(arg0_40)
	return arg0_40.nameColor or COLOR_WHITE
end

function var0_0.GetNameColorCode(arg0_41)
	local var0_41 = arg0_41:GetNameColor()

	return string.gsub(var0_41, "#", "")
end

function var0_0.GetCustomActorName(arg0_42)
	if type(arg0_42.actorName) == "number" and arg0_42.actorName == 0 and getProxy(PlayerProxy) then
		return getProxy(PlayerProxy):getRawData().name
	elseif type(arg0_42.actorName) == "number" then
		return ShipGroup.getDefaultShipNameByGroupID(arg0_42.actorName)
	elseif type(arg0_42.actorName) == "string" then
		return arg0_42.actorName
	else
		return ""
	end
end

function var0_0.GetPortraitName(arg0_43)
	if not arg0_43:ExistPortrait() then
		return ""
	end

	if type(arg0_43.portrait) ~= "number" then
		return ""
	end

	local var0_43 = var1_0[arg0_43.portrait]

	if not var0_43 then
		return ""
	end

	local var1_43 = ""
	local var2_43 = var0_43.ship_group
	local var3_43 = ShipGroup.getDefaultShipConfig(var2_43)

	if not var3_43 then
		var1_43 = var0_43.name
	else
		var1_43 = Ship.getShipName(var3_43.id)
	end

	return var1_43
end

function var0_0.GetName(arg0_44)
	local var0_44 = arg0_44.actorName and arg0_44:GetCustomActorName() or arg0_44:GetPaintingAndName() or ""

	if not var0_44 or var0_44 == "" then
		var0_44 = arg0_44:GetPortraitName()
	end

	if not var0_44 or var0_44 == "" or arg0_44.withoutActorName then
		return nil
	end

	if arg0_44:ShouldReplacePlayer() then
		var0_44 = arg0_44:ReplacePlayerName(var0_44)
	end

	if arg0_44:ShouldReplaceTb() then
		var0_44 = arg0_44:ReplaceTbName(var0_44)
	end

	return (HXSet.hxLan(var0_44))
end

function var0_0.GetPainting(arg0_45)
	local var0_45, var1_45 = arg0_45:GetPaintingAndName()

	return var1_45
end

function var0_0.ExistPainting(arg0_46)
	return arg0_46:GetPainting() ~= nil
end

function var0_0.ShouldShakeDailogue(arg0_47)
	return arg0_47.dialogShake ~= nil
end

function var0_0.GetShakeDailogueData(arg0_48)
	return arg0_48.dialogShake
end

function var0_0.IsSameSide(arg0_49, arg1_49)
	local var0_49 = arg0_49:GetPrevSide(arg1_49)
	local var1_49 = arg0_49:GetSide()

	return var0_49 ~= nil and var1_49 ~= nil and var0_49 == var1_49
end

function var0_0.GetPrevSide(arg0_50, arg1_50)
	local var0_50 = arg1_50:GetSide()

	if arg0_50.moveSideData then
		var0_50 = arg0_50.moveSideData.side
	end

	return var0_50
end

function var0_0.GetPaintingIcon(arg0_51)
	local var0_51

	if arg0_51.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var1_51 = getProxy(PlayerProxy):getRawData().character

		var0_51 = getProxy(BayProxy):getShipById(var1_51):getPrefab()
	else
		var0_51 = (arg0_51.actor ~= var0_0.ACTOR_TYPE_PLAYER or nil) and (arg0_51.actor ~= var0_0.ACTOR_TYPE_TB or nil) and (arg0_51.actor or nil) and (not arg0_51.hideRecordIco or nil) and var1_0[arg0_51.actor].prefab
	end

	if var0_51 == nil and arg0_51:ExistPortrait() and not arg0_51.hideRecordIco then
		var0_51 = arg0_51:GetPortrait()
	end

	return var0_51
end

function var0_0.GetPaintingAndName(arg0_52)
	local var0_52
	local var1_52

	if not UnGamePlayState and arg0_52.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var2_52 = getProxy(PlayerProxy):getRawData().character
		local var3_52 = getProxy(BayProxy):getShipById(var2_52)

		var0_52 = var3_52:getName()
		var1_52 = var3_52:getPainting()
	elseif not UnGamePlayState and arg0_52.actor == var0_0.ACTOR_TYPE_PLAYER then
		if getProxy(PlayerProxy) then
			var0_52 = getProxy(PlayerProxy):getRawData().name
		else
			var0_52 = ""
		end
	elseif not UnGamePlayState and arg0_52.actor == var0_0.ACTOR_TYPE_TB then
		if pg.NewStoryMgr.GetInstance():IsReView() then
			assert(arg0_52.defaultTb and arg0_52.defaultTb > 0, "<<< defaultTb is nil >>>")

			local var4_52 = pg.secretary_special_ship[arg0_52.defaultTb]

			var0_52 = var4_52.name or ""
			var1_52 = var4_52.prefab
		elseif arg0_52.specialTbId then
			local var5_52 = pg.secretary_special_ship[arg0_52.specialTbId]

			assert(var5_52)

			var0_52 = var5_52.name or ""
			var1_52 = var5_52.prefab
		elseif getProxy(NewEducateProxy) and getProxy(NewEducateProxy):GetCurChar() then
			var1_52, var0_52 = getProxy(NewEducateProxy):GetStoryInfo()
		elseif EducateProxy and getProxy(EducateProxy) then
			var1_52, var0_52 = getProxy(EducateProxy):GetStoryInfo()
		else
			var0_52 = ""
		end
	elseif not arg0_52.actor or var1_0[arg0_52.actor] == nil then
		var0_52, var1_52 = nil
	else
		local var6_52 = var1_0[arg0_52.actor]
		local var7_52 = var6_52.ship_group
		local var8_52 = ShipGroup.getDefaultShipConfig(var7_52)

		if not var8_52 then
			var0_52 = var6_52.name
		else
			var0_52 = Ship.getShipName(var8_52.id)
		end

		var1_52 = var6_52.painting
	end

	return HXSet.hxLan(var0_52), var1_52
end

function var0_0.GetShipSkinId(arg0_53)
	if arg0_53.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var0_53 = getProxy(PlayerProxy):getRawData()

		return getProxy(BayProxy):GetShipPhantom(var0_53:GetFlagShipPhantomMark()):getSkinId()
	elseif arg0_53.actor == var0_0.ACTOR_TYPE_PLAYER then
		return nil
	elseif not arg0_53.actor then
		return nil
	else
		return arg0_53.actor
	end
end

function var0_0.IsShowNPainting(arg0_54)
	return arg0_54.showNPainting
end

function var0_0.IsShowWJZPainting(arg0_55)
	return arg0_55.showWJZPainting
end

function var0_0.ShouldGrayPainting(arg0_56)
	return arg0_56.paingtingGray
end

function var0_0.ShouldAddGlitchArtEffect(arg0_57)
	return arg0_57.glitchArt
end

function var0_0.HideOtherPainting(arg0_58)
	return arg0_58.hideOtherPainting
end

function var0_0.GetSubPaintings(arg0_59)
	return _.map(arg0_59.subPaintings or {}, function(arg0_60)
		local var0_60 = pg.ship_skin_template[arg0_60.actor]

		assert(var0_60)

		return {
			actor = arg0_60.actor,
			name = var0_60.painting,
			expression = arg0_60.expression,
			pos = arg0_60.pos,
			dir = arg0_60.dir or 1,
			paintingNoise = arg0_60.paintingNoise or false,
			showNPainting = arg0_60.hidePaintObj or false
		}
	end)
end

function var0_0.NeedDispppearSubPainting(arg0_61)
	return #arg0_61.disappearSeq > 0
end

function var0_0.GetDisappearSeq(arg0_62)
	return arg0_62.disappearSeq
end

function var0_0.GetDisappearTime(arg0_63)
	return arg0_63.disappearTime[1], arg0_63.disappearTime[2]
end

function var0_0.IsNoHeadPainting(arg0_64)
	return arg0_64.nohead
end

function var0_0.GetFontSize(arg0_65)
	return arg0_65.fontSize
end

function var0_0.IsSpinePainting(arg0_66)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_66 = arg0_66:GetPainting()

	return tobool(var0_66 ~= nil and arg0_66.spine)
end

function var0_0.IsHideSpineBg(arg0_67)
	return arg0_67.spine == 1
end

function var0_0.GetSpineOrderIndex(arg0_68)
	if arg0_68:IsSpinePainting() then
		return arg0_68.spineOrderIndex
	else
		return nil
	end
end

function var0_0.IsLive2dPainting(arg0_69)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_69 = arg0_69:GetPainting()

	return tobool(var0_69 ~= nil and arg0_69.live2d)
end

function var0_0.GetLive2dPos(arg0_70)
	if arg0_70.live2dOffset then
		return Vector3(arg0_70.live2dOffset[1], arg0_70.live2dOffset[2], arg0_70.live2dOffset[3])
	end
end

function var0_0.GetVirtualShip(arg0_71)
	local var0_71 = arg0_71:GetShipSkinId()
	local var1_71 = pg.ship_skin_template[var0_71].ship_group

	return StoryShip.New({
		skin_id = var0_71
	})
end

function var0_0.GetLive2dAction(arg0_72)
	if type(arg0_72.live2d) == "string" then
		local var0_72 = pg.character_voice[arg0_72.live2d]

		if var0_72 then
			return var0_72.l2d_action
		end

		return arg0_72.live2d
	else
		return nil
	end
end

function var0_0.GetL2dIdleIndex(arg0_73)
	return arg0_73.live2dIdleIndex
end

function var0_0.GetSubActorName(arg0_74)
	if arg0_74.subActorName and arg0_74.subActorName ~= "" then
		local var0_74 = HXSet.hxLan(arg0_74.subActorName)

		return " " .. setColorStr(var0_74, arg0_74.subActorNameColor)
	else
		return ""
	end
end

function var0_0.IsSamePainting(arg0_75, arg1_75)
	local function var0_75()
		return arg1_75:ShouldAddGlitchArtEffect() or arg0_75:ShouldAddGlitchArtEffect()
	end

	return (function()
		return arg0_75:GetPainting() == arg1_75:GetPainting() and arg0_75:IsShowNPainting() == arg1_75:IsShowNPainting() and arg0_75:IsShowWJZPainting() == arg1_75:IsShowWJZPainting()
	end)() and arg0_75:IsLive2dPainting() == arg1_75:IsLive2dPainting() and arg0_75:IsSpinePainting() == arg1_75:IsSpinePainting() and not var0_75()
end

function var0_0.ExistCanMarkNode(arg0_78)
	return arg0_78.canMarkNode ~= nil and type(arg0_78.canMarkNode) == "table" and arg0_78.canMarkNode[1] and arg0_78.canMarkNode[1] ~= "" and arg0_78.canMarkNode[2] and type(arg0_78.canMarkNode[2]) == "table"
end

function var0_0.GetCanMarkNodeData(arg0_79)
	local var0_79 = {}

	for iter0_79, iter1_79 in ipairs(arg0_79.canMarkNode[2] or {}) do
		table.insert(var0_79, iter1_79 .. "")
	end

	return {
		name = arg0_79.canMarkNode[1],
		marks = var0_79
	}
end

function var0_0.OnClear(arg0_80)
	return
end

function var0_0.GetUsingPaintingNames(arg0_81)
	local var0_81 = {}
	local var1_81 = arg0_81:GetPainting()

	if var1_81 ~= nil then
		table.insert(var0_81, var1_81)
	end

	local var2_81 = arg0_81:GetSubPaintings()

	for iter0_81, iter1_81 in ipairs(var2_81) do
		local var3_81 = iter1_81.name

		table.insert(var0_81, var3_81)
	end

	return var0_81
end

return var0_0
