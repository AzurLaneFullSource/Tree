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

function var0_0.ShouldGlitchArtForPortrait(arg0_10)
	return arg0_10.glitchArtForPortrait
end

function var0_0.GetMode(arg0_11)
	return Story.MODE_DIALOGUE
end

function var0_0.GetContentBGAlpha(arg0_12)
	return arg0_12.contentBGAlpha
end

function var0_0.GetSpineExPression(arg0_13)
	if arg0_13.expression then
		return arg0_13.expression
	end
end

function var0_0.GetExPression(arg0_14)
	if arg0_14.expression then
		return arg0_14.expression
	else
		local var0_14 = arg0_14:GetPainting()

		if var0_14 and ShipExpressionHelper.DefaultFaceless(var0_14) then
			return ShipExpressionHelper.GetDefaultFace(var0_14)
		end
	end
end

function var0_0.ShouldAddHeadMaskWhenFade(arg0_15)
	if arg0_15:ShouldAddGlitchArtEffect() then
		return false
	end

	if arg0_15:IsNoHeadPainting() then
		return false
	end

	if not arg0_15:GetExPression() then
		return false
	end

	return true
end

function var0_0.ShouldGrayingPainting(arg0_16, arg1_16)
	return arg1_16:GetPainting() ~= nil and not arg0_16:IsSameSide(arg1_16)
end

function var0_0.ShouldGrayingOutPainting(arg0_17, arg1_17)
	return arg0_17:GetPainting() ~= nil and not arg0_17:IsSameSide(arg1_17)
end

function var0_0.ShouldFadeInPainting(arg0_18)
	if not arg0_18:GetPainting() then
		return false
	end

	if arg0_18:IsLive2dPainting() or arg0_18:IsSpinePainting() then
		return false
	end

	local var0_18 = arg0_18:GetFadeInPaintingTime()

	if not var0_18 or var0_18 <= 0 then
		return false
	end

	return true
end

function var0_0.GetTypewriter(arg0_19)
	return arg0_19.typewriter
end

function var0_0.ShouldFaceBlack(arg0_20)
	return arg0_20.actorShadow
end

function var0_0.GetPaintingData(arg0_21)
	local var0_21 = arg0_21.painting or {}

	return {
		alpha = var0_21.alpha or 0.3,
		time = var0_21.time or 1
	}
end

function var0_0.GetFadeInPaintingTime(arg0_22)
	return arg0_22.fadeInPaintingTime
end

function var0_0.GetFadeOutPaintingTime(arg0_23)
	return arg0_23.fadeOutPaintingTime
end

function var0_0.GetPaintingDir(arg0_24)
	local var0_24 = arg0_24.paingtingScale or 1

	return (arg0_24.dir or 1) * var0_24
end

function var0_0.ShouldFlipPaintingY(arg0_25)
	return arg0_25.paingtingYFlip ~= nil
end

function var0_0.GetTag(arg0_26)
	if arg0_26.glitchArt == true then
		return 2
	else
		return 1
	end
end

function var0_0.GetPaintingAlpha(arg0_27)
	return arg0_27.actorAlpha
end

function var0_0.GetPaitingOffst(arg0_28)
	return arg0_28.actorPosition
end

function var0_0.GetSound(arg0_29)
	return arg0_29.sound
end

function var0_0.GetPaintingActions(arg0_30)
	return arg0_30.action
end

function var0_0.GetPaintingMoveToSide(arg0_31)
	return arg0_31.moveSideData
end

function var0_0.ShouldMoveToSide(arg0_32)
	return arg0_32.moveSideData ~= nil
end

function var0_0.GetPaintingAction(arg0_33, arg1_33)
	local var0_33 = {}
	local var1_33 = arg0_33:GetPaintingActions()

	for iter0_33, iter1_33 in ipairs(var1_33) do
		if iter1_33.type == arg1_33 then
			table.insert(var0_33, iter1_33)
		end
	end

	return var0_33
end

function var0_0.GetSide(arg0_34)
	return arg0_34.side
end

function var0_0.GetContent(arg0_35)
	if not arg0_35.say then
		return "..."
	end

	local var0_35 = arg0_35.say

	if arg0_35:ShouldReplacePlayer() then
		var0_35 = arg0_35:ReplacePlayerName(var0_35)
	end

	if arg0_35:ShouldReplaceTb() then
		var0_35 = arg0_35:ReplaceTbName(var0_35)
	end

	if arg0_35:ShouldReplaceDorm() then
		var0_35 = arg0_35:ReplaceDormName(var0_35)
	end

	if PLATFORM_CODE ~= PLATFORM_US then
		var0_35 = SwitchSpecialChar(HXSet.hxLan(var0_35), true)
	else
		var0_35 = HXSet.hxLan(var0_35)
	end

	return var0_35
end

function var0_0.GetNameWithColor(arg0_36)
	local var0_36 = arg0_36:GetName()

	if not var0_36 then
		return nil
	end

	local var1_36 = arg0_36:GetNameColor()

	return setColorStr(var0_36, var1_36)
end

function var0_0.GetNameColor(arg0_37)
	return arg0_37.nameColor or COLOR_WHITE
end

function var0_0.GetNameColorCode(arg0_38)
	local var0_38 = arg0_38:GetNameColor()

	return string.gsub(var0_38, "#", "")
end

function var0_0.GetCustomActorName(arg0_39)
	if type(arg0_39.actorName) == "number" and arg0_39.actorName == 0 and getProxy(PlayerProxy) then
		return getProxy(PlayerProxy):getRawData().name
	elseif type(arg0_39.actorName) == "number" then
		return ShipGroup.getDefaultShipNameByGroupID(arg0_39.actorName)
	elseif type(arg0_39.actorName) == "string" then
		return arg0_39.actorName
	else
		return ""
	end
end

function var0_0.GetPortraitName(arg0_40)
	if not arg0_40:ExistPortrait() then
		return ""
	end

	if type(arg0_40.portrait) ~= "number" then
		return ""
	end

	local var0_40 = var1_0[arg0_40.portrait]

	if not var0_40 then
		return ""
	end

	local var1_40 = ""
	local var2_40 = var0_40.ship_group
	local var3_40 = ShipGroup.getDefaultShipConfig(var2_40)

	if not var3_40 then
		var1_40 = var0_40.name
	else
		var1_40 = Ship.getShipName(var3_40.id)
	end

	return var1_40
end

function var0_0.GetName(arg0_41)
	local var0_41 = arg0_41.actorName and arg0_41:GetCustomActorName() or arg0_41:GetPaintingAndName() or ""

	if not var0_41 or var0_41 == "" then
		var0_41 = arg0_41:GetPortraitName()
	end

	if not var0_41 or var0_41 == "" or arg0_41.withoutActorName then
		return nil
	end

	if arg0_41:ShouldReplacePlayer() then
		var0_41 = arg0_41:ReplacePlayerName(var0_41)
	end

	if arg0_41:ShouldReplaceTb() then
		var0_41 = arg0_41:ReplaceTbName(var0_41)
	end

	return (HXSet.hxLan(var0_41))
end

function var0_0.GetPainting(arg0_42)
	local var0_42, var1_42 = arg0_42:GetPaintingAndName()

	return var1_42
end

function var0_0.ExistPainting(arg0_43)
	return arg0_43:GetPainting() ~= nil
end

function var0_0.ShouldShakeDailogue(arg0_44)
	return arg0_44.dialogShake ~= nil
end

function var0_0.GetShakeDailogueData(arg0_45)
	return arg0_45.dialogShake
end

function var0_0.IsSameSide(arg0_46, arg1_46)
	local var0_46 = arg0_46:GetPrevSide(arg1_46)
	local var1_46 = arg0_46:GetSide()

	return var0_46 ~= nil and var1_46 ~= nil and var0_46 == var1_46
end

function var0_0.GetPrevSide(arg0_47, arg1_47)
	local var0_47 = arg1_47:GetSide()

	if arg0_47.moveSideData then
		var0_47 = arg0_47.moveSideData.side
	end

	return var0_47
end

function var0_0.GetPaintingIcon(arg0_48)
	local var0_48

	if arg0_48.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var1_48 = getProxy(PlayerProxy):getRawData().character

		var0_48 = getProxy(BayProxy):getShipById(var1_48):getPrefab()
	else
		var0_48 = (arg0_48.actor ~= var0_0.ACTOR_TYPE_PLAYER or nil) and (arg0_48.actor ~= var0_0.ACTOR_TYPE_TB or nil) and (arg0_48.actor or nil) and (not arg0_48.hideRecordIco or nil) and var1_0[arg0_48.actor].prefab
	end

	if var0_48 == nil and arg0_48:ExistPortrait() then
		var0_48 = arg0_48:GetPortrait()
	end

	return var0_48
end

function var0_0.GetPaintingAndName(arg0_49)
	local var0_49
	local var1_49

	if not UnGamePlayState and arg0_49.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var2_49 = getProxy(PlayerProxy):getRawData().character
		local var3_49 = getProxy(BayProxy):getShipById(var2_49)

		var0_49 = var3_49:getName()
		var1_49 = var3_49:getPainting()
	elseif not UnGamePlayState and arg0_49.actor == var0_0.ACTOR_TYPE_PLAYER then
		if getProxy(PlayerProxy) then
			var0_49 = getProxy(PlayerProxy):getRawData().name
		else
			var0_49 = ""
		end
	elseif not UnGamePlayState and arg0_49.actor == var0_0.ACTOR_TYPE_TB then
		if pg.NewStoryMgr.GetInstance():IsReView() then
			assert(arg0_49.defaultTb and arg0_49.defaultTb > 0, "<<< defaultTb is nil >>>")

			local var4_49 = pg.secretary_special_ship[arg0_49.defaultTb]

			var0_49 = var4_49.name or ""
			var1_49 = var4_49.prefab
		elseif arg0_49.specialTbId then
			local var5_49 = pg.secretary_special_ship[arg0_49.specialTbId]

			assert(var5_49)

			var0_49 = var5_49.name or ""
			var1_49 = var5_49.prefab
		elseif EducateProxy and getProxy(EducateProxy) then
			var1_49, var0_49 = getProxy(EducateProxy):GetStoryInfo()
		else
			var0_49 = ""
		end
	elseif not arg0_49.actor or var1_0[arg0_49.actor] == nil then
		var0_49, var1_49 = nil
	else
		local var6_49 = var1_0[arg0_49.actor]
		local var7_49 = var6_49.ship_group
		local var8_49 = ShipGroup.getDefaultShipConfig(var7_49)

		if not var8_49 then
			var0_49 = var6_49.name
		else
			var0_49 = Ship.getShipName(var8_49.id)
		end

		var1_49 = var6_49.painting
	end

	return HXSet.hxLan(var0_49), var1_49
end

function var0_0.GetShipSkinId(arg0_50)
	if arg0_50.actor == var0_0.ACTOR_TYPE_FLAGSHIP then
		local var0_50 = getProxy(PlayerProxy):getRawData().character

		return getProxy(BayProxy):getShipById(var0_50).skinId
	elseif arg0_50.actor == var0_0.ACTOR_TYPE_PLAYER then
		return nil
	elseif not arg0_50.actor then
		return nil
	else
		return arg0_50.actor
	end
end

function var0_0.IsShowNPainting(arg0_51)
	return arg0_51.showNPainting
end

function var0_0.IsShowWJZPainting(arg0_52)
	return arg0_52.showWJZPainting
end

function var0_0.ShouldGrayPainting(arg0_53)
	return arg0_53.paingtingGray
end

function var0_0.ShouldAddGlitchArtEffect(arg0_54)
	return arg0_54.glitchArt
end

function var0_0.HideOtherPainting(arg0_55)
	return arg0_55.hideOtherPainting
end

function var0_0.GetSubPaintings(arg0_56)
	return _.map(arg0_56.subPaintings or {}, function(arg0_57)
		local var0_57 = pg.ship_skin_template[arg0_57.actor]

		assert(var0_57)

		return {
			actor = arg0_57.actor,
			name = var0_57.painting,
			expression = arg0_57.expression,
			pos = arg0_57.pos,
			dir = arg0_57.dir or 1,
			paintingNoise = arg0_57.paintingNoise or false,
			showNPainting = arg0_57.hidePaintObj or false
		}
	end)
end

function var0_0.NeedDispppearSubPainting(arg0_58)
	return #arg0_58.disappearSeq > 0
end

function var0_0.GetDisappearSeq(arg0_59)
	return arg0_59.disappearSeq
end

function var0_0.GetDisappearTime(arg0_60)
	return arg0_60.disappearTime[1], arg0_60.disappearTime[2]
end

function var0_0.IsNoHeadPainting(arg0_61)
	return arg0_61.nohead
end

function var0_0.GetFontSize(arg0_62)
	return arg0_62.fontSize
end

function var0_0.IsSpinePainting(arg0_63)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_63 = arg0_63:GetPainting()

	return tobool(var0_63 ~= nil and arg0_63.spine)
end

function var0_0.IsHideSpineBg(arg0_64)
	return arg0_64.spine == 1
end

function var0_0.GetSpineOrderIndex(arg0_65)
	if arg0_65:IsSpinePainting() then
		return arg0_65.spineOrderIndex
	else
		return nil
	end
end

function var0_0.IsLive2dPainting(arg0_66)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		return false
	end

	local var0_66 = arg0_66:GetPainting()

	return tobool(var0_66 ~= nil and arg0_66.live2d)
end

function var0_0.GetLive2dPos(arg0_67)
	if arg0_67.live2dOffset then
		return Vector3(arg0_67.live2dOffset[1], arg0_67.live2dOffset[2], arg0_67.live2dOffset[3])
	end
end

function var0_0.GetVirtualShip(arg0_68)
	local var0_68 = arg0_68:GetShipSkinId()
	local var1_68 = pg.ship_skin_template[var0_68].ship_group

	return StoryShip.New({
		skin_id = var0_68
	})
end

function var0_0.GetLive2dAction(arg0_69)
	if type(arg0_69.live2d) == "string" then
		local var0_69 = pg.character_voice[arg0_69.live2d]

		if var0_69 then
			return var0_69.l2d_action
		end

		return arg0_69.live2d
	else
		return nil
	end
end

function var0_0.GetL2dIdleIndex(arg0_70)
	return arg0_70.live2dIdleIndex
end

function var0_0.GetSubActorName(arg0_71)
	if arg0_71.subActorName and arg0_71.subActorName ~= "" then
		local var0_71 = HXSet.hxLan(arg0_71.subActorName)

		return " " .. setColorStr(var0_71, arg0_71.subActorNameColor)
	else
		return ""
	end
end

function var0_0.IsSamePainting(arg0_72, arg1_72)
	local function var0_72()
		return arg1_72:ShouldAddGlitchArtEffect() or arg0_72:ShouldAddGlitchArtEffect()
	end

	return (function()
		return arg0_72:GetPainting() == arg1_72:GetPainting() and arg0_72:IsShowNPainting() == arg1_72:IsShowNPainting() and arg0_72:IsShowWJZPainting() == arg1_72:IsShowWJZPainting()
	end)() and arg0_72:IsLive2dPainting() == arg1_72:IsLive2dPainting() and arg0_72:IsSpinePainting() == arg1_72:IsSpinePainting() and not var0_72()
end

function var0_0.ExistCanMarkNode(arg0_75)
	return arg0_75.canMarkNode ~= nil and type(arg0_75.canMarkNode) == "table" and arg0_75.canMarkNode[1] and arg0_75.canMarkNode[1] ~= "" and arg0_75.canMarkNode[2] and type(arg0_75.canMarkNode[2]) == "table"
end

function var0_0.GetCanMarkNodeData(arg0_76)
	local var0_76 = {}

	for iter0_76, iter1_76 in ipairs(arg0_76.canMarkNode[2] or {}) do
		table.insert(var0_76, iter1_76 .. "")
	end

	return {
		name = arg0_76.canMarkNode[1],
		marks = var0_76
	}
end

function var0_0.OnClear(arg0_77)
	return
end

function var0_0.GetUsingPaintingNames(arg0_78)
	local var0_78 = {}
	local var1_78 = arg0_78:GetPainting()

	if var1_78 ~= nil then
		table.insert(var0_78, var1_78)
	end

	local var2_78 = arg0_78:GetSubPaintings()

	for iter0_78, iter1_78 in ipairs(var2_78) do
		local var3_78 = iter1_78.name

		table.insert(var0_78, var3_78)
	end

	return var0_78
end

return var0_0
