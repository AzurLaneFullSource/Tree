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

function var0_0.SetDefaultSide(arg0_3)
	arg0_3.side = defaultValue(arg0_3.side, var0_0.SIDE_LEFT)
end

function var0_0.GetBgName(arg0_4)
	if arg0_4.dynamicBgType and arg0_4.dynamicBgType == var0_0.ACTOR_TYPE_TB and getProxy(EducateProxy) and getProxy(NewEducateProxy) and not pg.NewStoryMgr.GetInstance():IsReView() then
		local var0_4 = ""

		if not getProxy(NewEducateProxy):GetCurChar() then
			local var1_4, var2_4, var3_4 = getProxy(EducateProxy):GetStoryInfo()

			var0_4 = var3_4
		else
			local var4_4, var5_4, var6_4 = getProxy(NewEducateProxy):GetStoryInfo()

			var0_4 = var6_4
		end

		return (arg0_4:Convert2StoryBg(var0_4))
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

function var0_0.IsMiniPortrait(arg0_7)
	return arg0_7.miniPortrait
end

function var0_0.ExistPortrait(arg0_8)
	return arg0_8.portrait ~= nil
end

function var0_0.GetPortrait(arg0_9)
	if type(arg0_9.portrait) == "number" then
		return pg.ship_skin_template[arg0_9.portrait].painting
	elseif type(arg0_9.portrait) == "string" then
		return arg0_9.portrait
	else
		return nil
	end
end

function var0_0.ShouldHideDialogue(arg0_10)
	return arg0_10.hideDialogFragment
end

function var0_0.ShouldGlitchArtForPortrait(arg0_11)
	return arg0_11.glitchArtForPortrait
end

function var0_0.GetMode(arg0_12)
	return Story.MODE_DIALOGUE
end

function var0_0.GetContentBGAlpha(arg0_13)
	return arg0_13.contentBGAlpha
end

function var0_0.GetSpineExPression(arg0_14)
	if arg0_14.expression then
		return arg0_14.expression
	end
end

function var0_0.GetExPression(arg0_15)
	if arg0_15.expression then
		return arg0_15.expression
	else
		local var0_15 = arg0_15:GetPainting()

		if var0_15 and ShipExpressionHelper.DefaultFaceless(var0_15) then
			return ShipExpressionHelper.GetDefaultFace(var0_15)
		end
	end
end

function var0_0.ShouldAddHeadMaskWhenFade(arg0_16)
	if arg0_16:ShouldAddGlitchArtEffect() then
		return false
	end

	if arg0_16:IsNoHeadPainting() then
		return false
	end

	if not arg0_16:GetExPression() then
		return false
	end

	return true
end

function var0_0.ShouldGrayingPainting(arg0_17, arg1_17)
	return arg1_17:GetPainting() ~= nil and not arg0_17:IsSameSide(arg1_17)
end

function var0_0.ShouldGrayingOutPainting(arg0_18, arg1_18)
	return arg0_18:GetPainting() ~= nil and not arg0_18:IsSameSide(arg1_18)
end

function var0_0.ShouldFadeInPainting(arg0_19)
	if not arg0_19:GetPainting() then
		return false
	end

	if arg0_19:IsLive2dPainting() or arg0_19:IsSpinePainting() then
		return false
	end

	local var0_19 = arg0_19:GetFadeInPaintingTime()

	if not var0_19 or var0_19 <= 0 then
		return false
	end

	return true
end

function var0_0.GetTypewriter(arg0_20)
	return arg0_20.typewriter
end

function var0_0.ShouldFaceBlack(arg0_21)
	return arg0_21.actorShadow
end

function var0_0.GetPaintingData(arg0_22)
	local var0_22 = arg0_22.painting or {}

	return {
		alpha = var0_22.alpha or 0.3,
		time = var0_22.time or 1
	}
end

function var0_0.GetFadeInPaintingTime(arg0_23)
	return arg0_23.fadeInPaintingTime
end

function var0_0.GetFadeOutPaintingTime(arg0_24)
	return arg0_24.fadeOutPaintingTime
end

function var0_0.GetPaintingDir(arg0_25)
	local var0_25 = arg0_25.paingtingScale or 1

	return (arg0_25.dir or 1) * var0_25
end

function var0_0.ShouldFlipPaintingY(arg0_26)
	return arg0_26.paingtingYFlip ~= nil
end

function var0_0.GetTag(arg0_27)
	if arg0_27.glitchArt == true then
		return 2
	else
		return 1
	end
end

function var0_0.GetPaintingAlpha(arg0_28)
	return arg0_28.actorAlpha
end

function var0_0.GetPaitingOffst(arg0_29)
	return arg0_29.actorPosition
end

function var0_0.GetSound(arg0_30)
	return arg0_30.sound
end

function var0_0.GetPaintingActions(arg0_31)
	return arg0_31.action
end

function var0_0.GetPaintingMoveToSide(arg0_32)
	return arg0_32.moveSideData
end

function var0_0.ShouldMoveToSide(arg0_33)
	return arg0_33.moveSideData ~= nil
end

function var0_0.GetPaintingAction(arg0_34, arg1_34)
	local var0_34 = {}
	local var1_34 = arg0_34:GetPaintingActions()

	for iter0_34, iter1_34 in ipairs(var1_34) do
		if iter1_34.type == arg1_34 then
			table.insert(var0_34, iter1_34)
		end
	end

	return var0_34
end

function var0_0.GetSide(arg0_35)
	return arg0_35.side
end

function var0_0.GetContent(arg0_36)
	if not arg0_36.say then
		return "..."
	end

	local var0_36 = arg0_36.say

	if arg0_36:ShouldReplacePlayer() then
		var0_36 = arg0_36:ReplacePlayerName(var0_36)
	end

	if arg0_36:ShouldReplaceTb() then
		var0_36 = arg0_36:ReplaceTbName(var0_36)
	end

	if arg0_36:ShouldReplaceDorm() then
		var0_36 = arg0_36:ReplaceDormName(var0_36)
	end

	if PLATFORM_CODE ~= PLATFORM_US then
		var0_36 = SwitchSpecialChar(HXSet.hxLan(var0_36), true)
	else
		var0_36 = HXSet.hxLan(var0_36)
	end

	return var0_36
end

function var0_0.GetNameWithColor(arg0_37)
	local var0_37 = arg0_37:GetName()

	if not var0_37 then
		return nil
	end

	local var1_37 = arg0_37:GetNameColor()

	return setColorStr(var0_37, var1_37)
end

function var0_0.GetNameColor(arg0_38)
	return arg0_38.nameColor or COLOR_WHITE
end

function var0_0.GetNameColorCode(arg0_39)
	local var0_39 = arg0_39:GetNameColor()

	return string.gsub(var0_39, "#", "")
end

function var0_0.GetCustomActorName(arg0_40)
	if type(arg0_40.actorName) == "number" and arg0_40.actorName == 0 and getProxy(PlayerProxy) then
		return getProxy(PlayerProxy):getRawData().name
	elseif type(arg0_40.actorName) == "number" then
		return ShipGroup.getDefaultShipNameByGroupID(arg0_40.actorName)
	elseif type(arg0_40.actorName) == "string" then
		return arg0_40.actorName
	else
		return ""
	end
end

function var0_0.GetPortraitName(arg0_41)
	if not arg0_41:ExistPortrait() then
		return ""
	end

	if type(arg0_41.portrait) ~= "number" then
		return ""
	end

	local var0_41 = var1_0[arg0_41.portrait]

	if not var0_41 then
		return ""
	end

	local var1_41 = ""
	local var2_41 = var0_41.ship_group
	local var3_41 = ShipGroup.getDefaultShipConfig(var2_41)

	if not var3_41 then
		var1_41 = var0_41.name
	else
		var1_41 = Ship.getShipName(var3_41.id)
	end

	return var1_41
end

function var0_0.GetName(arg0_42)
	local var0_42 = arg0_42.actorName and arg0_42:GetCustomActorName() or arg0_42:GetPaintingAndName() or ""

	if not var0_42 or var0_42 == "" then
		var0_42 = arg0_42:GetPortraitName()
	end

	if not var0_42 or var0_42 == "" or arg0_42.withoutActorName then
		return nil
	end

	if arg0_42:ShouldReplacePlayer() then
		var0_42 = arg0_42:ReplacePlayerName(var0_42)
	end

	if arg0_42:ShouldReplaceTb() then
		var0_42 = arg0_42:ReplaceTbName(var0_42)
	end

	return (HXSet.hxLan(var0_42))
end

function var0_0.GetPainting(arg0_43)
	local var0_43, var1_43 = arg0_43:GetPaintingAndName()

	return var1_43
end

function var0_0.ExistPainting(arg0_44)
	return arg0_44:GetPainting() ~= nil
end

function var0_0.ShouldShakeDailogue(arg0_45)
	return arg0_45.dialogShake ~= nil
end

function var0_0.GetShakeDailogueData(arg0_46)
	return arg0_46.dialogShake
end

function var0_0.IsSameSide(arg0_47, arg1_47)
	local var0_47 = arg0_47:GetPrevSide(arg1_47)
	local var1_47 = arg0_47:GetSide()

	return var0_47 ~= nil and var1_47 ~= nil and var0_47 == var1_47
end

function var0_0.GetPrevSide(arg0_48, arg1_48)
	local var0_48 = arg1_48:GetSide()

	if arg0_48.moveSideData then
		var0_48 = arg0_48.moveSideData.side
	end

	return var0_48
end

function var0_0.GetPaintingIcon(arg0_49)
	local var0_49

	if arg0_49.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var1_49 = getProxy(PlayerProxy):getRawData().character

		var0_49 = getProxy(BayProxy):getShipById(var1_49):getPrefab()
	else
		var0_49 = (arg0_49.actor ~= var0_0.ACTOR_TYPE_PLAYER or nil) and (arg0_49.actor ~= var0_0.ACTOR_TYPE_TB or nil) and (arg0_49.actor or nil) and (not arg0_49.hideRecordIco or nil) and var1_0[arg0_49.actor].prefab
	end

	if var0_49 == nil and arg0_49:ExistPortrait() then
		var0_49 = arg0_49:GetPortrait()
	end

	return var0_49
end

function var0_0.GetPaintingAndName(arg0_50)
	local var0_50
	local var1_50

	if not UnGamePlayState and arg0_50.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var2_50 = getProxy(PlayerProxy):getRawData().character
		local var3_50 = getProxy(BayProxy):getShipById(var2_50)

		var0_50 = var3_50:getName()
		var1_50 = var3_50:getPainting()
	elseif not UnGamePlayState and arg0_50.actor == var0_0.ACTOR_TYPE_PLAYER then
		if getProxy(PlayerProxy) then
			var0_50 = getProxy(PlayerProxy):getRawData().name
		else
			var0_50 = ""
		end
	elseif not UnGamePlayState and arg0_50.actor == var0_0.ACTOR_TYPE_TB then
		if pg.NewStoryMgr.GetInstance():IsReView() then
			assert(arg0_50.defaultTb and arg0_50.defaultTb > 0, "<<< defaultTb is nil >>>")

			local var4_50 = pg.secretary_special_ship[arg0_50.defaultTb]

			var0_50 = var4_50.name or ""
			var1_50 = var4_50.prefab
		elseif arg0_50.specialTbId then
			local var5_50 = pg.secretary_special_ship[arg0_50.specialTbId]

			assert(var5_50)

			var0_50 = var5_50.name or ""
			var1_50 = var5_50.prefab
		elseif getProxy(NewEducateProxy) and getProxy(NewEducateProxy):GetCurChar() then
			var1_50, var0_50 = getProxy(NewEducateProxy):GetStoryInfo()
		elseif EducateProxy and getProxy(EducateProxy) then
			var1_50, var0_50 = getProxy(EducateProxy):GetStoryInfo()
		else
			var0_50 = ""
		end
	elseif not arg0_50.actor or var1_0[arg0_50.actor] == nil then
		var0_50, var1_50 = nil
	else
		local var6_50 = var1_0[arg0_50.actor]
		local var7_50 = var6_50.ship_group
		local var8_50 = ShipGroup.getDefaultShipConfig(var7_50)

		if not var8_50 then
			var0_50 = var6_50.name
		else
			var0_50 = Ship.getShipName(var8_50.id)
		end

		var1_50 = var6_50.painting
	end

	return HXSet.hxLan(var0_50), var1_50
end

function var0_0.GetShipSkinId(arg0_51)
	if arg0_51.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var0_51 = getProxy(PlayerProxy):getRawData().character

		return getProxy(BayProxy):getShipById(var0_51).skinId
	elseif arg0_51.actor == var0_0.ACTOR_TYPE_PLAYER then
		return nil
	elseif not arg0_51.actor then
		return nil
	else
		return arg0_51.actor
	end
end

function var0_0.IsShowNPainting(arg0_52)
	return arg0_52.showNPainting
end

function var0_0.IsShowWJZPainting(arg0_53)
	return arg0_53.showWJZPainting
end

function var0_0.ShouldGrayPainting(arg0_54)
	return arg0_54.paingtingGray
end

function var0_0.ShouldAddGlitchArtEffect(arg0_55)
	return arg0_55.glitchArt
end

function var0_0.HideOtherPainting(arg0_56)
	return arg0_56.hideOtherPainting
end

function var0_0.GetSubPaintings(arg0_57)
	return _.map(arg0_57.subPaintings or {}, function(arg0_58)
		local var0_58 = pg.ship_skin_template[arg0_58.actor]

		assert(var0_58)

		return {
			actor = arg0_58.actor,
			name = var0_58.painting,
			expression = arg0_58.expression,
			pos = arg0_58.pos,
			dir = arg0_58.dir or 1,
			paintingNoise = arg0_58.paintingNoise or false,
			showNPainting = arg0_58.hidePaintObj or false
		}
	end)
end

function var0_0.NeedDispppearSubPainting(arg0_59)
	return #arg0_59.disappearSeq > 0
end

function var0_0.GetDisappearSeq(arg0_60)
	return arg0_60.disappearSeq
end

function var0_0.GetDisappearTime(arg0_61)
	return arg0_61.disappearTime[1], arg0_61.disappearTime[2]
end

function var0_0.IsNoHeadPainting(arg0_62)
	return arg0_62.nohead
end

function var0_0.GetFontSize(arg0_63)
	return arg0_63.fontSize
end

function var0_0.IsSpinePainting(arg0_64)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_64 = arg0_64:GetPainting()

	return tobool(var0_64 ~= nil and arg0_64.spine)
end

function var0_0.IsHideSpineBg(arg0_65)
	return arg0_65.spine == 1
end

function var0_0.GetSpineOrderIndex(arg0_66)
	if arg0_66:IsSpinePainting() then
		return arg0_66.spineOrderIndex
	else
		return nil
	end
end

function var0_0.IsLive2dPainting(arg0_67)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_67 = arg0_67:GetPainting()

	return tobool(var0_67 ~= nil and arg0_67.live2d)
end

function var0_0.GetLive2dPos(arg0_68)
	if arg0_68.live2dOffset then
		return Vector3(arg0_68.live2dOffset[1], arg0_68.live2dOffset[2], arg0_68.live2dOffset[3])
	end
end

function var0_0.GetVirtualShip(arg0_69)
	local var0_69 = arg0_69:GetShipSkinId()
	local var1_69 = pg.ship_skin_template[var0_69].ship_group

	return StoryShip.New({
		skin_id = var0_69
	})
end

function var0_0.GetLive2dAction(arg0_70)
	if type(arg0_70.live2d) == "string" then
		local var0_70 = pg.character_voice[arg0_70.live2d]

		if var0_70 then
			return var0_70.l2d_action
		end

		return arg0_70.live2d
	else
		return nil
	end
end

function var0_0.GetL2dIdleIndex(arg0_71)
	return arg0_71.live2dIdleIndex
end

function var0_0.GetSubActorName(arg0_72)
	if arg0_72.subActorName and arg0_72.subActorName ~= "" then
		local var0_72 = HXSet.hxLan(arg0_72.subActorName)

		return " " .. setColorStr(var0_72, arg0_72.subActorNameColor)
	else
		return ""
	end
end

function var0_0.IsSamePainting(arg0_73, arg1_73)
	local function var0_73()
		return arg1_73:ShouldAddGlitchArtEffect() or arg0_73:ShouldAddGlitchArtEffect()
	end

	return (function()
		return arg0_73:GetPainting() == arg1_73:GetPainting() and arg0_73:IsShowNPainting() == arg1_73:IsShowNPainting() and arg0_73:IsShowWJZPainting() == arg1_73:IsShowWJZPainting()
	end)() and arg0_73:IsLive2dPainting() == arg1_73:IsLive2dPainting() and arg0_73:IsSpinePainting() == arg1_73:IsSpinePainting() and not var0_73()
end

function var0_0.ExistCanMarkNode(arg0_76)
	return arg0_76.canMarkNode ~= nil and type(arg0_76.canMarkNode) == "table" and arg0_76.canMarkNode[1] and arg0_76.canMarkNode[1] ~= "" and arg0_76.canMarkNode[2] and type(arg0_76.canMarkNode[2]) == "table"
end

function var0_0.GetCanMarkNodeData(arg0_77)
	local var0_77 = {}

	for iter0_77, iter1_77 in ipairs(arg0_77.canMarkNode[2] or {}) do
		table.insert(var0_77, iter1_77 .. "")
	end

	return {
		name = arg0_77.canMarkNode[1],
		marks = var0_77
	}
end

function var0_0.OnClear(arg0_78)
	return
end

function var0_0.GetUsingPaintingNames(arg0_79)
	local var0_79 = {}
	local var1_79 = arg0_79:GetPainting()

	if var1_79 ~= nil then
		table.insert(var0_79, var1_79)
	end

	local var2_79 = arg0_79:GetSubPaintings()

	for iter0_79, iter1_79 in ipairs(var2_79) do
		local var3_79 = iter1_79.name

		table.insert(var0_79, var3_79)
	end

	return var0_79
end

return var0_0
